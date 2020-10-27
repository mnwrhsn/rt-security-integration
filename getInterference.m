function [ I ] = getInterference( index, wcets, periods )
% returns the Interference from high priority task for given index  task

intf = 0;

for i=1:index-1
    intf = intf + ceil(periods(index)/periods(i)) * wcets(i);
end

I = wcets(index) + intf;
end

