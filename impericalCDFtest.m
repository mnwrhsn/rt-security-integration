%data = csvread('dt.csv');

data = csvread('convergenceData.csv');
time_data = csvread('timeData.csv');
dub = 200;

gdata = find(data>200);

% get timing information
for i=1:length(gdata)
    time_data(gdata(i)) = [];
end

%length(time_data);
%data

data = data(data < dub);

n = length(data);

t = 50;
edist = zeros(1, 5);
for i=1:t
    edist(i) = (length(find(data<=i)))/n;
end


hold on;
%edist
%plot(1-edist, 'r');

figure(1)
hold on;
box on;
grid on;

[f,x] = ecdf(data);

plot(x, f, 'Marker','o','LineWidth',1,'LineStyle','-', ...
    'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);


% set(gca,...
%     'XTick',[2 4 6 8 10 12 14 16 18 20 22 24 26 28 30]);
set(gca,...
     'XTick',[0 5 10 15 20 25 30 35 40 45 50 55 60]);

% Uncomment the following line to preserve the X-limits of the axes
%xlim(gca,[0 31]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(gca,[-0.03 1.03]);


% Create xlabel
xlabel('Number of Iterations to Converge', 'FontSize',11);

% Create ylabel
ylabel('Empirical CDF', 'FontSize',11);


mean_time = mean(time_data);
std_time = std(time_data);