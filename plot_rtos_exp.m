clc;
clear all;
close all;
clf;

data = csvread('rdtsc_val_csv.csv');

data = max(data);
data = fliplr(data); %just for good plotting

figure(1);
hold on;
box on;

barh(data, 'FaceColor',[0.862745106220245 0.862745106220245 0.862745106220245]);

% Create axes
set(gca,...
    'YTickLabel',{'Other','Div and Kernerl','FS Lib',' FS bin','TW bin'},...
    'YTick',[1 2 3 4 5],...
    'XTick',[0 2000000000 4000000000 6000000000 8000000000 10000000000 12000000000 14000000000 16000000000 18000000000],...
    'XGrid','on', 'FontSize',15);
X = (1:5);
 

set(gca,'YTick',1:5,'YTickLabel','') 
% Define the labels 
lab = [{'Conf  '};{'Ker  '};{'FS\_Lib  '};{'FS\_Bin  '};{'IDS\_Bin  '}];
% Estimate the location of the labels based on the position 
% of the xlabel 
hx = get(gca,'YLabel');  % Handle to xlabel 
set(hx,'Units','data'); 
pos = get(hx,'Position'); 
y = pos(2); 
% Place the new labels 
for i = 1:size(lab,1) 
    t(i) = text(y,X(i)+0.1,lab(i,:)); 
end 
set(t,'Rotation',48,'HorizontalAlignment','right', 'Fontsize', 18);

% Create xlabel
xlabel('WCET (cycle counts)',  'FontSize',18);
a = get(gca,'XTickLabel');
%set(gca,'XTickLabel',a,'fontsize',12)




