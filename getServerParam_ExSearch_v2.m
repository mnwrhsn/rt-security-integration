function [ server_util, Q, P, status ] = getServerParam_ExSearch_v2( rt_tc, se_tc, serverPeriodMax, stepSize )
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

% disp('come here');

for ii=1:testPoints
    
    %fprintf('Period Test Point %0.3f!!.\n', periodSearchSpace(ii));
    
    [budget, dellS] = getServerBudget_v2( rt_tc, se_tc, periodSearchSpace(ii) );
    
%     budget
%     dellS
     %periodSearchSpace(ii)
    
    if dellS ~= -1 % just check whether exact test get some WCRT value
        %qmin = max(min_budget_for_all_task);
        
        %if budget + dellS <= periodSearchSpace(ii)
        if budget >= 0
            canSol(cnt) = budget/periodSearchSpace(ii);
            canQ(cnt) = budget;
            canP(cnt) = periodSearchSpace(ii);
            cnt = cnt+1;
            %disp('got in out fun');
        end
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

