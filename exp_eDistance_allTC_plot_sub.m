saveDistUtil = dlmread('EDistDataTC_saveDistUtil.csv');
saveDist = dlmread('EDistDataTC_saveDist.csv');

load('eta.mat','etaCount_arr', 'etaCount_UB_arr', 'etaCount_LB_arr');

etaCount_arr = 1./etaCount_arr;

%saveDistUtil 

figure(1);
subplot(2,1,1)
grid on
hold on;
box on;
[r,c] = size(saveDistUtil);
for i=1:r
  scatter( saveDistUtil(i), saveDist(i) ,...
     'MarkerEdgeColor',[0 0 0],'Marker','*');  
end


grid on
ylim(gca,[0.00 1.00]);
xlim(gca,[0.00 0.4]);
% Create xlabel
xlabel('Utilizaition of the Security Tasks', 'FontSize',11);

% Create ylabel
ylabel('Normalized Euclidean Distance', 'FontSize',11);

%[0.01, 0.10]','[0.11, 0.20]','[0.21, 0.30]', '[0.31, 0.40]'



subplot(2,1,2)
grid on
hold on;
box on

%plot(etaCount_UB_arr - etaCount_arr, 'k');
plot(etaCount_UB_arr - etaCount_arr, 'Marker','o','LineWidth',1,'Color',[0 0 0]);
%plot(-etaCount_LB_arr + etaCount_arr, 'Marker','o','LineWidth',1,'Color',[0 0 0]);
% plot(etaCount_arr, 'Marker','o','LineWidth',1,'Color',[0 0 0]);

% plot(etaCount_UB_arr);
% plot(etaCount_LB_arr);
% plot(etaCount_arr, 'r');
% Create xlabel
xlabel('Utilizaition of the Security Tasks', 'FontSize',11);

% Create ylabel
%ylabel('\eta', 'FontSize',11);
ylabel('\eta^{UB} - \eta', 'FontSize',11);
set(gca,'XTickLabel',{'0','0.05', '0.1', '0.15', '0.2', '0.25', '0.3','0.35', '0.4'});

k = 1;
l =1;
m = 1;
for i=1:length(saveDistUtil)
    
    if saveDistUtil(i) >= 0.01 && saveDistUtil(i) <= 0.10
        ug1(k) = saveDist(i);
        k = k+1;
    elseif saveDistUtil(i) >= 0.11 && saveDistUtil(i) <= 0.20
        ug2(l) = saveDist(i);
        l = l+1;
    elseif saveDistUtil(i) >= 0.21 && saveDistUtil(i) <= 0.30
        ug3(m) = saveDist(i);
        m = m+1;
    end
    
    
end

ug1

%boxplot(ug3)
figure(3)

%boxplot([ug1,ug2, ug3],'Notch','on','Labels',{'ug 1','ug 2', 'ig 3'})
hold on;
%boxplot([ug1],'Notch','on','Labels',{'ug 1'})
%boxplot([ug2], 'positions', 5, 'Labels',{'ug 2'})
%boxplot([ug3], 'positions', 5, 'Labels',{'ug 3'})

bar(1, mean(ug1));
bar(2, mean(ug2));
bar(3, mean(ug3));
xx = [mean(ug1), mean(ug2), mean(ug3)];
ss = [std(ug1), std(ug2), std(ug3)];

 % standard error of the mean
sem = [std(ug1)/sqrt(length(ug1)), std(ug2)/sqrt(length(ug2)), std(ug3)/sqrt(length(ug3))];
sem = sem .* 1.96; % 95% confidence interval

%errorbar((1:length(xx)), xx, ss); 
errorbar((1:length(xx)), xx, sem); 


disp('Done everything');


