clear
clc

%addpath(genpath('C:\Program Files\MATLAB\R2013a\toolbox\ggplab\'));

%rng(0,'twister'); % seed the random numbers

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

n_tc_eachGrp = 20;

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


serverPeriodMax = 2500;
stepSize = 1.5;

% get a taskset and run GP & Exhaustive Search routine



solCount_esearch = zeros(rt_base_util_ngroup, se_base_util_ngroup);
solCount_GP = zeros(rt_base_util_ngroup, se_base_util_ngroup);

timeCount_esearch = zeros(rt_base_util_ngroup, se_base_util_ngroup);
timeCount_GP = zeros(rt_base_util_ngroup, se_base_util_ngroup);
cnt = 1;

% for i = 1:1
%     for j=1:1
%         for k=1:1

for i = 1:rt_base_util_ngroup
    for j=1:se_base_util_ngroup
        for k=1:n_tc_eachGrp
            rt_tc = rt_taskset(i,k);
            se_tc = se_taskset(j,k);
            
%             rt_tc = rt_taskset(2,3);
%              se_tc = se_taskset(2,3);
            
           fprintf('i %d, j %d, k %d. \n',i, j, k);
            
            tic;
            [server_util_esearch, Q_esearch, P_esearch, status_esearch ] = getServerParam_ExSearch_v2( rt_tc, se_tc, serverPeriodMax, stepSize );
             elapse_time_esearch = toc;
             
             tic;
            [server_util_GP, Q_GP, P_GP, status_GP, count ] = getServerParamGP( rt_tc, se_tc );
             elapse_time_GP = toc;
            
            if strcmp(status_esearch,'Solved')
                fprintf('We got a solution by Exhaustive Search!!\n');
                fprintf('Parameters of E. Search: Budget %0.3f, Period %0.3f, Util %0.3f!!.\n', Q_esearch, P_esearch, server_util_esearch);
%                 rUB_esearch = getRespTimeUB( Q_esearch, P_esearch, rt_tc);
%                 fprintf('Responce time by Exhaustive Search: %0.3f.\n', rUB_esearch);
                solCount_esearch(i,j) = solCount_esearch(i,j) + 1;
                timeCount_esearch(i,j) = elapse_time_esearch;
                
            else
                fprintf('No solutuon found for Exhaustive Search!!\n');
                
            end
            
            
            if strcmp(status_GP,'Solved')
                fprintf('We got a solution by GP!!\n');
                fprintf('Parameters of GP: Budget %0.3f, Period %0.3f, Util %0.3f!!.\n', Q_GP, P_GP, server_util_GP);
%                 rUB_GP = getRespTimeUB( Q_GP, P_GP, rt_tc);
%                 fprintf('Responce time by GP: %0.3f.\n', rUB_GP);
                solCount_GP(i,j) = solCount_GP(i,j) + 1;
                 timeCount_GP(i,j) = elapse_time_GP;
            else
                fprintf('No solutuon found for GP!!\n');
                
            end
            
            % check both have solution
             if strcmp(status_esearch,'Solved') && strcmp(status_GP,'Solved')
                 distVectorX(cnt) = sum(rt_tc.utilizations);
                 distVectorY(cnt) = sum(se_tc.utilizations);
                 distVectorZ(cnt) = server_util_GP - server_util_esearch; % +ve means GP is good
                 fprintf('Difference (GP - Esearch): %0.3f!!.\n', distVectorZ(cnt));
                 cnt = cnt + 1;
                
             end
            
            
        end
    end
end


%fGain = (solCount_GP - solCount_esearch)./solCount_esearch;
%fGain = fGain .* 100;

fGain = solCount_GP./solCount_esearch;

% save to a mat file
save('GP_Esearch_compare_v2_exact_tmax3K.mat','solCount_GP','solCount_esearch',...
    'timeCount_GP','timeCount_esearch',...
    'distVectorX', 'distVectorY', 'distVectorZ');




disp('Done everything');

clear global QUIET; % turn on reporting from GP
