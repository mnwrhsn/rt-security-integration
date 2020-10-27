clc;
clear all;
close all;
clf;


load('compare_rm_bound.mat','solCount_GP', 'solCount_esearch', 'solCount_VFP', 'n_tc_eachGrp');


figure(1)
hold on;
grid on;

plot((solCount_GP./n_tc_eachGrp).*100, 'LineWidth',1,'Color',[0 0 0], ...
    'Marker','o', 'DisplayName', 'Proposed');
plot((solCount_esearch./n_tc_eachGrp).*100, 'LineWidth',1,'Color',[0 0 0], ...
    'Marker','square', 'Linestyle', '--', 'DisplayName', 'Exhaustive Search');
%plot((solCount_VFP./n_tc_eachGrp).*100, 'LineWidth',1,'Color',[1 0 1]);
set(gca,...
    'XTickLabel',{'0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
box(gca,'on');
% plots vertical line to show RM
% x1 = 4.9;
% y1=get(gca,'ylim');
% plot([x1 x1],y1, 'LineStyle',':', 'LineWidth',1,'Color',[0 0 0]);

% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('Percentage of Schedulable Task-sets',  'FontSize',11);

% Create legend
legend1 = legend(gca,'show');
set(legend1,'Location','SouthWest');



figure(2)
hold on;
bar((solCount_GP./n_tc_eachGrp).*100);
set(gca,...
    'XTickLabel',{'0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});
% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('Percentage of Schedulable Task-sets',  'FontSize',11);
