function [ budget, dellS ] = getServerBudget_v2( rt_tc, se_tc, serverPeriod )
% returns eq (10) in Man-Ki paper

%min_budget_for_all_task = zeros(1, se_tc.ntask);

budget = 0.0;

budgetStep = 1.0;
budgetSearchSpace = (1:budgetStep:serverPeriod);
cnt = 1;


for i=1:length(budgetSearchSpace)
    wcrt = getWCRT_server( budgetSearchSpace(i), rt_tc );
    %disp(serverPeriod)
    %disp(budgetSearchSpace(i));
    % simple error checking
    dellS = 0;
    
    if wcrt < 0
        dellS = -1;
    end
    
    
    for k = 1:rt_tc.ntask
        dellS = dellS + ceil(wcrt/rt_tc.periods(k)) * rt_tc.wcets(k);
    end
    
    min_budget_for_all_task = zeros(1, se_tc.ntask);
    for j=1:se_tc.ntask
        t1 = -( se_tc.periods(j) - serverPeriod - dellS );
        Ij = getInterference( j, se_tc.wcets, se_tc.periods );
        t2 = ( se_tc.periods(j) - serverPeriod - dellS ) * ( se_tc.periods(j) - serverPeriod - dellS ) ...
            + 4 * Ij * serverPeriod;
        t2 = sqrt(t2);
        
        min_budget = (t1 + t2)/2; % euqation 10
        min_budget_for_all_task(i) = min_budget;
        
        
    end
    
    qmin = max(min_budget_for_all_task);
    
    %      if qmin + dellS <= serverPeriod
    %          budget = budgetSearchSpace(i);
    %          %disp('got something')
    %      end
    
    if qmin <=  budgetSearchSpace(i);
        
        if budgetSearchSpace(i) +  dellS <= serverPeriod
            budget_vec(cnt) = budgetSearchSpace(i);
            cnt = cnt+1;
        end
        %dellS_vec(cnt) = dellS;
        %cnt = cnt + 1;
        %disp('got something')
    end
    
    
    
    
end
if cnt > 1 % we got some solution
    
    budget = max(budget_vec);
else
    budget = -1;
    % budget = budget_vec;
    %
    % for i=1:length(budget_vec)
    %
    %     if budget_vec(i) + dellS_vec(i) <= serverPeriod
    %
    %     end
    % end
end

