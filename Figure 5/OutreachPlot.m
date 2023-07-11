clear
close all


dataDir = '/Users/Ted/GDrive/Tanana OBS Project/Travel and field work/January2023_Outreach_IceInstall/Data/NenanaOBS/';

tmp = load([dataDir,'NSS1.mat']);
bias = quantile(tmp.d.ambient_light,0.01);
tmp.d.ambient_light = tmp.d.ambient_light - bias;
NSS1 = tmp.d;

tmp = load([dataDir,'NSS2.mat']);
bias = quantile(tmp.d.ambient_light,0.01);
tmp.d.ambient_light = tmp.d.ambient_light - bias;
NSS2 = tmp.d;

tmp = load([dataDir,'NSS3.mat']);
bias = quantile(tmp.d.ambient_light,0.01);
tmp.d.ambient_light = tmp.d.ambient_light - bias;
NSS3 = tmp.d;

NSS1_sd = 3.0504;

% plots
close all
figure
set(gcf,'Units','normalized')
set(gcf,'Position',[.25 .4 .2 .2])

tiledlayout(2,1,'TileSpacing','compact','Padding','compact')
ax(1) = nexttile;
hold on
patch([NSS1.dt; flip(NSS1.dt)],[NSS1.NTU+NSS1_sd.*3; flip(NSS1.NTU-NSS1_sd.*3)],[0 0.447 0.741],'FaceAlpha',0.25,'LineStyle','none')
plot(NSS1.dt,NSS1.NTU,'Linewidth',1.5)
set(gca,'YLim',[0,50])
ylabel("Turbidity (NTU)")
% legend("NSS1","NSS2","NSS3","location","NorthEast")
title("Tanana River at Nenana")
box on

ax(2) = nexttile;
hold on
plot(NSS1.dt,(NSS1.ambient_light).*0.5,'Linewidth',1.5)

ax(1).XLim = [datetime('2023-01-25'), datetime('2023-01-31')];
set(gca,'YLim',[0,15])
ylabel("Ambient light (lux)")
set(gca,'XLim',get(ax(1),'XLim'))
box on
linkaxes(ax,'x')

set(gcf,'Units','inches')
set(gcf,'Position',[1 1 6.5 3.25]);

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/outreach/outreachPlot.png','Resolution',1200)