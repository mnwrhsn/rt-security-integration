
%addpath(genpath('C:\Program Files\MATLAB\R2013a\toolbox\ggplab\'));

%rng(0,'twister'); % seed the random numbers

clear;
clc;

global QUIET; % turn off reporting from GP
QUIET = 1;

rt_periodmin = 10;
rt_periodmax = 100;

se_periodmin = 500;
se_periodmax = 1000;
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
se_base_num = 4;
cnt = 1;

saveDistUtil = -1 * ones(se_base_util_ngroup, n_tc_eachGrp);
saveDist = -1 * ones(se_base_util_ngroup, n_tc_eachGrp);

saveDistUtil = -1 * ones(se_base_util_ngroup, n_tc_eachGrp);

solCount_GP = zeros(se_base_util_ngroup, 1);
solCount_NS = zeros(se_base_util_ngroup, 1);


%solCount = zeros(length(se_ntask_array), se_base_util_ngroup);

%for i=1:length(se_ntask_array)
%se_taskset_for_n = se_taskset{i};
%cnt = 1;
%for j=1:se_base_util_ngroup
%for j=2:se_base_util_ngroup
for j=1:rt_base_util_ngroup
    %cnt2 = 1;
    cnt = 1;
    cnt2 = 1;
    for k=1:n_tc_eachGrp
        %rt_tc = rt_taskset(rt_base_num,k);
        rt_tc = rt_taskset(j,k);
        %se_tc = se_taskset(j,k);
        se_tc = se_taskset(se_base_num,k);
        fprintf('i %d, j %d, k %d. \n',i, j, k);
        
        Ti_max = se_tc.periods;
        Ti_des = se_tc.periods .* se_perioddes_factor;
        
        %Ti_des
        
        tic;
        
        [ server_util, Q, P,...
            server_status, count, obj_value,...
            Tstar, period_status,...
            iter, ecdist, isConverged ] = GetPeriod_N_ServerParam_newCon( rt_tc, se_tc, epsilon, se_perioddes_factor );
        
        elapse_time = toc;
        
        if iter > 1 || isConverged == 1
            
            etaCount_UB_GP(cnt) = sum(Ti_des ./ Ti_des) ;
            
            etaCount_LB_GP(cnt) = sum(Ti_des ./ Ti_max) ;
            etaCount_GP(cnt) = sum(Ti_des ./ Tstar') ;
            ecdist_GP(cnt) = ecdist;
            
            cnt = cnt+1;
            %fprintf('Takes %d iterations to converge in %0.5f seconds. Distance: %0.5f.\n', iter, elapse_time, ecdist);
            fprintf('Found Solution with Server. Distance: %0.5f.\n', ecdist);
            fprintf('Server Budget %0.5f, Period %0.5f.\n', Q, P);
        end
        
        
        budget = 0.69 - sum(rt_tc.utilizations);
        
        Ti_max = 5000 .* ones(1, length(Ti_max));
        [ obj_value, Tstar, period_status ] = getOptimalPeriodGP( se_tc.ntask, se_tc.wcets', Ti_des', Ti_max', budget );
        
        ecdist = norm(Tstar' - Ti_des)/norm(Ti_max - Ti_des);
        
        %Ti_des
        
        if strcmp(period_status,'Solved')
            fprintf('Found suitable periods W/O Server. Distance: %0.5f. \n', ecdist);
            
            etaCount_UB_NS(cnt2) = sum(Ti_des ./ Ti_des) ;
            
            etaCount_LB_NS(cnt2) = sum(Ti_des ./ Ti_max) ;
            etaCount_NS(cnt2) = sum(Ti_des ./ Tstar') ;
            ecdist_NS(cnt2) = ecdist;
            cnt2 = cnt2 + 1;
            
        end
        
        
        
        
    end
    
    
    
    
    
    
    etaCount_arr_GP(j) = mean(etaCount_GP);
    etaCount_UB_arr_GP(j) = mean(etaCount_UB_GP);
    etaCount_LB_arr_GP(j) = mean(etaCount_LB_GP);
    ecdist_arr_GP(j) = mean(ecdist_GP);
    
    etaCount_arr_NS(j) = mean(etaCount_NS);
    etaCount_UB_arr_NS(j) = mean(etaCount_UB_NS);
    etaCount_LB_arr_NS(j) = mean(etaCount_LB_NS);
    ecdist_arr_NS(j) = mean(ecdist_NS);
end

%distArr{i} = saveDist;
%end



figure(1);
hold on;
box on;
grid on;

% plot(etaCount_arr);
plot(etaCount_arr_GP, 'b');
plot(etaCount_arr_NS, 'g');
%plot(etaCount_LB_arr, 'r');


figure(2);
hold on;
box on;
grid on;

% plot(etaCount_arr);
plot(ecdist_arr_GP, 'b');
plot(ecdist_arr_NS, 'g');


% save to a mat file
save('ser_n_ser_newcon.mat', 'etaCount_arr_GP',     'etaCount_UB_arr_GP',     'etaCount_LB_arr_GP', ...
    'ecdist_arr_GP', 'etaCount_arr_NS',     'etaCount_UB_arr_NS', ...
    'etaCount_LB_arr_NS',     'ecdist_arr_NS');



disp('Done everything');

clear global QUIET; % turn on reporting from GP
