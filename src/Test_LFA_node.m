% Description: This code implements a Topology-desynchronized Forwarding via Symmetry in Toroidal Networks.
% It simulates packet transmission, link fault handling, and routing in a torus network topology, with statistical analysis of performance metrics.
% Author: [Shenshen Luan]
% Affiliation: [Beihang University]
% Date: [2025/10/10]
% License: MIT License
% 
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

%% Initialization
clear; close all; clc;

%% Event queue initialization
global event_queue;
event_queue = struct('time', {}, 'type', {}, 'data', {});

%% Parameter configuration
% Hop limit for packet transmission
global hop_limit;
hop_limit = 20;  

% Fault management parameters
global fault_mode fault_probability mean_recovery_time;
fault_mode = 'random';  % 'file' for predefined faults, 'random' for stochastic faults
fault_probability = 0.001;   % Probability of link failure (0~1)
mean_recovery_time = 2;     % Mean time to recover from a fault (units: time)
fault_check_interval = 0.5; % Interval for checking random faults (units: time)
LINK_FAULT_RECOVER_MODE = 2; % 1: deterministic recovery; 2: exponential distribution recovery

% Simulation parameters
sim_time = 9;  % Total simulation time (units: time)
packet_interval = 1;  % Interval between packet generations (units: time)

VISULIZATION = 0; % Enable (1) or disable (0) network visualization
DIARYON = 0; % Enable (1) or disable (0) logging to file

%% Network topology setup
rows = 16;
cols = 16;
nodes = cell(rows, cols);
links = {};
interorbit_colindex = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

%% Node naming (grid-based: Nxxyy format)
for i = 1:rows
    for j = 1:cols
        nodes{i,j} = sprintf('N%02d%02d', i, j);
    end
end

%% Create network topology (mesh structure)
links = creat_topology_link(rows,cols,nodes,interorbit_colindex);

%% Simulation loop parameters
FAULTRATE = 100;
LINKFAULTTIME = 64;
HOPLIMITS = 1;
tic;

%% Main simulation loop
for F = 1:FAULTRATE
    for H = 1:HOPLIMITS
        for Times = 1:1000
            close all;
            
            %% Statistics initialization
            global source_dest_stats;
            source_dest_stats = containers.Map(); % Statistics: source -> destination -> performance metrics
            
            global node_congestion_stats;
            node_congestion_stats = containers.Map(); % Statistics: node -> time -> packet count
            
            % Update fault probability and hop limit for current iteration
            fault_probability = 0.0001 * F;
            hop_limit = 100;
            
            %% Logging setup
            if DIARYON == 1
                log_filename = sprintf('sim_log_LFA%d_F%d_H%d.txt', MPC, F, H);
                diary(log_filename);
                diary on;
            end
            
            %% Initialize link status (1: active, 0: faulty)
            global link_status;
            link_status = containers.Map();
            for i = 1:size(links,1)
                link_status(links{i,3}) = 1;
            end
            
           %% Initialize node status (1: active, 0: faulty)
            global node_status;
            node_status = containers.Map();
            all_nodes = nodes(:);
            for i = 1:numel(all_nodes)
                node_status(all_nodes{i}) = 1; 
            end
            %% Fault event initialization
            if strcmp(fault_mode, 'file')
                % Load fault events from Excel file
                [filename, pathname] = uigetfile('*.xlsx', 'Select fault event file');
                if filename == 0
                    error('No fault event file selected');
                end
                event_table = readtable(fullfile(pathname, filename));
                
                % Insert events into queue
                for i = 1:height(event_table)
                    event_time = event_table.Time(i);
                    event_type = event_table.EventType{i};
                    link_name = event_table.LinkName{i};
                    insertEvent(event_time, event_type, struct('link', link_name, 'status', strcmp(event_type, 'LinkRecover')));
                end
            elseif strcmp(fault_mode, 'random')
                % Random fault configuration
%                 fprintf('Random fault mode parameters:\n  Fault probability = %.2f per check interval\n  Mean recovery time = %.1f time units\n',...
%                     fault_probability, mean_recovery_time);
                
                % Validate parameters
                if fault_probability < 0 || fault_probability > 1
                    error('Fault probability must be between 0 and 1');
                end
                if mean_recovery_time <= 0
                    error('Mean recovery time must be positive');
                end
            else
                error('fault_mode must be either "file" or "random"');
            end
            
            %% Node position initialization (grid layout)
            node_pos = containers.Map();
            grid_spacing = 15;
            for i = 1:rows
                for j = 1:cols
                    node_name = nodes{i,j};
                    x = (j-1) * grid_spacing;
                    y = (rows - i) * grid_spacing;  % Invert y-axis to have N1_1 at top-left
                    node_pos(node_name) = [x, y];
                end
            end
            
            %% Routing table loading/calculation
            cache_filename = sprintf('routing_LFA_cache_%dx%d_j%dj%d.mat', rows, cols,interorbit_colindex(1),interorbit_colindex(2));
            global routing_table adjacency;
            
            if exist(cache_filename, 'file')
                try
                    load(cache_filename, 'routing_table', 'adjacency');
                    fprintf('---- Loaded precomputed routing table from [%s] ----\n', cache_filename);
                    
                    % Validate topology consistency
                    if ~validate_topology(adjacency, links)
                        error('Mismatch between cached routing table and current topology');
                    end
                catch ME
                    fprintf('Error loading cached routing table: %s\nRecalculating routing table...\n', ME.message);
                    [routing_table, adjacency,lfa_coverage] = calculate_LFA_routing_table(links, node_pos);
                    save(cache_filename, 'routing_table', 'adjacency');
                end
            else
                % Calculate and cache routing table
                [routing_table, adjacency,lfa_coverage] = calculate_LFA_routing_table(links, node_pos);
                save(cache_filename, 'routing_table', 'adjacency');
            end
            
            %% Network visualization setup
            if VISULIZATION == 1
                figure('Name', 'Network Routing Visualization');
                hold on; axis equal; axis off;
                set(gcf, 'Position', [0 0 1600 1200]);
                
                % Simulation time display
                global time_display;
                time_display = text(90, 150, 'Simulation Time: 0.00 units',...
                    'FontSize', 12,...
                    'FontWeight', 'bold',...
                    'Color', 'red');
                
                % Node visualization
                global node_handles;
                node_handles = containers.Map();
                for n = keys(node_pos)
                    pos = node_pos(n{1});
                    node_handles(n{1}) = plot(pos(1), pos(2), 'o',...
                        'MarkerSize', 15,...
                        'MarkerFaceColor', [0.7 0.7 0.7],...
                        'MarkerEdgeColor', 'k',...
                        'LineWidth', 1);
                    
                    text(pos(1) + 1.5, pos(2) - 2.5, n{1},...
                        'FontSize', 10, 'FontWeight', 'bold');
                end
                
                % Link visualization (curved lines)
                global link_handles;
                link_handles = containers.Map();
                
                for i = 1:size(links,1)
                    src = links{i,1};
                    dst = links{i,2};
                    key = [src '-' dst];
                    
                    src_pos = node_pos(src);
                    dst_pos = node_pos(dst);
                    
                    % Calculate offset for curved link
                    dx = dst_pos(1) - src_pos(1);
                    dy = dst_pos(2) - src_pos(2);
                    offset = 0.1 * [-dy, dx];
                    
                    % Bezier curve control point
                    control_point = [(src_pos(1) + dst_pos(1))/2 + offset(1),...
                                    (src_pos(2) + dst_pos(2))/2 + offset(2)];
                    
                    % Generate curve points
                    t = linspace(0, 1, 100);
                    x = (1 - t).^2 * src_pos(1) + 2 * (1 - t) .* t * control_point(1) + t.^2 * dst_pos(1);
                    y = (1 - t).^2 * src_pos(2) + 2 * (1 - t) .* t * control_point(2) + t.^2 * dst_pos(2);
                    
                    % Plot link
                    main_line = plot(x, y,...
                        'Color', [0.8 0.8 0.8],...
                        'LineWidth', 1.5);
                    
                    link_handles(key) = struct('line', main_line);
                end
            end
            
            %% Source and destination node selection
            all_nodes = nodes(:);               
            random_index = randi(numel(all_nodes));
            source_input = all_nodes{random_index};   
            
            random_index = randi(numel(all_nodes));
            dest_input = all_nodes{random_index};   
            
            % Expand 'ALL' to all nodes
            if strcmpi(source_input, 'ALL')
                source_nodes = nodes(:);
            else
                source_nodes = strsplit(source_input, ',');
            end
            
            if strcmpi(dest_input, 'ALL')
                dest_nodes = nodes(:);
            else
                dest_nodes = strsplit(dest_input, ',');
            end
            
            % Remove duplicates
            source_nodes = unique(reshape(source_nodes, 1, []));
            dest_nodes = unique(reshape(dest_nodes, 1, []));
            
            % Validate node existence
            all_nodes = keys(node_pos);
            if iscellstr(source_nodes) && any(strcmpi(source_nodes, 'ALL'))
                source_nodes = all_nodes;
            end
            if iscellstr(dest_nodes) && any(strcmpi(dest_nodes, 'ALL'))
                dest_nodes = all_nodes;
            end
            
            % Initialize source-destination statistics
            for i = 1:length(source_nodes)
                src = strtrim(source_nodes{i});
                if ~isKey(source_dest_stats, src)
                    source_dest_stats(src) = containers.Map();
                end
                for j = 1:length(dest_nodes)
                    dest = strtrim(dest_nodes{j});
                    tmp_map = source_dest_stats(src);
                    tmp_map(dest) = struct('sent', 0, 'received', 0, 'dropped', 0,'total_hops',0, 'max_hops', 0, 'packet_count',0,'dropped_linkfault',0,'dropped_hoplimits',0,'dropped_NoLFAlink',0,'LFAforward',0,'dropped_awaredelay',0,'dropped_LFAlinkFault',0);
                end
            end
            
            %% Validate source and destination nodes
            for i = 1:length(source_nodes)
                node = strtrim(source_nodes{i});
                if ~isKey(node_pos, node)
                    error('Source node %s does not exist in the network', node);
                end
            end
            
            for j = 1:length(dest_nodes)
                node = strtrim(dest_nodes{j});
                if ~isKey(node_pos, node)
                    error('Destination node %s does not exist in the network', node);
                end
            end
            
            %% Generate packet events
            index = 0;
            for t = 0:packet_interval:sim_time
                for src_idx = 1:length(source_nodes)
                    source_node = source_nodes{src_idx};
                    for dest_idx = 1:length(dest_nodes)
                        dest_node = dest_nodes{dest_idx};
                        index = index + 1;
                        packet.index = index;
                        packet.source = source_node;
                        packet.dest = dest_node;
                        packet.path = {source_node};
                        packet.color = rand(1, 3);
                        packet.hop = hop_limit;
                        insertEvent(t, 'PacketGenerated', packet);
                        
                        % Update send statistics
                        if ~isKey(source_dest_stats, source_node)
                            source_dest_stats(source_node) = containers.Map();
                        end
                        tmp_map = source_dest_stats(source_node);
                        if ~isKey(tmp_map, dest_node)
                            tmp_map(dest_node) = struct('sent',0, 'received',0, 'dropped',0);
                        end
                        stats = tmp_map(dest_node);
                        stats.sent = stats.sent + 1;
                        tmp_map(dest_node) = stats;
                        source_dest_stats(source_node) = tmp_map;
                    end
                end
            end
            
            %% Event processing loop
            current_time = 0;
            last_fault_check = 0;
            node_packets_record = {};
            
            while ~isempty(event_queue) && current_time <= sim_time + hop_limit + 2
                [current_time, event_type, event_data] = popEvent();
                
                % Check for random faults at intervals
                if strcmp(fault_mode, 'random') && (current_time - last_fault_check) >= fault_check_interval
                    %all_links = keys(link_status);
                    for i = 1:numel(all_nodes)
                       %link = all_links{i};
                        if node_status(all_nodes{i}) == 1
                            actual_prob = 1 - (1 - fault_probability)^(current_time - last_fault_check);
                            if rand() < actual_prob
                                insertEvent(current_time, 'NodeFault',struct('node',all_nodes{i}, 'status',0));
                            end
                        end
                    end
                    last_fault_check = current_time;
                end
                
                % Update visualization time
                if VISULIZATION == 1
                    set(time_display, 'String', sprintf('Simulation Time: %.2f units', current_time));
                    drawnow;
                end
                
                % Process events
                switch event_type
                    case 'PacketGenerated'
                        fprintf('[%.2f units] Generated Packet %d: %s -> %s\n', current_time, event_data.index, event_data.path{1}, event_data.dest);
                        
                        if VISULIZATION == 1
                            set(node_handles(event_data.path{1}), 'MarkerFaceColor', event_data.color);
                        end
                        process_packet_LFA(event_data, current_time);
                        
                    case 'PacketArrived'
                        path_entry = event_data.path{end};
                        split_result = strsplit(path_entry, '  via ');
                        if length(split_result) < 1
                            error('Invalid path format: %s', path_entry);
                        end
                        
                        process_result = process_packet_LFA(event_data, current_time);
                        if process_result ~= 0
                            current_node = split_result{1};
                            fprintf('[%.2f units] Packet %d Arrived at: %s\n', current_time, event_data.index, current_node);
                            
                            if VISULIZATION == 1
                                if ~isKey(node_handles, current_node)
                                    error('Node handle for %s not found', current_node);
                                end
                                if ~isvalid(node_handles(current_node))
                                    error('Node handle for %s is invalid', current_node);
                                end
                                
                                set(node_handles(current_node), 'MarkerFaceColor', event_data.color);
                                
                                if length(event_data.path) >= 2
                                    prev_step = event_data.path{end-1};
                                    prev_node = prev_step(1:5);
                                    link_key = [prev_node '-' current_node];
                                    if isKey(link_handles, link_key)
                                        set(link_handles(link_key).line, 'Color', event_data.color);
                                    end
                                end
                                drawnow;
                            end
                            
                            % Update congestion statistics
                            if ~isKey(node_congestion_stats, current_node)
                                node_congestion_stats(current_node) = containers.Map();
                            end
                            time_str = sprintf('%.2f', current_time);
                            time_map = node_congestion_stats(current_node);
                            if ~isKey(time_map, time_str)
                                time_map(time_str) = 0;
                            end
                            time_map(time_str) = time_map(time_str) + 1;
                        end
                        
                    case 'NodeFault'
                        fault_node = event_data.node;
                        node_status(fault_node) = 0;
                        fprintf('[%.2f units] Node Fault: %s\n', current_time, fault_node);
                        
                        all_links = keys(link_status);
                        for i = 1:length(all_links)
                            link = all_links{i};
                            nodes_in_link = strsplit(link, '-');
                            if ismember(fault_node, nodes_in_link)
                                link_status(link) = 0;
                                if VISULIZATION
                                    set(link_handles(link).line, 'Color', [1 0 0], 'LineStyle', '--');
                                    set(node_handles(fault_node),'MarkerFaceColor', [1 1 1],'MarkerEdgeColor', [1 1 1]);
                                end
                            end
                        end
                        
                        if isfield(event_data, 'source') && strcmp(event_data.source, 'random')
                            fprintf('[%.2f units] [Random] Node Fault: %s\n', current_time, event_data.node);
                        else
                            fprintf('[%.2f units] [File] Node Fault: %s\n', current_time, event_data.node);
                        end
                        
                    case 'NodeRecover'
                        recover_node = event_data.node;
                        node_status(recover_node) = 1;
                        fprintf('[%.2f units] Node Recovery: %s\n',current_time, recover_node);
                        
                        all_links = keys(link_status);
                    for i = 1:length(all_links)
                        link = all_links{i};
                        nodes_in_link = strsplit(link, '-');
                        if ismember(recover_node, nodes_in_link)
                           
                            other_node = setdiff(nodes_in_link, recover_node);
                            if node_status(other_node{1}) == 1
                                link_status(link) = 1;
                                if VISULIZATION
                                    set(link_handles(link).line, 'Color', [0.8 0.8 0.8], 'LineStyle', '-');
                                    set(node_handles(recover_node),'MarkerFaceColor', [0.7 0.7 0.7],'MarkerEdgeColor', 'k');
                                    drawnow;
                                end
                            end
                        end
                    end
                    
                end
            end
            
            toc;
            
            %% Performance statistics summary
            fprintf('\n============ Source-Destination Performance Summary ============\n');
            total_network_hops = 0;
            total_arrived_packets = 0;
            total_sent_packets = 0;
            total_droped_packets = 0;
            total_linkfault_droped_packets = 0;
            total_awaredelay_droped_packets = 0;
            total_hoplimits_droped_packets = 0;
            total_LFAlinkfault_droped_packets = 0;   
            total_NoLFAlink_droped_packets = 0;     
            total_LFAforward_packets = 0;   
            global_max_hops = 0;
            
            src_nodes = keys(source_dest_stats);
            for i = 1:length(src_nodes)
                src = src_nodes{i};
                dest_map = source_dest_stats(src);
                dest_nodes = keys(dest_map);
                for j = 1:length(dest_nodes)
                    dest = dest_nodes{j};
                    stats = dest_map(dest);
                    
                    fprintf('Source: %s -> Destination: %s\n', src, dest);
                    fprintf('  Packets Sent: %d\n', stats.sent);
                    fprintf('  Packets Received: %d\n', stats.received);
                    fprintf('  Dropped (Link Fault): %d\n', stats.dropped_linkfault);
                    fprintf('  Dropped (Aware Delay): %d\n', stats.dropped_awaredelay);
                    fprintf('  Dropped (Hop Limit): %d\n', stats.dropped_hoplimits);
                    fprintf('  Dropped (No LFA Link): %d\n', stats.dropped_NoLFAlink);
                    fprintf('  Dropped (LFA Link Fault): %d\n', stats.dropped_LFAlinkFault);
                    fprintf('  Total Dropped: %d\n', stats.dropped);
                    fprintf('  LFA Forwarded Packets: %d\n', stats.LFAforward);
                    
                    if stats.sent > 0
                        loss_rate = (stats.dropped) / stats.sent * 100;
                        fprintf('  Loss Rate: %.2f%%\n', loss_rate);
                        loss_rate_matrix(i,j) = loss_rate;
                        total_sent_packets = total_sent_packets + stats.sent;
                        total_droped_packets = total_droped_packets + stats.dropped;
                        total_linkfault_droped_packets = total_linkfault_droped_packets + stats.dropped_linkfault;
                        total_hoplimits_droped_packets = total_hoplimits_droped_packets + stats.dropped_hoplimits;
                        total_LFAlinkfault_droped_packets = total_LFAlinkfault_droped_packets +stats.dropped_LFAlinkFault;
                        total_NoLFAlink_droped_packets = total_NoLFAlink_droped_packets +stats.dropped_NoLFAlink;
                        total_LFAforward_packets = total_LFAforward_packets + stats.LFAforward;
                        total_awaredelay_droped_packets = total_awaredelay_droped_packets + stats.dropped_awaredelay;
						if stats.max_hops > global_max_hops
                 			global_max_hops = stats.max_hops;
                		end
                    else
                        fprintf('  No packets sent\n');
                    end
                    fprintf('------------------------------------\n');
                    
                    % Hop statistics
                    fprintf('Source: %s -> Destination: %s\n', src, dest);
                    fprintf('  Total Arrived: %d | Total Hops: %d | LFA Forwarded: %d', stats.packet_count, stats.total_hops, stats.LFAforward);
                    
                    if stats.packet_count > 0
                        avg_hops = stats.total_hops / stats.packet_count;
                        avg_hops_matrix(i,j) = avg_hops;
                        fprintf(' | Average Hops: %.2f\n', avg_hops);
                        total_network_hops = total_network_hops + stats.total_hops;
                        total_arrived_packets = total_arrived_packets + stats.packet_count;
                       
                    else
                        fprintf(' | No packets arrived\n');
                    end
                    fprintf('------------------------------------\n');
                end
            end
            
            %% Global performance summary
            if total_sent_packets > 0
                fprintf('[Network Summary] Total Sent: %d | Total Dropped: %d | Overall Loss Rate: %.2f\n',...
                    total_sent_packets, total_droped_packets, total_droped_packets/total_sent_packets);
                fprintf('[Network Summary] Total Sent: %d | Dropped (Link Fault): %d | Link Fault Loss Rate: %.2f\n',...
                    total_sent_packets, total_linkfault_droped_packets, total_linkfault_droped_packets/total_sent_packets);
                fprintf('[Network Summary] Total Sent: %d | Dropped (Aware Delay): %d | Aware Delay Loss Rate: %.2f\n',...
                    total_sent_packets, total_awaredelay_droped_packets, total_awaredelay_droped_packets/total_sent_packets);
                fprintf('[Network Summary] Total Sent: %d | Dropped (Hop Limit): %d | Hop Limit Loss Rate: %.2f\n',...
                    total_sent_packets, total_hoplimits_droped_packets, total_hoplimits_droped_packets/total_sent_packets);
                fprintf('[Network Summary] Total Sent: %d | Dropped (LFA Link Fault): %d | LFA Link Fault Loss Rate: %.2f\n',...
                    total_sent_packets, total_LFAlinkfault_droped_packets, total_LFAlinkfault_droped_packets/total_sent_packets);
                fprintf('[Network Summary] Total Sent: %d | Dropped (No LFA Link): %d | No LFA Link Loss Rate: %.2f\n',...
                    total_sent_packets, total_NoLFAlink_droped_packets, total_NoLFAlink_droped_packets/total_sent_packets);
            else
                fprintf('[Network Summary] No packets sent\n');
            end
            
            %% Hop statistics summary
            if total_arrived_packets > 0
                fprintf('[Network Summary] Total Arrived: %d | Total Hops: %d | Average Hops: %.2f\n',...
                    total_arrived_packets, total_network_hops, total_network_hops/total_arrived_packets);
                fprintf('[Network Summary] LFA Forwarded packets: %d | Total packets: %d | LFA Forward Packets Ratio: %.2f\n',...
                    total_LFAforward_packets, total_network_hops, total_LFAforward_packets/total_network_hops);
            else
                fprintf('[Network Summary] No packets arrived\n');
            end
            
            %% Node congestion statistics
            fprintf('\n============ Node Congestion Summary ============\n');
            node_names = keys(node_congestion_stats);
            max_packets_matrix = [];
            for i = 1:length(node_names)
                node = node_names{i};
                time_map = node_congestion_stats(node);
                times = keys(time_map);
                counts = values(time_map);
                total_packets = sum(cell2mat(counts));
                max_packets = max(cell2mat(counts));
                max_packets_matrix(i) = max_packets;
            end
            
            %% Store iteration results
            avg_droprate_with_diff_faultprob(F,H,Times) = total_droped_packets/total_sent_packets;
            avg_linkfault_droprate_with_diff_faultprob(F,H,Times) = total_linkfault_droped_packets/total_sent_packets;
            avg_awaredelay_droprate_with_diff_faultprob(F,H,Times) = total_awaredelay_droped_packets/total_sent_packets;
            avg_hoplimits_droprate_with_diff_faultprob(F,H,Times) = total_hoplimits_droped_packets/total_sent_packets;
            avg_LFAlinkfault_droprate_with_diff_faultprob(F,H,Times) = total_LFAlinkfault_droped_packets/total_sent_packets;
            avg_NoLFAlink_droprate_with_diff_faultprob(F,H,Times) = total_NoLFAlink_droped_packets/total_sent_packets;
            LFAforward_rate(F,H,Times) = total_LFAforward_packets/total_network_hops;
            avg_hops_with_diff_faultprob(F,H,Times) = total_network_hops/total_arrived_packets;
            max_hops(F,H,Times) = global_max_hops;
            
            if DIARYON == 1
                    diary off;  % close the diary
            end
        end
    end
end

% record the result
for F = 1:FAULTRATE
    for H = 1:HOPLIMITS
        avg_droprate(F,H) = mean(avg_droprate_with_diff_faultprob(F,H,:));
        avg_linkfault_droprate(F,H) = mean(avg_linkfault_droprate_with_diff_faultprob(F,H,:));
        avg_hoplimits_droprate(F,H) = mean(avg_hoplimits_droprate_with_diff_faultprob(F,H,:));
        avg_awaredelay_droprate(F,H) = mean(avg_awaredelay_droprate_with_diff_faultprob(F,H,:));
        avg_hops(F,H) = mean(avg_hops_with_diff_faultprob(F,H,:));
        avg_LFAlinkfault_droprate(F,H) = mean(avg_LFAlinkfault_droprate_with_diff_faultprob(F,H,:));
        avg_NoLFAlink_droprate(F,H) = mean(avg_NoLFAlink_droprate_with_diff_faultprob(F,H,:));
        avg_LFAforward_rate(F,H) = mean(LFAforward_rate(F,H,:));
        avg_max_hops(F,H) = mean(max_hops(F,H,:));
    end
end
save LFA_Result_Node.mat;