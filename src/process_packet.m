% MIT License
% 
% Copyright (c) [2025] [Name/Affiliation]
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% =========================================================================
% Function: process_packet
% Purpose: Core packet forwarding logic, including reverse flow generation (RF-CF/RF-LF)
% Inputs:
%   - packet: Packet structure (index, source, dest, path, hop, color)
%   - current_time: Current simulation time (seconds)
% Output:
%   - process_result: Integer code (0: dropped; 1: forwarded; 2: reached destination)
% =========================================================================
function process_result = process_packet(packet, current_time)
    global routing_table link_status MPC adjacency source_dest_stats hop_limit;
    
    current_node = packet.path{end}(1:5);
    
    in_interface = [];
    if length(packet.path{end}) > 5
        in_interface = packet.path{end}(12:22);
    end
    
    if ~isempty(in_interface)
        if link_status(in_interface) == 0
            fprintf('[Timeout] Packet %d was dropped at node %s due to input interface failure\n', packet.index, current_node);
            % Update drop statistics for aware delay
            src = packet.source;
            dest = packet.dest;
            if ~isKey(source_dest_stats, src)
                source_dest_stats(src) = containers.Map();
            end
            tmp_map = source_dest_stats(src);
            if ~isKey(tmp_map, dest)
                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0,'dropped_awaredelay',0);
            end
            stats = tmp_map(dest);
            stats.dropped_awaredelay = stats.dropped_awaredelay + 1;
            stats.dropped = stats.dropped + 1;
            tmp_map(dest) = stats;
            source_dest_stats(src) = tmp_map;
            process_result = 0; % Packet dropped
            return;
        else
            packet.hop = packet.hop - 1;
            fprintf('Packet %d arrived at node %s from link %s \n',  packet.index, current_node, in_interface);
            process_result = 1; % Packet forwarded
            % Check hop limit
            if packet.hop <= 0 && ~strcmp(current_node, packet.dest)
                fprintf('[Timeout] Packet %d was dropped at node %s due to hop limit exceeded\n', packet.index, current_node);
                % Update drop statistics for hop limit
                src = packet.source;
                dest = packet.dest;
                if ~isKey(source_dest_stats, src)
                    source_dest_stats(src) = containers.Map();
                end
                tmp_map = source_dest_stats(src);
                if ~isKey(tmp_map, dest)
                    tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                end
                stats = tmp_map(dest);
                stats.dropped_hoplimits = stats.dropped_hoplimits + 1;
                stats.dropped = stats.dropped + 1;
                tmp_map(dest) = stats;
                source_dest_stats(src) = tmp_map;
                process_result = 0; % Packet dropped
                return;
            end
        end
    end

    
    % Check if current node is destination
    if strcmp(current_node, packet.dest)
        % Calculate actual hops taken
        actual_hops = hop_limit - packet.hop;
        
        % Update received statistics
        src = packet.source;
        dest = packet.dest;
        if ~isKey(source_dest_stats, src)
            source_dest_stats(src) = containers.Map();
        end
        tmp_map = source_dest_stats(src);
        if ~isKey(tmp_map, dest)
            tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'total_hops',0, 'packet_count',0);
        end
        stats = tmp_map(dest);
        stats.received = stats.received + 1;  % Increment received count
        stats.total_hops = stats.total_hops + actual_hops;  % Accumulate total hops
        stats.packet_count = stats.packet_count + 1;        % Increment packet count
        if actual_hops > stats.max_hops
            stats.max_hops = actual_hops;
        end
        tmp_map(dest) = stats;
        source_dest_stats(src) = tmp_map;
        
        fprintf('>>>> Packet %d reached destination! Actual hops: %d Path: %s\n',...
        packet.index, actual_hops, strjoin(packet.path, ' -> '));
        process_result = 2; % Packet reached destination
        return;
    end
    
    if ~strcmp(current_node, packet.dest)
        if ~isfield(routing_table, current_node)
            fprintf('Error: Node %s does not exist in routing table\n', current_node);
            return;
        end

        if ~isKey(routing_table.(current_node), packet.dest)
            fprintf('Node %s has no route to %s\n', current_node, packet.dest);
            return;
        end
    end
    
    % Determine outgoing interface from routing table
    out_interface = routing_table.(current_node)(packet.dest);
    
    % ========== Handle backup interface for link failure ==========
    backup_out_interface = [];
    if link_status(out_interface) == 0 % Check if primary interface is faulty
        if MPC == 0 % No backup mechanism
            fprintf('[Fault] Outgoing interface %s unavailable, packet %d dropped at %s\n', out_interface,packet.index, current_node);
            % Update drop statistics for link failure
            src = packet.source;
            dest = packet.dest;
            if ~isKey(source_dest_stats, src)
                source_dest_stats(src) = containers.Map();
            end
            tmp_map = source_dest_stats(src);
            if ~isKey(tmp_map, dest)
                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
            end
            stats = tmp_map(dest);
            stats.dropped_linkfault = stats.dropped_linkfault + 1;
            stats.dropped = stats.dropped + 1;  % Increment drop count
            tmp_map(dest) = stats;
            source_dest_stats(src) = tmp_map;
            process_result = 0; % Packet dropped
            return;
        end
        if MPC == 1 % Use backup mechanism
            if ~isempty(in_interface)
                if adjacency(current_node).Count == 2 % Node has 2 neighbors
                    % Get incoming neighbor from interface
                    in_neighbor = strsplit(in_interface, '-');
                    in_neighbor = in_neighbor{1};
                    new_out_interface = [current_node '-' in_neighbor];
                    % Check backup interface status
                    if link_status(new_out_interface) == 1
                        backup_out_interface = new_out_interface;
                        fprintf('Found backup interface %s, forwarding\n',...
                            new_out_interface);
                    else
                        fprintf('[Fault] Backup interface %s unavailable, packet %d dropped at %s\n',...
                            new_out_interface, packet.index, current_node);
                        % Update drop statistics for interface link failure
                        src = packet.source;
                        dest = packet.dest;
                        if ~isKey(source_dest_stats, src)
                            source_dest_stats(src) = containers.Map();
                        end
                        tmp_map = source_dest_stats(src);
                        if ~isKey(tmp_map, dest)
                            tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                        end
                        stats = tmp_map(dest);
                        stats.dropped_IFlinkfault = stats.dropped_IFlinkfault + 1;
                        stats.dropped = stats.dropped + 1;  % Increment drop count
                        tmp_map(dest) = stats;
                        source_dest_stats(src) = tmp_map;
                        process_result = 0; % Packet dropped
                        return;
                    end
                end
                
                if adjacency(current_node).Count == 4 % Node has 4 neighbors
                    neighbors = keys(adjacency(current_node));
                    % Get incoming neighbor from interface
                    in_neighbor = strsplit(in_interface, '-');
                    in_neighbor = in_neighbor{1};
                    
                    % Check if current node and destination are in the same subnetwork
                    if strcmp(current_node(2:3),packet.dest(2:3))
                        [m,n] = size(neighbors);
                        for i=1:n % Iterate through neighbors
                            if strcmp(current_node(2:3),neighbors{i}(2:3)) && ~strcmp(neighbors{i},out_interface(end-4:end))
                                out_neighbor = neighbors{i};
                                break;
                            end
                        end
                        new_out_interface = [current_node '-' out_neighbor] ;
                        % Check backup interface status
                        if link_status(new_out_interface) == 1
                            backup_out_interface = new_out_interface;
                            fprintf('Found backup interface %s, forwarding\n',...
                                new_out_interface);
                        else
                            fprintf('[Fault] Backup interface %s unavailable, packet %d dropped at %s\n',...
                                new_out_interface, packet.index, current_node);
                            % Update drop statistics for interface link failure
                            src = packet.source;
                            dest = packet.dest;
                            if ~isKey(source_dest_stats, src)
                                source_dest_stats(src) = containers.Map();
                            end
                            tmp_map = source_dest_stats(src);
                            if ~isKey(tmp_map, dest)
                                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                            end
                            stats = tmp_map(dest);
                            stats.dropped_IFlinkfault = stats.dropped_IFlinkfault + 1;
                            stats.dropped = stats.dropped + 1;  % Increment drop count
                            tmp_map(dest) = stats;
                            source_dest_stats(src) = tmp_map;
                            process_result = 0; % Packet dropped
                            return;
                        end
                    % Current node and destination are in different subnetworks
                    elseif ~strcmp(current_node(2:3),packet.dest(2:3))
                        [m,n] = size(neighbors);
                        for i=1:n % Iterate through neighbors
                            if ~strcmp(current_node(2:3),neighbors{i}(2:3)) && ~strcmp(neighbors{i},out_interface(end-4:end))
                                out_neighbor = neighbors{i};
                                break;
                            end
                        end
                        new_out_interface = [current_node '-' out_neighbor] ;
                        % Check backup interface status
                        if link_status(new_out_interface) == 1
                            backup_out_interface = new_out_interface;
                            fprintf('Found backup interface %s, forwarding\n',...
                                new_out_interface);
                        else
                            fprintf('[Fault] Backup interface %s unavailable, packet %d dropped at %s\n',...
                                new_out_interface, packet.index, current_node);
                            % Update drop statistics for interface link failure
                            src = packet.source;
                            dest = packet.dest;
                            if ~isKey(source_dest_stats, src)
                                source_dest_stats(src) = containers.Map();
                            end
                            tmp_map = source_dest_stats(src);
                            if ~isKey(tmp_map, dest)
                                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                            end
                            stats = tmp_map(dest);
                            stats.dropped_IFlinkfault = stats.dropped_IFlinkfault + 1;
                            stats.dropped = stats.dropped + 1;  % Increment drop count
                            tmp_map(dest) = stats;
                            source_dest_stats(src) = tmp_map;
                            process_result = 0; % Packet dropped
                            return;
                        end
                    end
                end   
            end
        end
    end
    
    if link_status(out_interface) == 1 % Primary interface is working
        if MPC == 0 % No backup mechanism
            % Forward packet through primary interface
        end
        if MPC == 1 % Use backup mechanism
            if ~isempty(in_interface)
                % Get incoming interface details
                in_neighbor = strsplit(in_interface, '-');
                equal_in_neighbor = [in_neighbor{2} '-' in_neighbor{1}];
                if strcmp(equal_in_neighbor, out_interface) % Check interface equivalence
                    if adjacency(current_node).Count == 2 % Node has 2 neighbors
                        % Get all neighbors
                        neighbors = keys(adjacency(current_node));
                        % Get incoming neighbor from interface
                        in_neighbor = strsplit(in_interface, '-');
                        in_neighbor = in_neighbor{1};
                        % Find outgoing neighbor (excluding incoming)
                        out_neighbor = setdiff(neighbors, {in_neighbor});
                        if ~isempty(out_neighbor)
                            new_out_interface = [current_node '-' out_neighbor{1}];
                            % Check backup interface status
                            if link_status(new_out_interface) == 1
                                backup_out_interface = new_out_interface;
                                fprintf('Found backup interface %s, forwarding\n',...
                                    new_out_interface);
                            else
                                fprintf('[Fault] Backup interface %s unavailable, packet %d dropped at %s\n',...
                                    new_out_interface, packet.index, current_node);
                                % Update drop statistics for interface link failure
                                src = packet.source;
                                dest = packet.dest;
                                if ~isKey(source_dest_stats, src)
                                    source_dest_stats(src) = containers.Map();
                                end
                                tmp_map = source_dest_stats(src);
                                if ~isKey(tmp_map, dest)
                                    tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                                end
                                stats = tmp_map(dest);
                                stats.dropped_IFlinkfault = stats.dropped_IFlinkfault + 1;
                                stats.dropped = stats.dropped + 1;  % Correct field
                                tmp_map(dest) = stats;
                                source_dest_stats(src) = tmp_map;
                                process_result = 0; % Record dropped state
                                return;
                            end
                        end
                    end
                    
                    if adjacency(current_node).Count == 4 % If it's a 4-degree node
                        
                        
                        % Get all neighbors of current node
                        neighbors = keys(adjacency(current_node));
                        % Extract source node from input interface
                        in_neighbor = strsplit(in_interface, '-');
                        in_neighbor = in_neighbor{1};
                        
                        % Check if destination node is in the same channel as current node
                        % If same channel, reverse transmit packet from opposite link
                        if strcmp(current_node(2:3),packet.dest(2:3))
                            [m,n] = size(neighbors);
                            for i=1:n % Search all neighbors
                                if strcmp(current_node(2:3),neighbors{i}(2:3)) && ~strcmp(neighbors{i},in_interface(1:5))% If there's a neighbor in same channel and not current input interface, determine it as next hop (opposite interface)
                                    out_neighbor = neighbors{i};
                                    break;
                                end
                            end
                            new_out_interface = [current_node '-' out_neighbor];
                             % Verify new link status
                            if link_status(new_out_interface) == 1
                                backup_out_interface = new_out_interface;
                                fprintf('Found backup interface %s, forwarding',...
                                    new_out_interface);
                            else
                                fprintf('[Fault] Backup interface %s unavailable, packet %d dropped at %s\n',...
                                    new_out_interface, packet.index, current_node);
                                % Update receive counter
                                src = packet.source;
                                dest = packet.dest;
                                if ~isKey(source_dest_stats, src)
                                    source_dest_stats(src) = containers.Map();
                                end
                                tmp_map = source_dest_stats(src);
                                if ~isKey(tmp_map, dest)
                                    tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                                end
                                stats = tmp_map(dest);
                                stats.dropped_IFlinkfault = stats.dropped_IFlinkfault + 1;
                                stats.dropped = stats.dropped + 1;  % Correct field
                                tmp_map(dest) = stats;
                                source_dest_stats(src) = tmp_map;
                                process_result = 0; % Record dropped state
                                return;
                            end
                        % If different channels, transmit through cross-channel link, i.e., backward transmission
                        elseif ~strcmp(current_node(2:3),packet.dest(2:3))
                             [m,n] = size(neighbors);
                            for i=1:n % Search all neighbors
                                if ~strcmp(current_node(2:3),neighbors{i}(2:3)) && ~strcmp(neighbors{i},out_interface(end-4:end))% If there's a neighbor in different channel and not current output interface (also input interface due to reverse flow), determine it as next hop (select non-faulty lateral interface)
                                    out_neighbor = neighbors{i};
                                    break;
                                end
                            end
                            new_out_interface = [current_node '-' out_neighbor] ;
                             % Verify new link status
                            if link_status(new_out_interface) == 1
                                backup_out_interface = new_out_interface;
                                fprintf('Found backup interface %s, forwarding',...
                                    new_out_interface);
                            else
                                fprintf('[Fault] Backup interface %s unavailable, packet %d dropped at %s\n',...
                                    new_out_interface, packet.index, current_node);
                                % Update receive counter
                                src = packet.source;
                                dest = packet.dest;
                                if ~isKey(source_dest_stats, src)
                                    source_dest_stats(src) = containers.Map();
                                end
                                tmp_map = source_dest_stats(src);
                                if ~isKey(tmp_map, dest)
                                    tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0);
                                end
                                stats = tmp_map(dest);
                                stats.dropped_IFlinkfault = stats.dropped_IFlinkfault + 1;
                                stats.dropped = stats.dropped + 1;  % Correct field
                                tmp_map(dest) = stats;
                                source_dest_stats(src) = tmp_map;
                                process_result = 0; % Record dropped state
                                return;
                            end
                            
                            
                        end
                        
                    end
                        
                end
            end
        end
    end   

    % Update backup output interface as final output interface
    if ~isempty(backup_out_interface)
        out_interface = backup_out_interface;
             % Update receive counter
            src = packet.source;
            dest = packet.dest;
            if ~isKey(source_dest_stats, src)
                source_dest_stats(src) = containers.Map();
            end
            tmp_map = source_dest_stats(src);
            if ~isKey(tmp_map, dest)
                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_IFlinkfault',0,'IFforward',0);
            end
            stats = tmp_map(dest);
            stats.IFforward = stats.IFforward + 1; % Record reverse flow forwarding count
            tmp_map(dest) = stats;
            source_dest_stats(src) = tmp_map;
            process_result = 0; % Record dropped state
    else
        %fprintf('[Error] No output interface found\n')
    end
    
    next_node = strsplit(out_interface, '-');
    next_node = next_node{2};
    
    packet.path{end+1} = [next_node '  via ' out_interface];
    
    arrival_time = current_time + 1;
    insertEvent(arrival_time, 'PacketArrived', packet);
end