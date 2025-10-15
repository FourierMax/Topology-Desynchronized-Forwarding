% =========================================================================
% Function: update_visualization
% Purpose: Update network topology visualization (nodes, links, packet paths)
% Inputs:
%   - current_time: Current simulation time (for time display)
%   - event_type: Type of event (triggers visualization updates)
%   - event_data: Event-specific data (packet or link info)
% =========================================================================
function update_visualization(current_time, event_type, event_data)
    global node_pos node_handles link_handles time_display;
    
    % Initialize visualization if not exists
    if ~exist('node_handles', 'var') || isempty(node_handles)
        figure('Name', 'Torus Network Visualization', 'Position', [100, 100, 1600, 1200]);
        hold on; axis equal; axis off;
        
        % 1. Draw nodes
        node_handles = containers.Map();
        for node_name = keys(node_pos)
            pos = node_pos(node_name{1});
            % Plot node (circle marker)
            node_handles(node_name{1}) = plot(pos(1), pos(2), 'o', ...
                'MarkerSize', 15, ...
                'MarkerFaceColor', [0.7, 0.7, 0.7], ...
                'MarkerEdgeColor', 'k', ...
                'LineWidth', 1);
            % Add node ID label
            text(pos(1)+1.5, pos(2)-2.5, node_name{1}, ...
                'FontSize', 10, 'FontWeight', 'bold');
        end
        
        % 2. Draw links (bidirectional, curved)
        link_handles = containers.Map();
        all_links = keys(link_status);
        for link_name = all_links
            link_name_str = link_name{1};
            [src, dst] = strsplit(link_name_str, '-');
            src = src{1};
            dst = dst{1};
            
            % Get node positions
            src_pos = node_pos(src);
            dst_pos = node_pos(dst);
            
            % Calculate curved link (Bezier curve)
            dx = dst_pos(1) - src_pos(1);
            dy = dst_pos(2) - src_pos(2);
            offset = 0.1 * [-dy, dx];  % Perpendicular offset for curvature
            control_point = [(src_pos(1)+dst_pos(1))/2 + offset(1), ...
                            (src_pos(2)+dst_pos(2))/2 + offset(2)];
            t = linspace(0, 1, 100);
            x = (1-t).^2 * src_pos(1) + 2*(1-t).*t * control_point(1) + t.^2 * dst_pos(1);
            y = (1-t).^2 * src_pos(2) + 2*(1-t).*t * control_point(2) + t.^2 * dst_pos(2);
            
            % Plot link (gray by default)
            line_handle = plot(x, y, 'Color', [0.8, 0.8, 0.8], 'LineWidth', 1.5);
            link_handles(link_name_str) = struct('line', line_handle);
        end
        
        % 3. Add time display text
        time_display = text(90, 150, sprintf('Simulation Time: %.2f s', current_time), ...
            'FontSize', 12, 'FontWeight', 'bold', 'Color', 'red');
    end
    
    % Update visualization based on event type
    switch event_type
        case 'PacketGenerated'
            % Highlight source node with packet color
            src_node = event_data.path{1};
            set(node_handles(src_node), 'MarkerFaceColor', event_data.color);
            drawnow;
        
        case 'PacketArrived'
            % Highlight current node and path link
            path_last = event_data.path{end};
            current_node = strsplit(path_last, '  via '){1};
            set(node_handles(current_node), 'MarkerFaceColor', event_data.color);
            
            % Highlight the link used to reach current node
            if length(event_data.path) >= 2
                prev_path = event_data.path{end-1};
                prev_node = strsplit(prev_path, '  via '){1};
                link_name = [prev_node '-' current_node];
                if isKey(link_handles, link_name)
                    set(link_handles(link_name).line, 'Color', event_data.color, 'LineWidth', 2);
                end
            end
            drawnow;
        
        case 'LinkFault'
            % Mark failed link as red dashed line
            fault_link = event_data.link;
            if isKey(link_handles, fault_link)
                set(link_handles(fault_link).line, 'Color', [1, 0, 0], 'LineStyle', '--', 'LineWidth', 2);
            end
            drawnow;
        
        case 'LinkRecover'
            % Restore recovered link to gray solid line
            recover_link = event_data.link;
            if isKey(link_handles, recover_link)
                set(link_handles(recover_link).line, 'Color', [0.8, 0.8, 0.8], 'LineStyle', '-', 'LineWidth', 1.5);
            end
            drawnow;
    end
    
    % Update time display
    set(time_display, 'String', sprintf('Simulation Time: %.2f s', current_time));
    drawnow;
end