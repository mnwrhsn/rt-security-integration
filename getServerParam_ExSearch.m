function [ server_util, Q, P, status ] = getServerParam_ExSearch( rt_tc, se_tc, serverPeriodMax, stepSize )
%  get server parameters by exhaustive search

server_util = 1;
Q = -1; P = 1; status = -1;

% serverPeriod = 2;
% 
% min_budget_for_all_task = getMinBudget_SecTasks( rt_tc, se_tc, serverPeriod );
% 
% Q = max(min_budget_for_all_task);

periodSearchSpace = (1:stepSize:serverPeriodMax);

testPoints = length(periodSearchSpace);

canP = ones(1, testPoints);
canQ = zeros(1, testPoints);
canSol = zeros(1, testPoints);

cnt = 1;

for ii=1:testPoints
    
    [min_budget_for_all_task, dellS] = getMinBudget_SecTasks( rt_tc, se_tc, periodSearchSpace(ii) );
    qmin = max(min_budget_for_all_task);
    
    if qmin + dellS <= periodSearchSpace(ii)
        canSol(cnt) = qmin/periodSearchSpace(ii);
        canQ(cnt) = qmin;
        canP(cnt) = periodSearchSpace(ii);
        cnt = cnt+1;
    end

end


%canSol
%testPoints



[maxval,index] = max(canSol);

if maxval > 0 %we got a solution
    server_util = maxval;
    Q =  canQ(index);
    P =  canP(index);
    status = 'Solved';
else
    server_util = -1;
    Q =  -1;
    P =  -1;
    status = 'NotSolved';
end



end

