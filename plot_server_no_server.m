clc;
clear all;
close all;
clf;


% load('ser_n_ser.mat', 'etaCount_arr_GP',     'etaCount_UB_arr_GP',     'etaCount_LB_arr_GP', ...
%     'ecdist_arr_GP', 'etaCount_arr_NS',     'etaCount_UB_arr_NS', ...
%     'etaCount_LB_arr_NS',     'ecdist_arr_NS');

load('ser_n_ser_newcon.mat', 'etaCount_arr_GP',     'etaCount_UB_arr_GP',     'etaCount_LB_arr_GP', ...
    'ecdist_arr_GP', 'etaCount_arr_NS',     'etaCount_UB_arr_NS', ...
    'etaCount_LB_arr_NS',     'ecdist_arr_NS');


figure(1)
hold on;
grid on;

subplot(2,1,1)
hold on;
grid on;

plot(ecdist_arr_GP, 'Marker','square','LineWidth',1,...
    'DisplayName','With Security Server',...
    'Color',[0 0 0]);
plot(ecdist_arr_NS, 'Marker','o','LineWidth',1,...
    'DisplayName','Without Security Server',...
    'Color',[0 0 0]);

set(gca, 'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'0.30','0.35','0.40','0.45','0.50','0.55','0.60','0.61','0.70','0.75','0.80'},...
    'XTick',[1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]);
box(gca,'on');
%ylim(gca,[0 1]);


% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('\xi',  'FontSize',11);

% Create legend
legend1 = legend(gca,'show');
set(legend1,'Location','NorthWest');


subplot(2,1,2)
hold on;
grid on;




plot(etaCount_arr_GP, 'Marker','square','LineWidth',1,...
    'DisplayName','With Security Server',...
    'Color',[0 0 0]);


plot(etaCount_arr_NS, 'Marker','o','LineWidth',1,...
    'DisplayName','Without Security Server',...
    'Color',[0 0 0]);

set(gca,...
    'XTickLabel',{'0.30','0.35','0.40','0.45','0.50','0.55','0.60','0.61','0.70','0.75','0.80'}, ...
    'XTick',[1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]);
box(gca,'on');


% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('\eta',  'FontSize',11);

% Create legend
legend1 = legend(gca,'show');
set(legend1,'Location','SouthWest');



