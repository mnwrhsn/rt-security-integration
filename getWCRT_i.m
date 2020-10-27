function [ wcrt ] = getWCRT_i( ii, rt_tc )
% returns the WCRT using exact analysis

%rt_tc.wcets
%rt_tc.wcets(ii);

wcrt_old = rt_tc.wcets(ii);
%wcrt_old
wcrt = -1;
countMax = 1500;
count =0;
%wcrt_new = 0;

while 1
intf  = 0;
for i=1:ii-1
    intf = intf + ceil(wcrt_old/rt_tc.periods(i)) * rt_tc.wcets(i);
end

wcrt_new = rt_tc.wcets(ii) + intf;
count = count + 1;

if count >= countMax
    disp('WCRT not found!');
    wcrt = -1;
    return;
end

if wcrt_new == wcrt_old
    wcrt = wcrt_new;
    %disp('End WCRT!!');
    return;
    %break;
else
    
    wcrt_old = wcrt_new;
end

%wcrt = wcrt_new;
%disp('loop done');
end


end

