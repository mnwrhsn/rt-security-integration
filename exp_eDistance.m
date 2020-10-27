
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

n_tc_eachGrp = 100;

% rt_n_tc_eachGrp = 100;
% se_n_tc_eachGrp = 100;

rt_n_tc_eachGrp = n_tc_eachGrp;
se_n_tc_eachGrp = n_tc_eachGrp;


rt_base_util_ngroup = 6;
se_base_util_ngroup = 3;



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
                fprintf('Takes %d iterations to converge in %0.5f seconds. Distance: %0.5f.\n', iter, elapse_time, ecdist);
                fprintf('Server Budget %0.5f, Period %0.5f.\n', Q, P);
                fprintf('Max RT Task Period %0.5f.\n', max(rt_tc.periods));
                if max(rt_tc.periods) < P
                    fprintf('RM SATISFIRD!!! \n');
                else
                    fprintf('=== NOT RM ===\n');
                end
                
            end
            
        end
        
        saveDistbyGrpMean(i, j) = mean(distArr);
        saveDistbyGrpStd(i, j) = std(distArr);
    end
    
    %distArr{i} = saveDist;
end

% hold on;
% box on;

%b1 = bar(saveDistbyGrpMean(2,:));
% 
% b1 = bar(saveDistbyGrpMean');
% set(gcf, 'Colormap',...
%     [0 0 0;0.0149393090978265 0.0149393090978265 0.0149393090978265;0.029878618195653 0.029878618195653 0.029878618195653;0.044817928224802 0.044817928224802 0.044817928224802;0.0597572363913059 0.0597572363913059 0.0597572363913059;0.0746965482831001 0.0746965482831001 0.0746965482831001;0.089635856449604 0.089635856449604 0.089635856449604;0.104575164616108 0.104575164616108 0.104575164616108;0.119514472782612 0.119514472782612 0.119514472782612;0.134453788399696 0.134453788399696 0.134453788399696;0.1493930965662 0.1493930965662 0.1493930965662;0.164332404732704 0.164332404732704 0.164332404732704;0.179271712899208 0.179271712899208 0.179271712899208;0.194211021065712 0.194211021065712 0.194211021065712;0.209150329232216 0.209150329232216 0.209150329232216;0.22408963739872 0.22408963739872 0.22408963739872;0.239028945565224 0.239028945565224 0.239028945565224;0.253968268632889 0.253968268632889 0.253968268632889;0.268907576799393 0.268907576799393 0.268907576799393;0.283846884965897 0.283846884965897 0.283846884965897;0.298786193132401 0.298786193132401 0.298786193132401;0.313725501298904 0.313725501298904 0.313725501298904;0.328664809465408 0.328664809465408 0.328664809465408;0.343604117631912 0.343604117631912 0.343604117631912;0.358543425798416 0.358543425798416 0.358543425798416;0.37348273396492 0.37348273396492 0.37348273396492;0.388422042131424 0.388422042131424 0.388422042131424;0.403361350297928 0.403361350297928 0.403361350297928;0.418300658464432 0.418300658464432 0.418300658464432;0.433239966630936 0.433239966630936 0.433239966630936;0.44817927479744 0.44817927479744 0.44817927479744;0.463118582963943 0.463118582963943 0.463118582963943;0.478057891130447 0.478057891130447 0.478057891130447;0.492997199296951 0.492997199296951 0.492997199296951;0.507936537265778 0.507936537265778 0.507936537265778;0.522875845432281 0.522875845432281 0.522875845432281;0.537815153598785 0.537815153598785 0.537815153598785;0.552754461765289 0.552754461765289 0.552754461765289;0.567693769931793 0.567693769931793 0.567693769931793;0.582633078098297 0.582633078098297 0.582633078098297;0.597572386264801 0.597572386264801 0.597572386264801;0.612511694431305 0.612511694431305 0.612511694431305;0.627451002597809 0.627451002597809 0.627451002597809;0.642390310764313 0.642390310764313 0.642390310764313;0.657329618930817 0.657329618930817 0.657329618930817;0.672268927097321 0.672268927097321 0.672268927097321;0.687208235263824 0.687208235263824 0.687208235263824;0.702147543430328 0.702147543430328 0.702147543430328;0.717086851596832 0.717086851596832 0.717086851596832;0.732026159763336 0.732026159763336 0.732026159763336;0.74696546792984 0.74696546792984 0.74696546792984;0.761904776096344 0.761904776096344 0.761904776096344;0.776844084262848 0.776844084262848 0.776844084262848;0.791783392429352 0.791783392429352 0.791783392429352;0.806722700595856 0.806722700595856 0.806722700595856;0.82166200876236 0.82166200876236 0.82166200876236;0.836601316928864 0.836601316928864 0.836601316928864;0.851540625095367 0.851540625095367 0.851540625095367;0.866479933261871 0.866479933261871 0.866479933261871;0.881419241428375 0.881419241428375 0.881419241428375;0.896358549594879 0.896358549594879 0.896358549594879;0.911297857761383 0.911297857761383 0.911297857761383;0.926237165927887 0.926237165927887 0.926237165927887;0.941176474094391 0.941176474094391 0.941176474094391],...
%     'Color',[0.800000011920929 0.800000011920929 0.800000011920929]);


% For each set of bars, find the centers of the bars, and write error bars
% pause(0.1); %pause allows the figure to be created
% bw = get(b1,'barwidth');
% bw = bw(1); % all are same
% bw = bw{1}; % convert from cell to single variable
% for ib = 1:numel(b1)
%     %XData property is the tick labels/group centers; XOffset is the offset
%     %of each distinct group
%     %xData = b1(ib).XData+ b1(ib).XOffset;
%     xData=get(get(b1(ib),'Children'),'XData');
%     xData = xData(1,:) + bw/2; %get to the middle
%     errorbar(xData,saveDistbyGrpMean(ib,:),saveDistbyGrpStd(ib,:),'k', 'LineStyle','none');
% end

%set (gca, 'XTick',[1 2 3 4], 'XTickLabel',{'[0.01, 0.10]','[0.11, 0.20]','[0.31, 0.40]','[0.41, 0.50]'});
% set (gca, 'XTick',[1 2 3], 'XTickLabel',{'[0.01, 0.10]','[0.11, 0.20]','[0.31, 0.40]'});
% 
% % Create xlabel
% xlabel('Utilizaitions of the Security Tasks', 'FontSize',11);
% 
% % Create ylabel
% ylabel('Normalized Euclidean Distance', 'FontSize',11);
% 
% set(b1(1),'DisplayName','2 Tasks');
% set(b1(2),'DisplayName','3 Tasks');
% set(b1(3),'DisplayName','4 Tasks');
% set(b1(4),'DisplayName','5 Tasks');
% 
% %legend([b1(1) b1(2) b1(3) b1(4)],{'2 Tasks','3 Tasks','4 Tasks','5 Tasks'});
% 
% legend1 = legend(gca,'show');
% set(legend1,'Location','NorthWest');
% 
% 
% %{
% figure(1);
% scatter( saveDistUtil(1,:), saveDist(1, :) ,...
%     'MarkerEdgeColor',[0 0 0],'Marker','*', 'DisplayName', 'n=2');
% scatter( saveDistUtil(2,:), saveDist(2, :) ,...
%     'MarkerEdgeColor',[0 0 0],'Marker','o', 'DisplayName', 'n=3');
% scatter( saveDistUtil(3,:), saveDist(3, :) ,...
%     'MarkerEdgeColor',[0 0 0],'Marker','+', 'DisplayName', 'n=4');
% scatter( saveDistUtil(4,:), saveDist(4, :) ,...
%     'MarkerEdgeColor',[0 0 0],'Marker','square', 'DisplayName', 'n=5');
% 
% ylim(gca,[0 1]);
% 
% 
% % Create xlabel
% xlabel('Utilizaitions of the Security Tasks', 'FontSize',11);
% 
% % Create ylabel
% ylabel('Normalized Euclidean Distance', 'FontSize',11);
% 
% 
% legend1 = legend(gca,'show');
% set(legend1,'Location','NorthWest');
% %}

solCountPercent = (solCount./n_tc_eachGrp).*100;

disp((solCount./n_tc_eachGrp).*100);

%save('EDistData.csv','saveDistUtil','-ascii');
%save('EDistData_count.csv','solCountPercent','-ascii');
dlmwrite('EDistData_count.csv',solCountPercent,'delimiter','\t','precision',3);
dlmwrite('EDistData_mean.csv',saveDistbyGrpMean,'delimiter','\t','precision',3);
dlmwrite('EDistData_std.csv',saveDistbyGrpStd,'delimiter','\t','precision',3);

% 
% figure(2)
% bar3(solCount);

disp('Done everything');

clear global QUIET; % turn on reporting from GP
