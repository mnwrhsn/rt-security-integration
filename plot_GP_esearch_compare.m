
clc;
clear all;
close all;
clf;


% save to a mat file
load('GP_Esearch_compare.mat','solCount_GP','solCount_esearch','distVectorX', 'distVectorY', 'distVectorZ');
%fGain = solCount_GP./solCount_esearch;
fGain = solCount_esearch./solCount_GP;

%fGain = fGain .* 100;

% fGain = (solCount_GP - solCount_esearch)./solCount_esearch;
% fGain = fGain .* 100;

fGain(5,:) = []; % delete for RT Util Group 5
figure(2)


surf(fGain', 'EdgeLighting','flat',...
    'FaceLighting','none',...
    'Marker','.',...
    'FaceColor',[0.941176474094391 0.941176474094391 0.941176474094391]);
%hold on;
%surf(0.*fGain');

%bar3(fGain');

set(gca,'YTickLabel',{'0','0.1','0.2','0.3','0.4'},...
    'XTickLabel',{'0.00','0.1','0.2','0.3','0.5'});

% Create xlabel
xlabel('Utilization of the Real-Time Tasks',  'FontSize',11);
%set(get(gca,'xlabel'),'rotation',20); %where angle is in degrees

% Create ylabel
ylabel('Utilization of the Security Tasks',  'FontSize',11);
%set(get(gca,'ylabel'),'rotation',-30); %where angle is in degrees

% Create zlabel
zlabel('Normalized % of the Schedulable Tasksets',  'FontSize',11);

figure(1)
%hold on;

scatter3(distVectorX, distVectorY, distVectorZ, 'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
    'Marker','*');

% Create xlabel
xlabel('Utilization of the Real-Time Tasks',  'FontSize',11);
set(get(gca,'xlabel'),'rotation',15); %where angle is in degrees

% Create ylabel
ylabel('Utilization of the Security Tasks',  'FontSize',11);
set(get(gca,'ylabel'),'rotation',-25); %where angle is in degrees

% Create zlabel
%zlabel('Differences in the Security Server Utilization',  'FontSize',11);
zlabel({'Differences in the';'Security Server Utilization'}, 'FontSize',11);


figure(3)

bar3(fGain');

%'[0.01, 0.10]','[0.11, 0.20]','[0.21, 0.30]', '[0.31, 0.40]'

set(gca,'YTickLabel',{'[0.01, 0.10]','[0.11, 0.20]','[0.21, 0.30]'},...
    'XTickLabel',{'[0.01, 0.10]','[0.11, 0.20]','[0.21, 0.30]','[0.31, 0.40]'});

set(gcf, 'Colormap',...
    [0.941176474094391 0.941176474094391 0.941176474094391;0.939433574676514 0.939184546470642 0.938686609268188;0.937690615653992 0.937192678451538 0.936196684837341;0.935947716236115 0.935200750827789 0.933706820011139;0.934204816818237 0.933208823204041 0.931216955184937;0.932461857795715 0.931216955184937 0.928727030754089;0.930718958377838 0.929225027561188 0.926237165927887;0.928976058959961 0.927233099937439 0.923747301101685;0.927233099937439 0.925241231918335 0.921257376670837;0.925490200519562 0.923249304294586 0.918767511844635;0.923747301101685 0.921257376670837 0.916277647018433;0.922004342079163 0.919265508651733 0.913787722587585;0.920261442661285 0.917273581027985 0.911297857761383;0.918518543243408 0.915281653404236 0.908807992935181;0.916775584220886 0.913289785385132 0.906318068504334;0.915032684803009 0.911297857761383 0.903828203678131;0.913289785385132 0.909305930137634 0.901338338851929;0.91154682636261 0.90731406211853 0.898848414421082;0.909803926944733 0.905322134494781 0.896358549594879;0.908061027526855 0.903330206871033 0.893868684768677;0.906318068504334 0.901338338851929 0.89137876033783;0.904575169086456 0.89934641122818 0.888888895511627;0.902832269668579 0.897354483604431 0.886399030685425;0.901089310646057 0.895362615585327 0.883909106254578;0.89934641122818 0.893370687961578 0.881419241428375;0.897603511810303 0.89137876033783 0.878929376602173;0.895860552787781 0.889386892318726 0.876439452171326;0.894117653369904 0.887394964694977 0.873949587345123;0.892374753952026 0.885403037071228 0.871459722518921;0.890631794929504 0.883411169052124 0.868969798088074;0.888888895511627 0.881419241428375 0.866479933261871;0.88714599609375 0.879427313804626 0.863990068435669;0.885403037071228 0.877435445785522 0.861500144004822;0.883660137653351 0.875443518161774 0.859010279178619;0.881917238235474 0.873451590538025 0.856520414352417;0.880174279212952 0.871459722518921 0.85403048992157;0.878431379795074 0.869467794895172 0.851540625095367;0.876688480377197 0.867475867271423 0.849050760269165;0.874945521354675 0.865483999252319 0.846560835838318;0.873202621936798 0.863492071628571 0.844070971012115;0.871459722518921 0.861500144004822 0.841581106185913;0.869716763496399 0.859508275985718 0.839091181755066;0.867973864078522 0.857516348361969 0.836601316928864;0.866230964660645 0.85552442073822 0.834111452102661;0.864488005638123 0.853532552719116 0.831621527671814;0.862745106220245 0.851540625095367 0.829131662845612;0.861002206802368 0.849548697471619 0.826641798019409;0.859259247779846 0.847556829452515 0.824151873588562;0.857516348361969 0.845564901828766 0.82166200876236;0.855773448944092 0.843572974205017 0.819172143936157;0.85403048992157 0.841581106185913 0.81668221950531;0.852287590503693 0.839589178562164 0.814192354679108;0.850544691085815 0.837597250938416 0.811702489852905;0.848801732063293 0.835605382919312 0.809212565422058;0.847058832645416 0.833613455295563 0.806722700595856;0.845315933227539 0.831621527671814 0.804232835769653;0.843572974205017 0.82962965965271 0.801742911338806;0.84183007478714 0.827637732028961 0.799253046512604;0.840087175369263 0.825645804405212 0.796763181686401;0.838344216346741 0.823653936386108 0.794273257255554;0.836601316928864 0.82166200876236 0.791783392429352;0.834858417510986 0.819670081138611 0.789293527603149;0.833115458488464 0.817678213119507 0.786803603172302;0.831372559070587 0.815686285495758 0.7843137383461],...
    'Color',[0.800000011920929 0.800000011920929 0.800000011920929]);


% Create xlabel
xlabel('Utilization of the Real-Time Tasks',  'FontSize',11);
set(get(gca,'xlabel'),'rotation',20); %where angle is in degrees

% Create ylabel
ylabel('Utilization of the Security Tasks',  'FontSize',11);
set(get(gca,'ylabel'),'rotation',-35); %where angle is in degrees

% Create zlabel
%zlabel('Normalized % of the Schedulable Tasksets',  'FontSize',11);
zlabel({'Normalized % of the';'Schedulable Tasksets'}, 'FontSize',11);