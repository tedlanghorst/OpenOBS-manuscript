clear
clc

load("/Users/Ted/GDrive/Sag2022/Data/OOBS/OBS0/07/parsedData.mat")
data{1}.obs = rs;
load("/Users/Ted/GDrive/Sag2022/Data/OOBS/OBS1/25/parsedData.mat")
data{2}.obs = rs;
load("/Users/Ted/GDrive/Sag2022/Data/OOBS/OBS3/13/parsedData.mat")
data{3}.obs = rs;
load("/Users/Ted/GDrive/Sag2022/Data/OOBS/OBS4/09/parsedData.mat")
data{4}.obs = rs;
load("/Users/Ted/GDrive/Sag2022/Data/OOBS/OBS5/30/parsedData.mat")
data{5}.obs = rs;

data{1}.pt = readtable("/Users/Ted/GDrive/Sag2022/Data/PTs/OBS0_PT_Sag2022_BaroCompensated.csv");
data{2}.pt = readtable("/Users/Ted/GDrive/Sag2022/Data/PTs/OBS1_PT_Sag2022_BaroCompensated.csv");
data{3}.pt = readtable("/Users/Ted/GDrive/Sag2022/Data/PTs/OBS3_PT_Sag2022_BaroCompensated.csv");
data{4}.pt = readtable("/Users/Ted/GDrive/Sag2022/Data/PTs/OBS4_PT_Sag2022_BaroCompensated.csv");
data{5}.pt = readtable("/Users/Ted/GDrive/Sag2022/Data/PTs/OBS5_PT_Sag_2022_BaroCompensated.csv");

for i = 1:length(data)
    %bias correct NTUs so that 1st percentile is 0 NTU.
    data{i}.obs.NTU = data{i}.obs.NTU - quantile(data{i}.obs.NTU,0.01);
    if isfield(data{i},'pt')
        data{i}.pt.dt = data{i}.pt.Date + duration(hour(data{i}.pt.Time), minute(data{i}.pt.Time), second(data{i}.pt.Time));
        data{i}.obs.level = interp1(data{i}.pt.dt, data{i}.pt.LEVEL, data{i}.obs.dt);
    end
end

%% plot level and turbidity for 3 periods
close all
% c = brewermap(9,'Reds').*1;
c = colormap('parula');
colors = c(round(linspace(20,length(c)-20,5)),:);

bgColor = 1;

data{5}.obs.NTU(282:283) = NaN;

tiledlayout(2,3,'TileSpacing','compact','Padding','compact')

axIdx = 1;
ax(1) = nexttile;
hold on
set(gca,'Color',bgColor.*[1 1 1])
for i = 1:5
   p(i) = plot(data{i}.obs.dt,data{i}.obs.level,'-','Linewidth',2,'Color',colors(i,:));
end
ax(axIdx).XLim = [datetime('2022-06-16 6:00'), datetime('2022-06-18 18:00')];
ax(axIdx).YLim = [0.6,1.6];
ax(axIdx).YTick = 0.8:0.2:1.4;
% ax(1).XTick = [datetime('2022-07-03'), datetime('2022-07-04')];
ax(1).XTickLabel = ax(1).XTickLabel;
ylabel("Depth (m)")
title('Early Summer')
box on


axIdx = axIdx+1;
ax(axIdx) = nexttile;
hold on
set(gca,'Color',bgColor.*[1 1 1])
for i = 1:5
   p(i) = plot(data{i}.obs.dt,data{i}.obs.level,'-','Linewidth',2,'Color',colors(i,:));
end
ax(axIdx).XLim = [datetime('2022-07-8'), datetime('2022-07-10 12:00')];
ax(axIdx).YLim = [0.6,1.8];
ax(axIdx).YTick = 0.8:0.4:1.6;
% ax(1).XTick = [datetime('2022-07-03'), datetime('2022-07-04')];
ax(axIdx).XTickLabel = ax(axIdx).XTickLabel;
% ylabel("Turbidity (NTU)")
title('Mid Summer')
box on

axIdx = axIdx+1;
ax(axIdx) = nexttile;
hold on
set(gca,'Color',bgColor.*[1 1 1])
for i = flip(1:5)
   color = c((i-1)*2+1,:);
   p(i) = plot(data{i}.obs.dt,data{i}.obs.level,'-','Linewidth',2,'Color',colors(i,:));
end
lgd = legend(p,{'1','2','3','4','5'});
title(lgd,'Site number')
lgd.Location = 'eastoutside';

ax(axIdx).XLim = [datetime('2022-08-06 6:00:00'), datetime('2022-08-9')];
% ax(axIdx).YLim = [0, 350];
ax(axIdx).XTick = ax(axIdx).XTick(1:2);
ax(axIdx).XTickLabel = ax(axIdx).XTickLabel;
% ylabel("Turbidity (NTU)")
title('Late Summer')
box on

axIdx = axIdx+1;
ax(axIdx) = nexttile;
hold on
set(gca,'Color',bgColor.*[1 1 1])
for i = 1:5
   p(i) = plot(data{i}.obs.dt,data{i}.obs.NTU,'-','Linewidth',2,'Color',colors(i,:));
end
ax(axIdx).XLim = [datetime('2022-06-16 6:00'), datetime('2022-06-18 18:00')];
ax(axIdx).YLim = [0, 150];
% ax(1).XTick = [datetime('2022-07-03'), datetime('2022-07-04')];
ax(axIdx).XTickLabel = ax(axIdx).XTickLabel;
ylabel("Turbidity (NTU)")
% title('Early Season - Spatial')
box on


axIdx = axIdx+1;
ax(axIdx) = nexttile;
hold on
set(gca,'Color',bgColor.*[1 1 1])
for i = 1:5
   p(i) = plot(data{i}.obs.dt,data{i}.obs.NTU,'-','Linewidth',2,'Color',colors(i,:));
end
ax(axIdx).XLim = [datetime('2022-07-8'), datetime('2022-07-10 12:00')];
ax(axIdx).YLim = [0, 700];
% ax(1).XTick = [datetime('2022-07-03'), datetime('2022-07-04')];
ax(axIdx).XTickLabel = ax(axIdx).XTickLabel;
% ylabel("Turbidity (NTU)")
% title('Early Season - Spatial')
box on

axIdx = axIdx+1;
ax(axIdx) = nexttile;
hold on
set(gca,'Color',bgColor.*[1 1 1])
for i = flip(1:5)
   color = c((i-1)*2+1,:);
   p(i) = plot(data{i}.obs.dt,data{i}.obs.NTU,'-','Linewidth',2,'Color',colors(i,:));
end
lgd = legend(p,{'1','2','3','4','5'});
title(lgd,'Site number')
lgd.Location = 'eastoutside';

ax(axIdx).XLim = [datetime('2022-08-06 6:00:00'), datetime('2022-08-9')];
ax(axIdx).YLim = [0, 350];
ax(axIdx).XTick = ax(axIdx).XTick(1:2);
ax(axIdx).XTickLabel = ax(axIdx).XTickLabel;
% ylabel("Turbidity (NTU)")
% title('Late Season - Spatial')
box on

set(gcf,'Units','Inches')
set(gcf,'Position',[1 1 6.5 3])

%done spatial
% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/Sag/Spatial_2x3.png','Resolution',1200)


%% hysteresis only
close all
tiledlayout(1,3,'TileSpacing','compact','Padding','compact')


siteNumber = 2;
reds = flip(brewermap(100,'Reds'));
colormap(reds(1:90,:))

axIdx = 1;
ax(axIdx) = nexttile;
set(gca,'Color',bgColor.*[1 1 1])
iEvent = data{siteNumber}.obs.dt>datetime('2022-06-16 ') & data{siteNumber}.obs.dt<datetime('2022-06-19 ');
x = data{siteNumber}.obs.level(iEvent);
y = data{siteNumber}.obs.NTU(iEvent);
t = cumsum(iEvent(iEvent));
patch([x; nan],[y; nan],[y; nan],[t; nan], 'edgecolor', 'interp','Linewidth',2); 
ylabel("Turbidity (NTU)")
xlabel("Water Depth (m)")
set(gca,'YLim',[50,150])
title('Early Summer')
box on


axIdx = axIdx+1;
ax(axIdx) = nexttile;
set(gca,'Color',bgColor.*[1 1 1])
iEvent = data{siteNumber}.obs.dt>datetime('2022-07-08 00:00') & data{siteNumber}.obs.dt<datetime('2022-07-10 12:00');
x = data{siteNumber}.obs.level(iEvent);
y = data{siteNumber}.obs.NTU(iEvent);
t = cumsum(iEvent(iEvent));
patch([x; nan],[y; nan],[y; nan],[t; nan], 'edgecolor', 'interp','Linewidth',2); 
% ylabel("Turbidity (NTU)")
xlabel("Water Depth (m)")
set(gca,'YLim',[0,700])
set(gca,'XLim',[1.2,1.5])
title('Mid Summer')
box on


axIdx = axIdx+1;
ax(axIdx) = nexttile;
set(gca,'Color',bgColor.*[1 1 1])
iEvent = data{siteNumber}.obs.dt>datetime('2022-08-06 12:00') & data{siteNumber}.obs.dt<datetime('2022-08-9');
x = data{siteNumber}.obs.level(iEvent);
y = data{siteNumber}.obs.NTU(iEvent);
t = cumsum(iEvent(iEvent));
patch([x; nan],[y; nan],[y; nan],[t; nan], 'edgecolor', 'interp','Linewidth',2); 
title('Late Summer')
xlabel("Water Depth (m)")
set(gca,'XLim',[1.2,1.7])
cbar = colorbar();
cbar.Label.String = "Hours";
cbar.Ticks = 0:10:60;

box on

% set(gca,'YLim',[-100,3000])

set(gcf,'Units','Inches')
set(gcf,'Position',[1 1 6.5 2])

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/Sag/Hysteresis.png','Resolution',1200)




