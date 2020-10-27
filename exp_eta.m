
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
%se_ntask_array = [2, 3, 4, 5];

%base_rt_utilization

n_tc_eachGrp = 100;

% rt_n_tc_eachGrp = 100;
% se_n_tc_eachGrp = 100;

rt_n_tc_eachGrp = n_tc_eachGrp;
se_n_tc_eachGrp = n_tc_eachGrp;


rt_base_util_ngroup = 6;
se_base_util_ngroup = 5;



% get the RT and SE taskset

rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
    rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );

se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
    se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );

% se_taskset = cell(1, length(se_ntask_array));
% for i=1:length(se_ntask_array)
%     se_taskset{i} = getTaskSetsbyNumber( se_ntask_array(i), se_base_util_ngroup, se_n_tc_eachGrp,...
%      se_periodmin, se_periodmax );
% end


%save('tcfile_v2.mat','rt_taskset','se_taskset')
% get a random taskset and run GP routine

epsilon = 10^(-16);

% rt_tc = rt_taskset(2,50);
% se_tc = se_taskset(2,5);

rt_base_num = 3;
cnt = 1;

saveDistUtil = -1 * ones(se_base_util_ngroup, n_tc_eachGrp);
saveDist = -1 * ones(se_base_util_ngroup, n_tc_eachGrp);

saveDistUtil = -1 * ones(se_base_util_ngroup, n_tc_eachGrp);
                

%solCount = zeros(length(se_ntask_array), se_base_util_ngroup);

%for i=1:length(se_ntask_array)
    %se_taskset_for_n = se_taskset{i};
    %cnt = 1;
    for j=1:se_base_util_ngroup
        %cnt2 = 1;
        cnt = 1;
        for k=1:n_tc_eachGrp
            rt_tc = rt_taskset(rt_base_num,k);
            se_tc = se_taskset(j,k);
            fprintf('i %d, j %d, k %d. \n',i, j, k);
            
            Ti_max = se_tc.periods;
            Ti_des = se_tc.periods .* se_perioddes_factor;
            
            tic;
            
            [ server_util, Q, P,...
                server_status, count, obj_value,...
                Tstar, period_status,...
                iter, ecdist, isConverged ] = GetPeriod_N_ServerParam( rt_tc, se_tc, epsilon, se_perioddes_factor );
            
            elapse_time = toc;
            
            if iter > 1 || isConverged == 1
                %saveDist(j,k) = ecdist;
                
                %etaCount(cnt) = 1/obj_value;
                
                %etaCount_UB(cnt) = se_tc.ntask;
                etaCount_UB(cnt) = sum(Ti_des ./ Ti_des) ;
                
                etaCount_LB(cnt) = sum(Ti_des ./ Ti_max) ;
                etaCount(cnt) = sum(Ti_des ./ Tstar') ;
                
               
                cnt = cnt+1;
                fprintf('Takes %d iterations to converge in %0.5f seconds. Distance: %0.5f.\n', iter, elapse_time, ecdist);
                fprintf('Server Budget %0.5f, Period %0.5f.\n', Q, P);
%                 fprintf('Max RT Task Period %0.5f.\n', max(rt_tc.periods));
%                 if max(rt_tc.periods) < P
%                     fprintf('RM SATISFIRD!!! \n');
%                 else
%                     fprintf('=== NOT RM ===\n');
%                 end
                
            end
            
        end
        etaCount_arr(j) = mean(etaCount);
          etaCount_UB_arr(j) = mean(etaCount_UB);
          etaCount_LB_arr(j) = mean(etaCount_LB);
        %saveDistbyGrpMean(i, j) = mean(distArr);
        %saveDistbyGrpStd(i, j) = std(distArr);
    end
    
    %distArr{i} = saveDist;
%end



figure(1);
hold on;
box on;
grid on;

% plot(etaCount_arr);
% plot(etaCount_UB_arr, 'g');
%plot(etaCount_LB_arr, 'r');


%bar(etaCount_arr);


% save to a mat file
save('eta.mat','etaCount_arr', 'etaCount_UB_arr', 'etaCount_LB_arr');
% 

disp('Done everything');

clear global QUIET; % turn on reporting from GP
