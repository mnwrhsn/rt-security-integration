
%addpath(genpath('C:\Program Files\MATLAB\R2013a\toolbox\ggplab\'));

rng(0,'twister'); % seed the random numbers

clear;
clc;

global QUIET; % turn off reporting from GP
QUIET = 1;

rt_periodmin = 10;
rt_periodmax = 100;

se_periodmin = 1000;
se_periodmax = 5000;

se_periodmin = 2*10^9;
se_periodmax = 10*10^9;


se_perioddes_factor = 0.5;

% rt_ntask_min = 3;
% rt_ntask_max = 10;

% se_ntask_min = 2;
% se_ntask_max = 5;

rt_ntask_min = 2;
rt_ntask_max = 2;


se_ntask_min = 1;
se_ntask_max = 1;

%base_rt_utilization

n_tc_eachGrp =1;

% rt_n_tc_eachGrp = 100;
% se_n_tc_eachGrp = 100;

rt_n_tc_eachGrp = n_tc_eachGrp;
se_n_tc_eachGrp = n_tc_eachGrp;


rt_base_util_ngroup = 6;
se_base_util_ngroup = 4;


% get the RT and SE taskset

% rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
%     rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );
% 
% se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
%     se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );

%save('tcfile_v2.mat','rt_taskset','se_taskset')
% get a random taskset and run GP routine

epsilon = 10^(-16);

% rt_tc = rt_taskset(2,50);
% se_tc = se_taskset(2,5);

rt_group = 4;
se_group = 2;


se_period_min_vector = [202, 1002];
se_period_max_vector = [1000, 2000];

n_periodgrp = length(se_period_min_vector);

n_periodgrp = 1;

cnt = 1;
% for i = 1:rt_base_util_ngroup
%     for j=1:se_base_util_ngroup
        % for i = rt_base_util_ngroup:-1:1
        %     for j=se_base_util_ngroup:-1:1
for i=1:n_periodgrp
        for k=1:n_tc_eachGrp
%             rt_tc = rt_taskset(i,k);
%             se_tc = se_taskset(j,k);
        
    se_periodmin = se_period_min_vector(i);
se_periodmax = se_period_max_vector(i);

rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
    rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );

se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
    se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );


             rt_tc = rt_taskset(rt_group,k);
            se_tc = se_taskset(se_group,k);
            rt_tc.periods = [6*10^9, 5*10^9]; % for RTOS experiment
            
            
            
            
            fprintf('i %d, j %d, k %d. \n',i, j, k);
            
            tic;
            
            [ server_util, Q, P,...
                server_status, count, obj_value,...
                Tstar, period_status,...
                iter, ecdist, isConverged ] = GetPeriod_N_ServerParam_newCon( rt_tc, se_tc, epsilon, se_perioddes_factor );
            
            elapse_time = toc;
            
            if iter > 1 || isConverged == 1
                cnt = cnt+1;
                fprintf('Takes %d iterations to converge in %0.5f seconds.\n', iter, elapse_time);
                fprintf('EC Dist: %0.3f\n', ecdist);
            end
            
            
        end
 end
% end
%server_util, Q, P, server_status, count, obj_value, Tstar, period_status, iter, ecdist




disp('Done everything');

clear global QUIET; % turn on reporting from GP
