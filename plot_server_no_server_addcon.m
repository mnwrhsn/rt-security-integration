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

set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'0.50','0.55','0.60','0.65','0.70','0.75','0.80','0.85','0.90','0.95','1.00'},...
    'XTick',[1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]);
box(gca,'on');
ylim(gca,[0 1]);


% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('\xi',  'FontSize',11);

% Create legend
legend1 = legend(gca,'show');
set(legend1,'Location','NorthEast');


subplot(2,1,2)
hold on;
grid on;

eta_arr = [etaCount_arr_GP; etaCount_arr_NS];
X = eta_arr;
% normalize to 0,1
 Xmin = min(X(:));
   Xmax = max(X(:));
   X = (X - Xmin) / (Xmax - Xmin);
%etaCount_arr_GP = X(1, :);
%etaCount_arr_NS = X(2,:);   




plot(etaCount_arr_GP, 'Marker','square','LineWidth',1,...
    'DisplayName','With Security Server',...
    'Color',[0 0 0]);


plot(etaCount_arr_NS, 'Marker','o','LineWidth',1,...
    'DisplayName','Without Security Server',...
    'Color',[0 0 0]);

set(gca,... %'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'0.50','0.55','0.60','0.65','0.70','0.75','0.80','0.85','0.90','0.95','1.00'},...
    'XTick',[1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]);
box(gca,'on');

ylim(gca,[0 5]);
% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('\eta',  'FontSize',11);

% Create legend
legend1 = legend(gca,'show');
set(legend1,'Location','NorthEast');



figure(2)
hold on;
grid on;

%subplot(2,1,1)
hold on;
grid on;

plot(ecdist_arr_GP, 'Marker','square','LineWidth',1,...
    'DisplayName','With Security Server',...
    'Color',[0 0 0]);
plot(ecdist_arr_NS, 'Marker','o','LineWidth',1,...
    'DisplayName','Without Security Server',...
    'Color',[0 0 0]);

set(gca,... %'YTick',[0 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'0.50','0.55','0.60','0.65','0.70','0.75','0.80','0.85','0.90','0.95','1.00'},...
    'XTick',[1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6]);
box(gca,'on');
ylim(gca,[0 1]);
%ylim(gca,[0 0.5]);


% Create xlabel
xlabel('Total Utilization',  'FontSize',11);


% Create ylabel
ylabel('\xi',  'FontSize',11);

% Create legend
legend1 = legend(gca,'show');
set(legend1,'Location','NorthWest');




