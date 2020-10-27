function [ min_budget_for_all_task, dellS ] = getMinBudget_SecTasks( rt_tc, se_tc, serverPeriod )
% returns eq (10) in Man-Ki paper

min_budget_for_all_task = zeros(1, se_tc.ntask);

dellS = 0;
for i=1:rt_tc.ntask
    dellS = dellS + (serverPeriod/rt_tc.periods(i) + 1) * rt_tc.wcets(i);
end

for i=1:se_tc.ntask
    t1 = -( se_tc.periods(i) - serverPeriod - dellS );
    Ij = getInterference( i, se_tc.wcets, se_tc.periods );
    t2 = ( se_tc.periods(i) - serverPeriod - dellS ) * ( se_tc.periods(i) - serverPeriod - dellS ) ...
        + 4 * Ij * serverPeriod;
    t2 = sqrt(t2);
    
    min_budget = (t1 + t2)/2; % euqation 10
    min_budget_for_all_task(i) = min_budget;
    
end

end

