
%addpath(genpath('C:\Program Files\MATLAB\R2013a\toolbox\ggplab\'));

%rng(0,'twister'); % seed the random numbers

clear;
clc;

global QUIET; % turn off reporting from GP
QUIET = 1;

rt_periodmin = 10;
rt_periodmax = 100;

se_periodmin = 30;
se_periodmax = 300;
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


rt_base_util_ngroup = 6;
se_base_util_ngroup = 4;


% get the RT and SE taskset

rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
    rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );

se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
    se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );

save('tcfile_v2.mat','rt_taskset','se_taskset')
% get a random taskset and run GP routine

epsilon = 10^(-16);

% rt_tc = rt_taskset(2,50);
% se_tc = se_taskset(2,5);

saveIter = zeros(1, rt_base_util_ngroup*se_base_util_ngroup*n_tc_eachGrp);
saveTime = zeros(1, rt_base_util_ngroup*se_base_util_ngroup*n_tc_eachGrp);
cnt = 1;
for i = 1:rt_base_util_ngroup
    for j=1:se_base_util_ngroup
        % for i = rt_base_util_ngroup:-1:1
        %     for j=se_base_util_ngroup:-1:1
        for k=1:n_tc_eachGrp
            rt_tc = rt_taskset(i,k);
            se_tc = se_taskset(j,k);
            
            fprintf('i %d, j %d, k %d. \n',i, j, k);
            
            tic;
            
            [ server_util, Q, P,...
                server_status, count, obj_value,...
                Tstar, period_status,...
                iter, ecdist, isConverged ] = GetPeriod_N_ServerParam( rt_tc, se_tc, epsilon, se_perioddes_factor );
            
            elapse_time = toc;
            
            if iter > 1 || isConverged == 1
                saveIter(cnt) = iter;
                saveTime(cnt) = elapse_time;
                cnt = cnt+1;
                fprintf('Takes %d iterations to converge in %0.5f seconds.\n', iter, elapse_time);
            end
            
            
        end
    end
end
%server_util, Q, P, server_status, count, obj_value, Tstar, period_status, iter, ecdist

saveIter = nonzeros(saveIter);
saveTime = nonzeros(saveTime);
% save the data to a file
save('convergenceData.csv','saveIter','-ascii');
save('timeData.csv','saveTime','-ascii');


disp('Done everything');

clear global QUIET; % turn on reporting from GP
