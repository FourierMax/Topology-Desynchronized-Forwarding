% =========================================================================
% Function: getEventPriority
% Purpose: Define priority for different event types (lower = higher priority)
% Input:
%   - event_type: Type of event
% Output:
%   - priority: Integer priority (1: highest; 4: lowest)
% =========================================================================
function priority = getEventPriority(event_type)
    switch event_type
        case 'LinkRecover'
            priority = 1;  % Highest: link recovery precedes other events
        case {'PacketGenerated', 'PacketArrived'}
            priority = 2;  % Medium: packet events
        case 'LinkFault'
            priority = 3;  % Low: link fault detection
        otherwise
            priority = 4;  % Lowest: unknown events
    end
end