clc;
clear all;
close all;
clf;

data_base = csvread('attacktime_base.txt');
data_base

data_opt = csvread('attacktime_opt.txt');
data_opt

data = [data_opt, data_base];

data(7, :) = NaN;
%data(10, :) = NaN;
%data(12, :) = NaN;
data(11, :) = NaN;
data(12, :) = NaN;
data(13, :) = NaN;
%data(11, :) = []
%data(13, :) = []
%data(14, :) = []

%data(isnan(data))=[];




%data = nonnan(data);

data_opt = data(:, 1);
data_opt
data_base = data(:, 2);

j=1;
for i=1:length(data_opt)
    data_opt(i)
    if ~isnan(data_opt(i))
        tt(j) = data_opt(i);
        j = j+1;
        j
    end
end
data_opt = tt;


j=1;
for i=1:length(data_base)
    data_base(i)
    if ~isnan(data_base(i))
        tt(j) = data_base(i);
        j = j+1;
        j
    end
end
data_base = tt;


% data_opt(isnan(data_opt))=[];
% data_base(isnan(data_base))=[];

data_opt = fliplr(data_opt);
data_base = fliplr(data_base);

figure(1)
hold on;
grid on;

plot(data_base, 'r');
plot(data_opt, 'b');


figure(2)




data = [data_base; data_opt];
data = data';
bar1 = bar(data);
set(bar1(1),...
    'FaceColor',[0.941176474094391 0.941176474094391 0.941176474094391], 'DisplayName','Without Period Adaptation');
set(bar1(2),...
    'FaceColor',[0.800000011920929 0.800000011920929 0.800000011920929], 'DisplayName','With Period Adaptation');


set(gca,'YGrid','on','XTick',[1 2 3 4 5 6 7 8 9 10]);

xlim(gca,[0 11]);
box 'on';
hold 'on';

% Create xlabel
xlabel('Experiment #',  'FontSize',11);


% Create ylabel
ylabel('Time to Detect (cycle count)',  'FontSize',11);

legend1 = legend(gca,'show');
set(legend1,'Location','NorthWest');



%{
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

%}
display('Done everything!');
