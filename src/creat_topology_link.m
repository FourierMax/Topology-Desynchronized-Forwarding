% =========================================================================
% Function: creat_topology_link
% Purpose: Generate intra-orbit (row-wise) and inter-orbit (column-wise) links for torus topology
% Inputs:
%   - rows: Number of rows in torus (vertical dimension)
%   - cols: Number of columns in torus (horizontal dimension)
%   - nodes: Cell array of node IDs (size: rows x cols)
%   - interorbit_colindex: Column indices for inter-orbit links
% Output:
%   - links: Cell array of links (each row: [source_node, dest_node, link_name])
% =========================================================================
function links = creat_topology_link(rows, cols, nodes, interorbit_colindex)
    links = {};
    
    % 1. Intra-orbit links (row-wise, circular: j <-> j+1, j=cols <-> j=1)
    for i = 1:rows
        % Horizontal links (j to j+1)
        for j = 1:cols-1
            src = nodes{i,j};
            dst = nodes{i,j+1};
            links(end+1,:) = {src, dst, [src '-' dst]};
            links(end+1,:) = {dst, src, [dst '-' src]};  % Bidirectional link
        end
        % Circular link (j=cols to j=1)
        src = nodes{i,cols};
        dst = nodes{i,1};
        links(end+1,:) = {src, dst, [src '-' dst]};
        links(end+1,:) = {dst, src, [dst '-' src]};  % Bidirectional link
    end
    
    % 2. Inter-orbit links (column-wise, circular: i <-> i+1, i=rows <-> i=1)
    [~, num_interorbit_cols] = size(interorbit_colindex);
    for k = 1:num_interorbit_cols
        j = interorbit_colindex(k);  % Column for inter-orbit links
        % Vertical links (i to i+1)
        for i = 1:rows-1
            src = nodes{i,j};
            dst = nodes{i+1,j};
            links(end+1,:) = {src, dst, [src '-' dst]};
            links(end+1,:) = {dst, src, [dst '-' src]};  % Bidirectional link
        end
        % Circular link (i=rows to i=1)
        src = nodes{rows,j};
        dst = nodes{1,j};
        links(end+1,:) = {src, dst, [src '-' dst]};
        links(end+1,:) = {dst, src, [dst '-' src]};  % Bidirectional link
    end
end