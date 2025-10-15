% =========================================================================
% Function: insertEvent
% Purpose: Insert event into queue with priority sorting (time first, then priority)
% Inputs:
%   - time: Event execution time (seconds)
%   - type: Event type ('PacketGenerated', 'PacketArrived', 'LinkFault', 'LinkRecover')
%   - data: Event-specific data (packet structure or link info)
% =========================================================================
function insertEvent(time, type, data)
    global event_queue;
    
    % Create new event structure
    new_event = struct('time', time, 'type', type, 'data', data);
    new_priority = getEventPriority(type);
    
    % Find insertion position (sorted by time, then priority)
    insert_pos = 1;
    while insert_pos <= length(event_queue)
        current_time = event_queue(insert_pos).time;
        current_priority = getEventPriority(event_queue(insert_pos).type);
        
        % Insert if current event is later, or same time but lower priority
        if current_time > time || (current_time == time && current_priority > new_priority)
            break;
        end
        insert_pos = insert_pos + 1;
    end
    
    % Insert new event into queue
    if insert_pos > length(event_queue)
        event_queue(end+1) = new_event;
    else
        event_queue = [event_queue(1:insert_pos-1), new_event, event_queue(insert_pos:end)];
    end
end