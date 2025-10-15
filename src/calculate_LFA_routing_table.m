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

function [routing_table, adjacency, lfa_coverage] = calculate_routing_table(links, node_pos)
    fprintf('---- Starting LFA routing table calculation ----\n');
    
    %% ================ Initialize link status ================
    link_status = containers.Map();
    for i = 1:size(links,1)
        link_status(links{i,3}) = 1; % Set link as active
    end
    
    %% Build adjacency matrix
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
            src_map(dst) = 1;
            
            if ~isKey(adjacency, dst)
                adjacency(dst) = containers.Map();
            end
            dst_map = adjacency(dst);
            dst_map(src) = 1;
        end
    end
    
    %% Dijkstra algorithm for routing table
    all_nodes = keys(node_pos);
    routing_table_main = struct();
    routing_table = struct();
    all_dist = containers.Map();
    
    for src_idx = 1:length(all_nodes)
        src = all_nodes{src_idx};

        % Initialize distance and previous node arrays
        dist = containers.Map(all_nodes, num2cell(inf(1, length(all_nodes))));
        prev = containers.Map(all_nodes, repmat({''}, 1, length(all_nodes)));
        dist(src) = 0;

        dist_values = cell2mat(values(dist));
        nodes_table = table(...
            all_nodes(:), ...
            dist_values(:), ...
            'VariableNames', {'Node','Dist'});
        nodes_table = sortrows(nodes_table, 'Dist');

        while ~isempty(nodes_table)
            % Get node with minimum distance
            u = nodes_table.Node{1};
            nodes_table(1,:) = [];

            % Process neighbors
            if isKey(adjacency, u)
                neighbors_map = adjacency(u);
                neighbors = keys(neighbors_map);
                for v_idx = 1:length(neighbors)
                    v = neighbors{v_idx};
                    alt = dist(u) + neighbors_map(v);
                    if alt < dist(v)
                        dist(v) = alt;
                        prev(v) = u;
                        % Update distance table
                        nodes_table.Dist(ismember(nodes_table.Node, v)) = alt;
                        nodes_table = sortrows(nodes_table, 'Dist');
                    end
                end
            end
        end

        all_dist(src) = dist;
    
        % Build routing table
        rt = containers.Map();
        for dest_idx = 1:length(all_nodes)
            dest = all_nodes{dest_idx};
            if strcmp(dest, src), continue; end

            % Trace path to destination
            current = dest;
            path = {};
            while ~strcmp(current, src)
                if ~isKey(prev, current) || isempty(prev(current))
                    break;
                end
                path{end+1} = current;
                current = prev(current);
            end

            % Determine next hop
            if ~isempty(path) && strcmp(current, src)
                next_hop = path{end};
                out_link = [src '-' next_hop];
                rt(dest) = out_link;
            else
                rt(dest) = 'No path';
                fprintf('DEBUG: Source %s to destination %s has no path\n', src, dest);
            end
        end

        routing_table_main.(src) = rt;   
    end
    
    % Calculate LFA backup paths
    for src_idx_2 = 1:length(all_nodes)
        src = all_nodes{src_idx_2};
        dist = all_dist(src);
        
        rt_lfa = containers.Map();
        for dest_idx = 1:length(all_nodes)
            dest = all_nodes{dest_idx};

            if strcmp(dest, src), continue; end

            % Get primary next hop
            primary_hop = routing_table_main.(src)(dest);

            % Find LFA backup paths
            candidates = keys(adjacency(src));
            temp_prim = strsplit(primary_hop, '-');
            candidates(strcmp(candidates, temp_prim{2})) = [];
            valid_lfa = {};
            dist_adj = adjacency(src);
            for cand = candidates
                cand_node = cand{1};
                % Check LFA condition
                cand_dist = all_dist(cand_node);
                distance_cand_dest = cand_dist(dest);
                % LFA condition: distance(cand, dest) < distance(src, dest) + distance(src, cand)
                if distance_cand_dest < (dist(dest) + dist(cand_node))
                    valid_lfa{end+1} = [src '-' cand_node];
                    fprintf(' %s -> %s found LFA backup: %s \n', src, dest, [src '-' cand_node]);
                end
            end

            % Store routing table entry
            rt_lfa(dest) = struct(...
                'primary', primary_hop,...
                'backup', {valid_lfa}...
            );
        end
        routing_table.(src) = rt_lfa;
    end
    
    % Display Dijkstra calculation results
    fprintf('---- LFA calculation completed ----\n');
    src_nodes = fieldnames(routing_table);
    for i = 1:length(src_nodes)
        src = src_nodes{i};
        dests = keys(routing_table.(src));
        fprintf('Source node %s:\n', src);
        for j = 1:length(dests)
            dest = dests{j};
            if numel(routing_table.(src)(dest).backup) > 0
                fprintf('  -> %s has %d LFA backup paths\n', dest, length(routing_table.(src)(dest).backup));
            end
        end
    end
    
    %% ===== Calculate LFA coverage statistics =====
    total_pairs = 0;
    lfa_available_pairs = 0;

    % Count all source-destination pairs
    all_nodes = keys(node_pos);
    for src_idx = 1:length(all_nodes)
        src = all_nodes{src_idx};
        for dest_idx = 1:length(all_nodes)
            dest = all_nodes{dest_idx};

            % Skip self-to-self
            if strcmp(src, dest), continue; end

            total_pairs = total_pairs + 1;

            % Check if LFA backup exists
            if ~isempty(routing_table.(src)(dest).backup)
                lfa_available_pairs = lfa_available_pairs + 1;
            end
        end
    end

    % Calculate coverage percentage
    lfa_coverage = lfa_available_pairs / total_pairs * 100;
    fprintf('\n===== LFA Coverage Statistics =====\n');
    fprintf('Total source-destination pairs: %d\n', total_pairs);
    fprintf('Pairs with LFA protection: %d\n', lfa_available_pairs);
    fprintf('LFA coverage percentage: %.2f%%\n', lfa_coverage);
end