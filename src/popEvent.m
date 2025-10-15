% =========================================================================
% Function: popEvent
% Purpose: Extract the earliest event from the queue (FIFO based on time/priority)
% Outputs:
%   - time: Event execution time (seconds)
%   - type: Event type
%   - data: Event-specific data
% =========================================================================
function [time, type, data] = popEvent()
    global event_queue;
    
    % Return empty if queue is empty
    if isempty(event_queue)
        time = [];
        type = [];
        data = [];
        return;
    end
    
    % Extract the first event (earliest)
    time = event_queue(1).time;
    type = event_queue(1).type;
    data = event_queue(1).data;
    
    % Remove the extracted event from queue
    event_queue(1) = [];
end