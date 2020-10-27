
%addpath(genpath('C:\Program Files\MATLAB\R2013a\toolbox\ggplab\'));

%rng(0,'twister'); % seed the random numbers

global QUIET; % turn off reporting from GP
QUIET = 1;

rt_periodmin = 10;
rt_periodmax = 1000;

se_periodmin = 30;
se_periodmax = 3000;
se_perioddes_factor = 0.7;

rt_ntask_min = 3;
rt_ntask_max = 10;

se_ntask_min = 2;
se_ntask_max = 5;

%base_rt_utilization

rt_n_tc_eachGrp = 100;
se_n_tc_eachGrp = 100;

rt_base_util_ngroup = 10;
se_base_util_ngroup = 4;

% get the RT and SE taskset

rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
    rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );

se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
    se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );


% get a random taskset and run GP routine



rt_tc = rt_taskset(3,50);
se_tc = se_taskset(2,5);

obj_old = 1000000;
epsilon = 10^(-9);

iter = 1;
Tdes = se_perioddes_factor .* se_tc.periods; 
Tmax = se_tc.periods;

while 1

[server_util, Q, P, server_status, count ] = getServerParamGP( rt_tc, se_tc );



%server_util, Q, P, status, count

if ~strcmp(server_status,'Solved')
     fprintf('Cannot find any server parameter. Terminating at iteration %d. \n',iter);
   return;
end

budget = getBudget(se_tc.ntask, Q, P);



[ obj_value, Tstar, period_status ] = getOptimalPeriodGP( se_tc.ntask, se_tc.wcets', Tdes', Tmax', budget );

%obj_value, Tstar, status, Tdes', se_tc.periods'


if ~strcmp(period_status,'Solved')
     fprintf('Cannot find suitable periods. Terminating at iteration %d. \n',iter);
   return;
end

diff = abs(obj_value - obj_old);


%diff

if diff<=epsilon
    break;
end
obj_old = obj_value;
iter = iter+1;
se_tc.periods = Tstar'; % update periods

end



ecdist = norm(Tstar' - Tdes)/norm(Tmax - Tdes);



server_util, Q, P, server_status, count, obj_value, Tstar, period_status, iter

ecdist
disp('Done everything');

clear global QUIET; % turn on reporting from GP
