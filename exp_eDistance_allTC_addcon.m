
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
se_base_util_ngroup = 4;



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
            
            tic;
            
            [ server_util, Q, P,...
                server_status, count, obj_value,...
                Tstar, period_status,...
                iter, ecdist, isConverged ] = GetPeriod_N_ServerParam_newCon( rt_tc, se_tc, epsilon, se_perioddes_factor );
            
            elapse_time = toc;
            
            if iter > 1 || isConverged == 1
                %saveDist(j,k) = ecdist;
                saveDistUtil(j, cnt) = sum(se_tc.utilizations);
                saveDist(j, cnt) = ecdist;
                %solCount(i, j) = solCount(i,j) + 1;
                
                %distArr(cnt2) = ecdist;
                %cnt2 = cnt2+1;
                
                %saveDist(cnt) = ecdist;
                %saveTime(cnt) = elapse_time;
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
        
        %saveDistbyGrpMean(i, j) = mean(distArr);
        %saveDistbyGrpStd(i, j) = std(distArr);
    end
    
    %distArr{i} = saveDist;
%end

% saveDistUtil
% saveDist
saveDistUtil = saveDistUtil(saveDistUtil >=0);
saveDist = saveDist(saveDist >=0);
% saveDistUtil
% saveDist

hold on;
box on;
grid on;



figure(1);
[r,c] = size(saveDistUtil);
for i=1:r
  scatter( saveDistUtil(i,:), saveDist(i, :) ,...
     'MarkerEdgeColor',[0 0 0],'Marker','*');  
end

ylim(gca,[0.00 1.00]);

% Create xlabel
xlabel('Utilizaition of the Security Tasks', 'FontSize',11);

% Create ylabel
ylabel('Normalized Euclidean Distance', 'FontSize',11);


dlmwrite('EDistDataTC_saveDistUtil_addcon.csv',saveDistUtil,'delimiter','\t','precision',3);
dlmwrite('EDistDataTC_saveDist_addcon.csv',saveDist,'delimiter','\t','precision',3);

disp('Done everything');

clear global QUIET; % turn on reporting from GP
