
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
se_ntask_array = [2, 3, 4, 5];

%base_rt_utilization

n_tc_eachGrp = 2;

% rt_n_tc_eachGrp = 100;
% se_n_tc_eachGrp = 100;

rt_n_tc_eachGrp = n_tc_eachGrp;
se_n_tc_eachGrp = n_tc_eachGrp;


rt_base_util_ngroup = 6;
se_base_util_ngroup = 4;



% get the RT and SE taskset

rt_taskset = getTaskSets( rt_base_util_ngroup, rt_n_tc_eachGrp,...
    rt_ntask_min, rt_ntask_max, rt_periodmin, rt_periodmax );

% se_taskset = getTaskSets( se_base_util_ngroup, se_n_tc_eachGrp,...
%     se_ntask_min, se_ntask_max, se_periodmin, se_periodmax );

se_taskset = cell(1, length(se_ntask_array));
for i=1:length(se_ntask_array)
    se_taskset{i} = getTaskSetsbyNumber( se_ntask_array(i), se_base_util_ngroup, se_n_tc_eachGrp,...
     se_periodmin, se_periodmax );
end


%save('tcfile_v2.mat','rt_taskset','se_taskset')
% get a random taskset and run GP routine

epsilon = 10^(-16);

% rt_tc = rt_taskset(2,50);
% se_tc = se_taskset(2,5);

rt_base_num = 4;
cnt = 1;

solCount = zeros(length(se_ntask_array), se_base_util_ngroup);

for i=1:length(se_ntask_array)
    se_taskset_for_n = se_taskset{i};
    cnt = 1;
    for j=1:se_base_util_ngroup
        cnt2 = 1;
        for k=1:n_tc_eachGrp
            rt_tc = rt_taskset(rt_base_num,k);
            se_tc = se_taskset_for_n(j,k);
            fprintf('i %d, j %d, k %d. \n',i, j, k);
            
            tic;
            
            [ server_util, Q, P,...
                server_status, count, obj_value,...
                Tstar, period_status,...
                iter, ecdist, isConverged ] = GetPeriod_N_ServerParam( rt_tc, se_tc, epsilon, se_perioddes_factor );
            
            elapse_time = toc;
            
            if iter > 1 || isConverged == 1
                %saveDist(j,k) = ecdist;
                saveDistUtil(i, cnt) = sum(se_tc.utilizations);
                saveDist(i, cnt) = ecdist;
                solCount(i, j) = solCount(i,j) + 1;
                
                distArr(cnt2) = ecdist;
                cnt2 = cnt2+1;
                
                %saveDist(cnt) = ecdist;
                %saveTime(cnt) = elapse_time;
                cnt = cnt+1;
                fprintf('Takes %d iterations to converge in %0.5f seconds. Distance: %0.5f\n', iter, elapse_time, ecdist);
            end
            
        end
        
        
        saveDistbyGrpMean(i, j) = mean(distArr);
        saveDistbyGrpStd(i, j) = std(distArr);
        saveDistbyGrpCell{i, j} = distArr;
    end
    
    %distArr{i} = saveDist;
end

hold on;
box on;




%boxplot(saveDistbyGrpCell{1,1});

boxplot(bArr);

set (gca, 'XTick',[1 2 3 4], 'XTickLabel',{'[0.01, 0.10]','[0.11, 0.20]','[0.31, 0.40]','[0.41, 0.50]'});

% Create xlabel
xlabel('Utilizaitions of the Security Tasks', 'FontSize',11);

% Create ylabel
ylabel('Normalized Euclidean Distance', 'FontSize',11);



legend1 = legend(gca,'show');
set(legend1,'Location','NorthWest');



solCountPercent = (solCount./n_tc_eachGrp).*100;

disp((solCount./n_tc_eachGrp).*100);

%save('EDistData.csv','saveDistUtil','-ascii');
%save('EDistData_count.csv','solCountPercent','-ascii');

% figure(2)
% bar3(solCount);

disp('Done everything');

clear global QUIET; % turn on reporting from GP
