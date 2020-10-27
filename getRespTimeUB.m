function [ rUB_normalized ] = getRespTimeUB( Q, P, rt_tc)
% returns the response time upper bound from the following paper:
% Efficient computation of response time bounds under fixed-priority scheduling

t1 = 0;
for i=1:rt_tc.ntask
t1 = t1 + rt_tc.wcets(i) * (1-rt_tc.utilizations(i));
end
t1 = t1 + Q;
t2 = 1 - sum(rt_tc.utilizations);

rub = t1/t2;
rUB_normalized = rub/P;



end

