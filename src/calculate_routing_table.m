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

% =========================================================================
% Function: calculate_routing_table
% Purpose: Compute shortest-path routing table for torus topology using Dijkstra's algorithm
% Inputs:
%   - links: Cell array of links (generated from creat_topology_link function)
%   - node_pos: Cell array of node positions with node IDs as keys
% Outputs:
%   - routing_table: Struct where each field (named by source node ID) is a map,
%                    mapping destination node IDs to corresponding outgoing links
%   - adjacency: Map object where each key is a node ID, and the value is another map
%                mapping adjacent node IDs to link weight (fixed as 1 here)
% =========================================================================
function [routing_table, adjacency] = calculate_routing_table(links, node_pos)
    fprintf('---- Calculating the routing table(first running or topology change) ----\n');
    
    %% Initialize link status map
    link_status = containers.Map();
    for i = 1:size(links,1)
        link_status(links{i,3}) = 1; % Mark link as active (status = 1)
    end
    
    %% Construct adjacency list
    adjacency = containers.Map();
    for i = 1:size(links,1)
        link = links{i,3};
        src = links{i,1};
        dst = links{i,2};
        if link_status(link) == 1
            if ~isKey(adjacency, src)
                adjacency(src) = containers.Map();
            end
            src_map = adjacency(src);
            src_map(dst) = 1; % Set edge weight to 1
            
            % Add reverse direction for bidirectional link
            if ~isKey(adjacency, dst)
                adjacency(dst) = containers.Map();
            end
            dst_map = adjacency(dst);
            dst_map(src) = 1;
        end
    end
    
    %% Compute shortest paths using Dijkstra's algorithm for each source node
    all_nodes = keys(node_pos);
    routing_table = struct();
    for src_idx = 1:length(all_nodes)
        src = all_nodes{src_idx};
    
        % Initialize distance and predecessor maps
        dist = containers.Map(all_nodes, num2cell(inf(1, length(all_nodes))));
        prev = containers.Map(all_nodes, repmat({''}, 1, length(all_nodes)));
        dist(src) = 0;  % Distance from source to itself is 0
        
        dist_values = cell2mat(values(dist)); % Extract distance values
        nodes_table = table(...
            all_nodes(:), ...        % Node IDs
            dist_values(:), ...      % Corresponding distances from source
            'VariableNames', {'Node','Dist'});
        nodes_table = sortrows(nodes_table, 'Dist');
        
        while ~isempty(nodes_table)
            % Extract node with the smallest current distance
            u = nodes_table.Node{1};
            nodes_table(1,:) = [];
            
            % Update distances for neighboring nodes
            if isKey(adjacency, u)
                neighbors_map = adjacency(u);  % Get neighbor map of current node
                neighbors = keys(neighbors_map);
                for v_idx = 1:length(neighbors)
                    v = neighbors{v_idx};
                    alt = dist(u) + neighbors_map(v);  % Calculate alternative distance
                    if alt < dist(v)
                        dist(v) = alt;
                        prev(v) = u;
                        % Update distance in table and re-sort
                        nodes_table.Dist(ismember(nodes_table.Node, v)) = alt;
                        nodes_table = sortrows(nodes_table, 'Dist');
                    end
                end
            end
        end
        
        % Generate routing table for current source node
        rt = containers.Map();
        for dest_idx = 1:length(all_nodes)
            dest = all_nodes{dest_idx};
            if strcmp(dest, src), continue; end  % Skip self-loop
            
            % Backtrack from destination to source to find the path
            current = dest;
            path = {};  % Store reverse path (destination -> ... -> source)
            while ~strcmp(current, src)
                if ~isKey(prev, current) || isempty(prev(current))
                    break;
                end
                path{end+1} = current;
                current = prev(current);  % Move to predecessor node
            end
            
            % Determine outgoing link based on the path
            if ~isempty(path) && strcmp(current, src)
                next_hop = path{end};  % Next hop is the first step from source in the path
                out_link = [src '-' next_hop];
                rt(dest) = out_link;
                %fprintf('DEBUG: Source %s to Destination %s, Next Hop %s\n', src, dest, next_hop);
            else
                rt(dest) = 'unreachable';  % Mark as unreachable
                fprintf('DEBUG: Src %s Dest %s Unreachable\n', src, dest);
            end
        end
        
        % Store routing table for current source
        routing_table.(src) = rt;
    end
end