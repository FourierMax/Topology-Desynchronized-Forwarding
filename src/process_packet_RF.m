% MIT License
% 
% Copyright (c) [2025] [Shenshen Luan/Beihang University]
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


function process_result = process_packet_RF(packet, current_time)
    % Process the received RF packet and update relevant statistics and routing information
    % 
    % Inputs:
    %   packet - The received packet structure containing fields like path, source, dest, hop, index, etc.
    %   current_time - Current timestamp when the packet is processed
    % 
    % Outputs:
    %   process_result - Result of processing: 0 (dropped), 1 (forwarded), 2 (received at destination)
    % 
    % Global Variables:
    %   routing_table - Routing table storing next-hop information for each node
    %   link_status - Status of network links (1 for active, 0 for faulty)
    %   MPC - Multi-path configuration flag (0 for single-path, 1 for multi-path)
    %   adjacency - Adjacency list of the current node
    %   source_dest_stats - Statistics map tracking packet transmission status between source and destination
    %   hop_limit - Maximum allowed hop count for a packet
    %   Opposite_side_FIRST - Flag indicating priority for opposite side interfaces in multi-path routing
    
    global routing_table link_status MPC adjacency source_dest_stats hop_limit Opposite_side_FIRST;
    
    % Extract current node ID from the last entry in packet path
    current_node = packet.path{end}(1:5);
    
    % Initialize input interface variable
    in_interface = [];
    
    % Extract input interface from the last entry in packet path if available
    if length(packet.path{end}) > 5
        in_interface = packet.path{end}(12:22);
    end
    
    % Check if input interface is valid and process link status
    if ~isempty(in_interface)
        % Drop packet if input interface is faulty
        if link_status(in_interface) == 0
            fprintf('[Link Fault] Packet %d dropped at node %s due to faulty input interface\n', packet.index, current_node);
            
            % Update drop statistics for source-destination pair
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
            
            process_result = 0;  % Indicate packet dropped
            return;
        else
            % Decrement hop count when packet is received through valid interface
            packet.hop = packet.hop - 1;
            fprintf('Packet %d received at %s via interface %s \n',  packet.index, current_node, in_interface);
            process_result = 1;  % Indicate initial processing success
            
            % Drop packet if hop limit is exceeded and not at destination
            if packet.hop <= 0 && ~strcmp(current_node, packet.dest)
                fprintf('[Hop Limit Exceeded] Packet %d dropped at node %s (hop count exhausted)\n', packet.index, current_node);
                
                % Update hop limit drop statistics
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
                
                process_result = 0;  % Indicate packet dropped
                return;
            end
        end
    end

    
    % Check if current node is the destination
    if strcmp(current_node, packet.dest)
        % Calculate actual hops taken (hop limit - remaining hops)
        actual_hops = hop_limit - packet.hop;
        
        % Update reception statistics for source-destination pair
        src = packet.source;
        dest = packet.dest;
        if ~isKey(source_dest_stats, src)
            source_dest_stats(src) = containers.Map();
        end
        tmp_map = source_dest_stats(src);
        if ~isKey(tmp_map, dest)
            tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'max_hops', 0,'total_hops',0, 'packet_count',0);
        end
        stats = tmp_map(dest);
        stats.received = stats.received + 1;  % Increment received count
        stats.total_hops = stats.total_hops + actual_hops;  % Accumulate total hops
        stats.packet_count = stats.packet_count + 1;        % Increment packet count
        stats.IFforward = stats.IFforward + packet.if_forward_count;  % Update IF forward count
        
        % Update maximum hops if current hop count is higher
        if actual_hops > stats.max_hops
            stats.max_hops = actual_hops;
        end
        
        % Update IF forward packet count if applicable
        if packet.if_forward_count > 0
            stats.IFforward_Packetcount = stats.IFforward_Packetcount + 1;
        end

        tmp_map(dest) = stats;
        source_dest_stats(src) = tmp_map;
        
        fprintf('>>>> Packet %d successfully delivered! Total hops: %d Path: %s\n',...
            packet.index, actual_hops, strjoin(packet.path, ' -> '));  % Log delivery details
        process_result = 2;  % Indicate successful delivery
        return;
    end
    
    % Check routing table and adjacency if not at destination
    if ~strcmp(current_node, packet.dest)
        % Log error and return if current node not in routing table
        if ~isfield(routing_table, current_node)
            fprintf('Routing table entry missing for node %s\n', current_node);
            return;
        end

        % Log error and return if no route to destination
        if ~isKey(routing_table.(current_node), packet.dest)
            fprintf('No route from %s to destination %s\n', current_node, packet.dest);
            return;
        end
    end
    
    % Determine outgoing interface from routing table
    out_interface = routing_table.(current_node)(packet.dest);
    
    % Handle faulty outgoing interface with possible backup
    backup_out_interface = [];
    if link_status(out_interface) == 0  % Check if primary outgoing interface is faulty
        if MPC == 0  % Single-path mode: drop packet if primary interface fails
            fprintf('[Link Fault] Primary interface %s faulty, dropping packet %d at node %s\n', out_interface, packet.index, current_node);
            
            % Update link fault drop statistics
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
            stats.dropped = stats.dropped + 1;  % Increment total drop count
            tmp_map(dest) = stats;
            source_dest_stats(src) = tmp_map;
            
            process_result = 0;  % Indicate packet dropped
            return;
        end
        
        if MPC == 1  % Multi-path mode: attempt to find backup interface
            if ~isempty(in_interface)  % Use input interface for backup selection
                if adjacency(current_node).Count == 2  % Node has 2 neighbors
                    % Extract incoming neighbor from input interface
                    in_neighbor = strsplit(in_interface, '-');
                    in_neighbor = in_neighbor{1};
                    
                    % Generate potential backup interface
                    new_out_interface = [current_node '-' in_neighbor];
                    
                    % Check if backup interface is active
                    if link_status(new_out_interface) == 1
                        backup_out_interface = new_out_interface;
                        fprintf('Using backup interface %s for packet forwarding\n', new_out_interface);
                    else
                        fprintf('[Link Fault] Backup interface %s also faulty, dropping packet %d at node %s\n',...
                            new_out_interface, packet.index, current_node);
                            
                        % Update interface fault drop statistics
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
                        stats.dropped = stats.dropped + 1;  % Increment total drop count
                        tmp_map(dest) = stats;
                        source_dest_stats(src) = tmp_map;
                        
                        process_result = 0;  % Indicate packet dropped
                        return;
                    end
                end
                
                if adjacency(current_node).Count == 4  % Node has 4 neighbors
                    % Get list of neighboring nodes
                    neighbors = keys(adjacency(current_node));
                    
                    % Extract incoming neighbor from input interface
                    in_neighbor = strsplit(in_interface, '-');
                    in_neighbor = in_neighbor{1};
                    
                    out_neighbor = {};
                    side_out_neighbor = {};
                    new_side_out_interface = {};
                    
                    % Select backup interfaces based on opposite side priority
                    if Opposite_side_FIRST == 0  % Prioritize opposite side first
                        [m,n] = size(neighbors);
                        for i=1:n  % Find opposite side neighbor
                            if (strcmp(out_interface(end-3:end-2),neighbors{i}(2:3)) || strcmp(out_interface(end-1:end),neighbors{i}(4:5)) ) && ~strcmp(neighbors{i},out_interface(end-4:end))
                                out_neighbor = neighbors{i};
                                break;
                            end
                        end
                        new_opposite_out_interface = [current_node '-' out_neighbor] ;
                        
                        % Check opposite side interface status
                        if link_status(new_opposite_out_interface) == 1
                            backup_out_interface = new_opposite_out_interface;
                            fprintf('Using opposite side backup interface %s\n', new_opposite_out_interface);
                        else
                            fprintf('[Link Fault] Opposite interface %s faulty, checking side interfaces\n', new_opposite_out_interface);
                            
                            % Find side neighbors (excluding faulty opposite and primary)
                            for i=1:n
                                if ~strcmp(neighbors{i},new_opposite_out_interface ) && ~strcmp(neighbors{i},out_interface(end-4:end))
                                    side_out_neighbor{end+1} = neighbors{i};
                                end
                            end
                            new_side_out_interface{1} = [current_node '-' side_out_neighbor{1}] ;
                            new_side_out_interface{2} = [current_node '-' side_out_neighbor{2}] ;
                            
                            % Check side interfaces
                            if link_status(new_side_out_interface{1}) == 1
                                backup_out_interface = new_side_out_interface{1};
                                fprintf('Using side backup interface %s\n', new_side_out_interface{1});
                            elseif link_status(new_side_out_interface{2}) == 1
                                backup_out_interface = new_side_out_interface{2};
                                fprintf('Using side backup interface %s\n', new_side_out_interface{2});   
                            else
                                fprintf('[Link Fault] All side interfaces %s, %s faulty, dropping packet %d at node %s\n',...
                                    new_side_out_interface{1}, new_side_out_interface{2}, packet.index, current_node);
                                    
                                % Update interface fault drop statistics
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
                                stats.dropped = stats.dropped + 1;  % Increment total drop count
                                tmp_map(dest) = stats;
                                source_dest_stats(src) = tmp_map;
                                
                                process_result = 0;  % Indicate packet dropped
                                return;
                            end                           
                        end
                        
                    elseif Opposite_side_FIRST == 1  % Prioritize side interfaces first
                        [m,n] = size(neighbors);
                        for i=1:n  % Find side neighbors
                            if ( ~strcmp(out_interface(end-3:end-2),neighbors{i}(2:3))  || ~strcmp(out_interface(end-1:end),neighbors{i}(4:5))  )&& ~strcmp(neighbors{i},out_interface(end-4:end))
                                side_out_neighbor{end+1} = neighbors{i};
                            end
                        end
                        new_side_out_interface{1} = [current_node '-' side_out_neighbor{1}] ;
                        new_side_out_interface{2} = [current_node '-' side_out_neighbor{2}] ;
                        
                        % Check side interfaces
                        if link_status(new_side_out_interface{1}) == 1
                            backup_out_interface = new_side_out_interface{1};
                            fprintf('Using side backup interface %s\n', new_side_out_interface{1});
                        elseif link_status(new_side_out_interface{2}) == 1
                            backup_out_interface = new_side_out_interface{2};
                            fprintf('Using side backup interface %s\n', new_side_out_interface{2});
                        else
                            fprintf('[Link Fault] Side interfaces %s and %s faulty, checking opposite interface\n',...
                                new_side_out_interface{1}, new_side_out_interface{2});
                            
                            % Find opposite neighbor (excluding faulty side and primary)
                            for i=1:n
                                if ~strcmp(neighbors{i},new_side_out_interface{1} ) && ~strcmp(neighbors{i},new_side_out_interface{2} ) && ~strcmp(neighbors{i},out_interface(end-4:end))
                                    out_neighbor = neighbors{i};
                                    break;
                                end
                            end
                            new_opposite_out_interface = [current_node '-' out_neighbor] ;
                            
                            % Check opposite interface status
                            if link_status(new_opposite_out_interface) == 1
                                backup_out_interface = new_opposite_out_interface;
                                fprintf('Using opposite backup interface %s\n', new_opposite_out_interface);
                            else
                                fprintf('[Link Fault] Opposite interface %s faulty, dropping packet %d at node %s\n',...
                                    new_opposite_out_interface, packet.index, current_node);
                                
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
                                stats.dropped = stats.dropped + 1; 
                                tmp_map(dest) = stats;
                                source_dest_stats(src) = tmp_map;
                                process_result = 0; 
                                return;
                                end
                            end
                         end
                    end   
            end
        end
    end
    
        if link_status(out_interface) == 1 
        if MPC == 0 

        end
        if MPC == 1 
            if ~isempty(in_interface)  
                
                in_neighbor = strsplit(in_interface, '-');

                equal_in_neighbor = [in_neighbor{2} '-' in_neighbor{1}];
                if strcmp(equal_in_neighbor, out_interface) 

                    if adjacency(current_node).Count == 2 

                        neighbors = keys(adjacency(current_node));

                        in_neighbor = strsplit(in_interface, '-');
                        in_neighbor = in_neighbor{1};

                        out_neighbor = setdiff(neighbors, {in_neighbor});
                        if ~isempty(out_neighbor)
                            new_out_interface = [current_node '-' out_neighbor{1}];
                                backup_out_interface = new_out_interface;
                                fprintf('?1?7?0?9?1?7?1?7?1?7?1?7?0?5?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                    new_out_interface);
                        end
                    end
                    
                    if adjacency(current_node).Count == 4 
                        
                        completed_hops = hop_limit - packet.hop;

                        neighbors = keys(adjacency(current_node));
                        in_neighbor = strsplit(in_interface, '-');
                        in_neighbor = in_neighbor{1};
                        
                        if completed_hops <= 15 
                            out_neighbor = {};
                            side_out_neighbor = {};
                            new_side_out_interface = {};
                            if Opposite_side_FIRST == 0 
                            
                                [m,n] = size(neighbors);
                                for i=1:n 
                                    if (strcmp(in_neighbor(2:3),neighbors{i}(2:3)) || strcmp(in_neighbor(4:5),neighbors{i}(4:5)) )&& ~strcmp(neighbors{i},in_interface(1:5))
                                        out_neighbor = neighbors{i};
                                        break;
                                    end
                                end
                                new_opposite_out_interface = [current_node '-' out_neighbor];
                                backup_out_interface = new_opposite_out_interface;
                                    fprintf('?1?7?0?9?1?7?1?7?1?7?1?7?0?2?1?7?1?7?1?7?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                        new_opposite_out_interface);

                            elseif Opposite_side_FIRST == 1 
                                [m,n] = size(neighbors);
                                for i=1:n 
                                    if ( ~strcmp(in_neighbor(end-3:end-2),neighbors{i}(2:3))  || ~strcmp(in_neighbor(end-1:end),neighbors{i}(4:5))  )&& ~strcmp(neighbors{i},out_interface(end-4:end))
                                        side_out_neighbor{end+1} = neighbors{i};
                                        
                                    end
                                end
                                new_side_out_interface{1} = [current_node '-' side_out_neighbor{1}] ;
                                new_side_out_interface{2} = [current_node '-' side_out_neighbor{2}] ;
                                
                                if link_status(new_side_out_interface{1}) == 1
                                    backup_out_interface = new_side_out_interface{1};
                                    fprintf('?1?7?0?9?1?7?1?7?1?7?1?7???1?7?1?7?1?7?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                        new_side_out_interface{1});
                                elseif link_status(new_side_out_interface{2}) == 1
                                    backup_out_interface = new_side_out_interface{2};
                                    fprintf('?1?7?0?9?1?7?1?7?1?7?1?7???1?7?1?7?1?7?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                        new_side_out_interface{2});
                                end
                            end
                        
                        else
                            out_neighbor = {};
                            side_out_neighbor = {};
                            new_side_out_interface = {};
                             
                            if Opposite_side_FIRST == 0 
                               
                                [m,n] = size(neighbors);
                                for i=1:n 
                                    if ( ~strcmp(in_neighbor(end-3:end-2),neighbors{i}(2:3))  || ~strcmp(in_neighbor(end-1:end),neighbors{i}(4:5))  )&& ~strcmp(neighbors{i},out_interface(end-4:end))
                                        side_out_neighbor{end+1} = neighbors{i};
                                        %break;
                                    end
                                end
                                new_side_out_interface{1} = [current_node '-' side_out_neighbor{1}] ;
                                new_side_out_interface{2} = [current_node '-' side_out_neighbor{2}] ;
                                 
                                if link_status(new_side_out_interface{1}) == 1
                                    backup_out_interface = new_side_out_interface{1};
                                    fprintf('?1?7?0?9?1?7?1?7?1?7?1?7???1?7?1?7?1?7?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                        new_side_out_interface{1});
                                elseif link_status(new_side_out_interface{2}) == 1
                                    backup_out_interface = new_side_out_interface{2};
                                    fprintf('?1?7?0?9?1?7?1?7?1?7?1?7???1?7?1?7?1?7?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                        new_side_out_interface{2});
                                end
                            elseif Opposite_side_FIRST == 1

                                [m,n] = size(neighbors);
                                for i=1:n 
                                    if (strcmp(in_neighbor(2:3),neighbors{i}(2:3)) || strcmp(in_neighbor(4:5),neighbors{i}(4:5)) )&& ~strcmp(neighbors{i},in_interface(1:5))
                                        out_neighbor = neighbors{i};
                                        break;
                                    end
                                end
                                new_opposite_out_interface = [current_node '-' out_neighbor];
                                backup_out_interface = new_opposite_out_interface;
                                    fprintf('?1?7?0?9?1?7?1?7?1?7?1?7?0?2?1?7?1?7?1?7?0?3?1?7 %s ?1?7?1?7?1?7?1?7?1?7?1?7?0?8?1?7?1?7',...
                                        new_opposite_out_interface);
                            end
                        
                        end
                        
                    end
                end
            end
        end   
    end

    if ~isempty(backup_out_interface)
        out_interface = backup_out_interface;
        packet.if_forward_count = packet.if_forward_count + 1;  

    else
        
    end
    
    next_node = strsplit(out_interface, '-');
    next_node = next_node{2};
    
    packet.path{end+1} = [next_node '  via ' out_interface];
    
    arrival_time = current_time + 1;
    insertEvent(arrival_time, 'PacketArrived', packet);
end