clear
clc

%addpath(genpath('C:\Program Files\MATLAB\R2013a\toolbox\ggplab\'));

%rng(0,'twister'); % seed the random numbers

global QUIET; % turn off reporting from GP
QUIET = 1;

rt_periodmin = 10;
rt_periodmax = 1000;

se_periodmin = 30;
se_periodmax = 3000;
se_perioddes_factor = 0.5;

rt_ntask_min = 3;
rt_ntask_max = 10;

se_ntask_min = 2;
se_ntask_max = 5;

%base_rt_utilization

n_tc_eachGrp = 100;

% rt_n_tc_eachGrp = 100;
% se_n_tc_eachGrp = 100;

rt_n_tc_eachGrp = n_tc_eachGrp;
se_n_tc_eachGrp = n_tc_eachGrp;


rt_base_util_ngroup = 5;
se_base_util_ngroup = 3;

% get the RT and SE taskset

rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
    rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );

se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
    se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );


serverPeriodMax = 1000;
stepSize = 0.1;

% get a taskset and run GP & Exhaustive Search routine
index = 2;

rt_tc = rt_taskset(2,3);
            se_tc = se_taskset(2,3);

wcrt  = getWCRT_i( index, rt_tc );
wcrt
rt_tc.periods(index)

disp('Done everything');

clear global QUIET; % turn on reporting from GP
