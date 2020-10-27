function [ server_util, Q, P,...
    server_status, count, obj_value,...
    Tstar, period_status, iter, ecdist, isConverged ] = GetPeriod_N_ServerParam_newCon( rt_tc, se_tc, epsilon, se_perioddes_factor )
% The iterative algorithm described in the paper

% initialize with garbage value;

server_util = -1; Q = -1; P = -1;
server_status = -1; count = -1; obj_value = -1;
Tstar = -1; period_status = -1; iter = -1; ecdist = -1; isConverged = -1;


% some initialization
server_util_last = server_util;
Q_last = Q;
P_last = P;
server_status_last = server_status;
obj_value_last = obj_value;
Tstar_last = Tstar;
period_status_last = period_status;

% main code start;
obj_old = 1000000;
iter = 1;
Tdes = se_perioddes_factor .* se_tc.periods;
Tmax = se_tc.periods;

% just for test
Tmax = 5000 .* ones(1, length(Tmax));
%Tmax = 15*10^9 .* ones(1, length(Tmax));

ii = 0;
maxIter = 100;

% while 1
%
%     ii = ii + 1;
%     if ii > maxIter
%         break;
%     end

[server_util, Q, P, server_status, count ] = getServerParamGP( rt_tc, se_tc );



%server_util, Q, P, status, count

if ~strcmp(server_status,'Solved')
    fprintf('Cannot find any server parameter. Terminating at iteration %d. \n',iter);
    %break;
    return;
end

budget = getBudget(se_tc.ntask, Q, P);

fprintf('Rajkumar Paper Constraint %0.3f. \n',(3*P- 2*Q));
if (3*P- 2*Q) < 0
    fprintf('Rajkumar Bound Error P %d, Q %d. Terminating at iteration %d. \n',P, Q, iter);
    %break;
    return;
end

[ obj_value, Tstar, period_status ] = getOptimalPeriodGP_addCon( se_tc.ntask, se_tc.wcets', Tdes', Tmax', budget, Q, P  );

%obj_value, Tstar, status, Tdes', se_tc.periods'


if ~strcmp(period_status,'Solved')
    fprintf('Cannot find suitable periods. Terminating at iteration %d. \n',iter);
    %break;
    return;
end

%%% RUN SECOND TIME
[server_util, Q, P, server_status, count ] = getServerParamGP( rt_tc, se_tc );



%server_util, Q, P, status, count

if ~strcmp(server_status,'Solved')
    fprintf('Cannot find any server parameter. Terminating at iteration %d. \n',iter);
    %break;
    return;
end


% copy most recent solution

server_util_last = server_util;
Q_last = Q;
P_last = P;
server_status_last = server_status;
obj_value_last = obj_value;
Tstar_last = Tstar;
period_status_last = period_status;


% check terminating condition
diff = abs(obj_value - obj_old);


%diff

if diff<=epsilon
    isConverged = 1;
    %break;
end

% some updates
obj_old = obj_value;
iter = iter+1;
se_tc.periods = Tstar'; % update periods

% Tstar'

%end

% after termination the loop return the best value

% set arbitrary large TMax
%Tmax
%Tmax = 100000 .* ones(1, length(Tmax));
server_util = server_util_last;
Q = Q_last;
P = P_last;
server_status = server_status_last ;
obj_value = obj_value_last ;
Tstar = Tstar_last;
period_status = period_status_last;

ecdist = norm(Tstar' - Tdes)/norm(Tmax - Tdes);

%ecdist = norm(Tstar' - Tdes);



end

