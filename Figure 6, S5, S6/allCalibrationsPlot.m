clear
clc
close all

cal_directory = "/Users/Ted/GDrive/OpenOBS-328/calibrations/";
listing = dir(cal_directory);
isCalFile = [listing.isdir] & ~strncmp({listing.name},'.',1) & ~strncmp({listing.name},'000',3);
listing = listing(isCalFile);


%find the most recent calibration file
lgd_names = {};
skipCount = 0;
for i = 1:length(listing)
    calDir = dir(fullfile(listing(i).folder,listing(i).name));
    calDir=calDir(~ismember({calDir.name},{'.','..'}));
    [~,mostRecent] = max([calDir.datenum]);
    calFile = fullfile(calDir(mostRecent).folder,calDir(mostRecent).name);
    load(calFile,"lm");

    if lm.Variables.x1(1)>3750
        skipCount = skipCount+1;
        continue
    end

    date(1,i-skipCount) = datetime(calDir(mostRecent).name(1:end-4),'InputFormat','yyyyMMdd');
    sn(1,i-skipCount) = str2double(calDir(mostRecent).folder(end-2:end));
    R2(1,i-skipCount) = lm.Rsquared.Ordinary;
    standard(:,i-skipCount) = lm.Variables.y;
    measured(:,i-skipCount) = lm.Variables.x1;
    predError(:,i-skipCount) = predict(lm,measured(:,i-skipCount)) - standard(:,i-skipCount);
    
    lgd_names{i-skipCount} = num2str(sn(1,i-skipCount));
end



% RBR calibrations
RBR_cal_dir = "/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/RBR/";
RBR_files = dir([RBR_cal_dir+"*.mat"]);
for i = 1:length(RBR_files)
    filepath = fullfile(RBR_files(i).folder,RBR_files(i).name);
    RBR(i) = load(filepath);
    lm = fitlm(RBR(i).measured',RBR(i).standard');
    RBR_NTU(:,i) = predict(lm,RBR(i).measured');
    RBR_predError(:,i) = RBR_NTU(:,i)-RBR(i).standard';
    RBR_standard(:,i) = RBR(i).standard';
end


% calibration error boxchart
figure
b = boxchart(predError');
hold on
plot(RBR_predError(:,1:3),'ro','Linewidth',1)
plot([0,6],[0,0],'k--','Linewidth',1)
xlabel("Standard (NTU)");
ylabel("Calibration - Standard (NTU)");
set(gca,'XTickLabel',standard(:,1))
title('Calibration Error')
% axis square
box on

ylim([-30,30])
leg = legend("{\it OpenOBS-328}  n=72",["{\it RBR virtuoso}    "+char(8201)+"n=3"],'Location','Northeast');
leg.ItemTokenSize(1) = 10;

set(gcf,'Units','inches')
set(gcf,'Position',[1 1 3.5 2.5]);


% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/calibrationError_RBR.png','Resolution',1200)
%% calibration error histograms
% https://www.mathworks.com/matlabcentral/answers/822795-boxplot-and-histogram-in-one-plot
close all

x = 1:5;
y = predError';

binWidth = 2;    % histogram bin widths
hgapGrp = .1;   % horizontal gap between pairs of boxplot/histograms (normalized)
xLim = [0.5,6];

hcounts = cell(size(y,2),2); 
for i = 1:size(y,2)
    [hcounts{i,1}, hcounts{i,2}] = histcounts(y(:,i),'BinWidth',binWidth); 
end
maxCount = max([hcounts{:,1}]);

fig = figure();
ax = axes(fig); 
hold(ax,'on')
box on
plot(xLim,[0,0],'k--','Linewidth',0.75)
xInterval = mean(diff(sort(x))); % x-interval (best if x is at a fixed interval)

histX0 = x;    % histogram base
maxHeight = xInterval * (1-hgapGrp);       % max histogram height
patchHandles = gobjects(1,size(y,2)); 
for i = 1:size(y,2)
    % Normalize heights 
    height = hcounts{i,1}/maxCount*maxHeight;
    % Compute x and y coordinates 
    xm = [zeros(1,numel(height)); repelem(height,2,1); zeros(2,numel(height))] + histX0(i);
    yidx = [0 0 1 1 0]' + (1:numel(height));
    ym = hcounts{i,2}(yidx);
    %remove empty patches
    isEmpty = all(xm==i,1);
    xm(:,isEmpty)=[];
    ym(:,isEmpty)=[];
    % Plot patches
    patchHandles(i) = patch(xm,ym,[0 0.5 1],'FaceAlpha',0.75);
end
h = plot(x,RBR_predError(:,1:3),'ro','Linewidth',1,'MarkerSize',4);
set(gca,'XLim',xLim,'Xtick',x,'XTickLabel',standard(:,1)');
set(gca,'YLim',[-35,35])

leg = legend([patchHandles(1),h(1)],"{\it OpenOBS-328}  n=76",["{\it RBR virtuoso}    "+char(8201)+"n=3"],'Location','Northeast');
leg.ItemTokenSize(1) = 10;

set(gcf,'Units','inches')
set(gcf,'Position',[1 1 3.5 2.5]);
xlabel("Standard (NTU)");
ylabel("Calibration - Standard (NTU)");
title('Calibration Error')
% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/calibrationError_histograms.png','Resolution',1200)

%%
close all

figure
hold on
lgd_names = {};
for i = 1:4
    plot(RBR(i).standard,RBR(i).measured,'Linewidth',2)
    lgd_names{i} = RBR_files(i).name(1:6);
end
plot([0,1000],[0,1000],'k--','Linewidth',0.5)
set(gca,'XLim',[0,1000])
ylim([0,1000])
box on
ylabel("Measured")
xlabel("Standards (pretty old though)")
lgd_names{i+1} = "1:1 line";
legend(lgd_names,'Location',"Northwest")

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/RBR/RBR_calibrations.png','Resolution',600)

%%
clc
close all


[dates,~,ic] = unique(date);
%merge the jan 1 2000 dates into next smallest group.
if dates(1)==datetime(2000,1,1)
    ic(ic==1) = 2;
    ic = ic-1;
    dates(1) = [];
end

figure
t=tiledlayout(3,3);
nexttile;
for i = 1:max(ic)
    nexttile;
    dateMatch = ic==i;
    plot(standard(:,dateMatch),measured(:,dateMatch),'.-')
    set(gca,'XLim',[0,1000],'YLim',[2500,8500])
    text(25,7900,string(dates(i)),'FontWeight','bold')
    set(gca,'XTick',standard(:,1),'YTick',[3000,4500,6000,7500])
end
xlabel(t, 'Standards (NTU)')
ylabel(t, 'Raw readings (DN)')
% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/calibration_days.png','Resolution',600)

figure
histogram(R2);
axis square
xlabel("Calibration R^2")
ylabel("Count")
set(gca,'YLim',[0,35])
set(gca,'XTick',[0.998,0.999,1])
% legend("{\it OpenOBS-328}  n=72",'Location','NorthWest')
set(gcf,'Units','inches')
set(gcf,'Position',[1 1 3.5 2.5]);
exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/calibration_R2.png','Resolution',600)

figure
tiledlayout(1,2,'TileSpacing','compact');
nexttile;
plot(standard,measured,'.-');
axis square
xlabel('Standards (NTU)')
ylabel('Raw backscatter (DN)')
set(gca,'XLim',[0,1000],'YLim',[2500,8500])
set(gca,'XTick',standard(:,1),'YTick',[3000,4500,6000,7500])

nexttile;
histogram(R2);
axis square
xlabel("Calibration R^2")
ylabel("Count")
set(gca,'YLim',[0,35])
set(gca,'XTick',[0.998,0.999,1])

set(gcf,'Units','inches')
set(gcf,'Position',[5 5 6.5 3])

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/calibration_stats.png','Resolution',600)
















