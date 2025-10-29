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

% Function: Process packets using Loop-Free Alternates (LFA) routing protocol
%           Handles link status checks, packet forwarding, statistics update, and event scheduling
% Inputs:
%   packet      - Packet structure with fields: index (packet ID), path (traversed path), 
%                 source (source node), dest (destination node), hop (remaining hops)
%   current_time - Current simulation time (for scheduling next packet arrival event)
% Output:
%   process_result - Integer indicating packet processing status:
%                   0 = Packet dropped (faulty link/hop limit exceeded/no route)
%                   1 = Packet successfully received (awaiting forwarding)
%                   2 = Packet delivered to destination

function process_result = process_packet_LFA(packet, current_time)
    % Global variables: LFA routing table, link status map, traffic statistics, max hop limit
    global routing_table link_status source_dest_stats hop_limit;
    
    % Get current node from the last entry of packet path (extract first 5 characters)
    current_node = packet.path{end}(1:5);
    
    % Initialize input interface variable (for tracking packet's incoming interface)
    in_interface = [];
    % Extract input interface from packet path if path entry length > 5 (extract chars 12-22)
    if length(packet.path{end}) > 5
        in_interface = packet.path{end}(12:22);
    end
    
    % Check if input interface exists (packet came via a specific physical interface)
    if ~isempty(in_interface)  
        % Check if the input interface's link is faulty (link_status=0 means failed)
        if link_status(in_interface) == 0  
            % Print log: Packet dropped due to faulty input interface
            fprintf('[Link Fault] Packet %d dropped at node %s (incoming interface faulty)\n', packet.index, current_node);
            % Update source-destination statistics: count "aware delay" drops
            src = packet.source;
            dest = packet.dest;
            if ~isKey(source_dest_stats, src)
                source_dest_stats(src) = containers.Map();
            end
            tmp_map = source_dest_stats(src);
            if ~isKey(tmp_map, dest)
                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0,'dropped_awaredelay',0);
            end
            stats = tmp_map(dest);
            stats.dropped_awaredelay = stats.dropped_awaredelay + 1;
            stats.dropped = stats.dropped + 1;
            tmp_map(dest) = stats;
            source_dest_stats(src) = tmp_map;
            process_result = 0; % Status: Packet dropped
            return;
        else
            % Decrement remaining hop count (each hop consumes 1 unit)
            packet.hop = packet.hop - 1;  
            % Print log: Packet successfully received via valid interface
            fprintf('Packet %d received via interface %s at node %s \n',  packet.index, in_interface, current_node);
            process_result = 1; % Status: Packet received (ready for forwarding)
            
            % Check if hop count is exhausted AND current node is not destination (drop packet)
            if packet.hop <= 0 && ~strcmp(current_node, packet.dest)
                % Print log: Packet dropped due to hop limit exceeded
                fprintf('[Hop Limit Exceeded] Packet %d dropped at node %s (no remaining hops)\n', packet.index, current_node);
                % Update source-destination statistics: count hop limit drops
                src = packet.source;
                dest = packet.dest;
                if ~isKey(source_dest_stats, src)
                    source_dest_stats(src) = containers.Map();
                end
                tmp_map = source_dest_stats(src);
                if ~isKey(tmp_map, dest)
                    tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0);
                end
                stats = tmp_map(dest);
                stats.dropped_hoplimits = stats.dropped_hoplimits + 1;
                stats.dropped = stats.dropped + 1;
                tmp_map(dest) = stats;
                source_dest_stats(src) = tmp_map;
                process_result = 0; % Status: Packet dropped
                return;
            end
        end
    end
    
    % Check if current node is the packet's destination (deliver packet)
    if strcmp(current_node, packet.dest)
        % Calculate actual hops taken: Total hop limit - Remaining hops
        actual_hops = hop_limit - packet.hop;
        
        % Update source-destination statistics: count successful deliveries
        src = packet.source;
        dest = packet.dest;
        if ~isKey(source_dest_stats, src)
            source_dest_stats(src) = containers.Map();
        end
        tmp_map = source_dest_stats(src);
        if ~isKey(tmp_map, dest)
            tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'total_hops',0, 'packet_count',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0);
        end
        stats = tmp_map(dest);
        stats.received = stats.received + 1;  % Increment successful receive count
        stats.total_hops = stats.total_hops + actual_hops;  % Accumulate total hop distance
        stats.packet_count = stats.packet_count + 1;        % Increment flow packet count
        % Update max hop count for the flow (if current hops are higher)
        if actual_hops > stats.max_hops
            stats.max_hops = actual_hops;
        end
        tmp_map(dest) = stats;
        source_dest_stats(src) = tmp_map;
        
        % Print log: Packet successfully delivered (show hops and full path)
        fprintf('>>>> Packet %d delivered to destination! Total hops: %d Path: %s\n',...
        packet.index, actual_hops, strjoin(packet.path, ' -> '));
        process_result = 2; % Status: Packet delivered
        return;
    end
    
    % If current node is not destination: Validate routing table entries
    if ~strcmp(current_node, packet.dest)
        % Check if current node exists in routing table (invalid node: drop)
        if ~isfield(routing_table, current_node)
            fprintf('[Routing Error] Packet %d dropped: Node %s not found in routing table\n', packet.index, current_node);
            process_result = 0; % Status: Packet dropped
            return;
        end
        % Check if destination has a routing entry in current node's table (no route: drop)
        if ~isKey(routing_table.(current_node), packet.dest)
            fprintf('[No Route] Packet %d dropped: Node %s has no route to %s\n', current_node, packet.dest, packet.index);
            process_result = 0; % Status: Packet dropped
            return;
        end
    end
    
    % -------------------------- LFA Next-Hop Selection --------------------------
    selected_hop = [];          % Selected forward link (primary/backup LFA)
    LFA_linkforward = 0;        % Flag: 1 = LFA backup link used, 0 = not used
    
    % Step 1: Try to use primary link (if active)
    if link_status(routing_table.(current_node)(packet.dest).primary) == 1
        selected_hop = routing_table.(current_node)(packet.dest).primary;
    else
        % Step 2: Primary link failed - try backup LFA links
        % Check if backup LFA links exist and are not empty
        if isfield(routing_table.(current_node)(packet.dest), 'backup') && ~isempty(routing_table.(current_node)(packet.dest).backup)
            % Iterate all backup links to find an active one
            for i = 1:length(routing_table.(current_node)(packet.dest).backup)
                if link_status(routing_table.(current_node)(packet.dest).backup{i}) == 1
                    selected_hop = routing_table.(current_node)(packet.dest).backup{i};
                    
                    % Update statistics: count LFA backup link usage
                    src = packet.source;
                    dest = packet.dest;
                    if ~isKey(source_dest_stats, src)
                        source_dest_stats(src) = containers.Map();
                    end
                    tmp_map = source_dest_stats(src);
                    if ~isKey(tmp_map, dest)
                        tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0);
                    end
                    stats = tmp_map(dest);
                    stats.LFAforward = stats.LFAforward + 1; % Increment LFA forward count
                    tmp_map(dest) = stats;
                    source_dest_stats(src) = tmp_map;
                    
                    process_result = 0; % Temporary status (overridden after scheduling)
                    LFA_linkforward = 1;
                    break; % Exit loop after finding first active backup link
                end
            end
            
            % If no active backup links (all LFA links failed)
            if LFA_linkforward == 0
                % Update statistics: count LFA link failure drops
                src = packet.source;
                dest = packet.dest;
                if ~isKey(source_dest_stats, src)
                    source_dest_stats(src) = containers.Map();
                end
                tmp_map = source_dest_stats(src);
                if ~isKey(tmp_map, dest)
                    tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0,'dropped_LFAlinkFault',0);
                end
                stats = tmp_map(dest);
                stats.dropped_LFAlinkFault = stats.dropped_LFAlinkFault + 1;
                stats.dropped = stats.dropped + 1;  % Increment total drop count
                tmp_map(dest) = stats;
                source_dest_stats(src) = tmp_map;
                process_result = 0; % Status: Packet dropped
            end
        else
            % Step 3: No backup LFA links available (no alternate route)
            % Update statistics: count "no LFA link" drops
            src = packet.source;
            dest = packet.dest;
            if ~isKey(source_dest_stats, src)
                source_dest_stats(src) = containers.Map();
            end
            tmp_map = source_dest_stats(src);
            if ~isKey(tmp_map, dest)
                tmp_map(dest) = struct('sent',0, 'received',0, 'dropped',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0);
            end
            stats = tmp_map(dest);
            stats.dropped_NoLFAlink = stats.dropped_NoLFAlink + 1;
            stats.dropped = stats.dropped + 1;  % Increment total drop count
            tmp_map(dest) = stats;
            source_dest_stats(src) = tmp_map;
            process_result = 0; % Status: Packet dropped
        end
    end
    
    % Check if no valid next-hop was selected (drop packet)
    if isempty(selected_hop)
        fprintf('[LFA Error] Packet %d dropped at node %s (no valid forward link)\n', packet.index, current_node);
        return;
    end
    
    % Extract next node from selected hop (format: "current-next" ¡ú split to get next node)
    next_node = strsplit(selected_hop, '-');
    next_node = next_node{2};
    
    % Update packet path: add next node and traversed link (for path tracking)
    packet.path{end+1} = [next_node '  via ' selected_hop];
    
    % Calculate arrival time at next node (current time + 1 time unit)
    arrival_time = current_time + 1;
    % Schedule "PacketArrived" event for the next node
    insertEvent(arrival_time, 'PacketArrived', packet);
end