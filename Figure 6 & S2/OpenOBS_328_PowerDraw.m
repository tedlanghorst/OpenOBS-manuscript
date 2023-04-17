clear
close all
clc

load('/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/PowerDraw/Sleep.mat')

%current draw in mA. 10 R shunt
I = V/10 * 1000;

%smooth high freq. noise and bias correct
II = smoothdata(I,'gaussian',500)-0.2;

%shift time to start at 0 when logger turns on
t_start = 0.210739;
t_end = 1.17142;
t_idx = (t>t_start & t<t_end);
I_on = mean(II(t_idx));
t_on = t_end-t_start;

t0 = t - t_start;

%annotation intevals
ti = [-0.15, 0, 0.22216, 0.513453, 0.70721, .960687, 1.15];
labels = {sprintf('Power\noff'),sprintf('Power\non'),sprintf('Open data\nfile'),'Measure',sprintf('Cleanup &\nset alarm'),sprintf('Power\noff')};


figure
hold on
plot(t0,II,'Linewidth',1)
set(gca,'YLim',[-10,50])
set(gca,'YTick',[0:10:50])

for i = 1:length(labels)
    textHeight = -5;
    text((ti(i)+ti(i+1))/2,textHeight,labels{i},'HorizontalAlignment','center')
end
for i = 2:length(ti)-1
    plot([ti(i),ti(i)],get(gca,'YLim'),'r--','Linewidth',1)
end

set(gca,'XLim',[ti(1),ti(end)])
xlabel('Time (s)')
ylabel('Current draw (mA)')
title('Measurement cycle, sleep > 5s')
set(gcf,'Units','Inches')
set(gcf,'Position',[2 2 6.5 3])
box on

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/PowerDraw/PowerDraw.png','Resolution',1200)

%%
close all
load('/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/PowerDraw/Continuous.mat')

%current draw in mA. 10 R shunt
I = V/10 * 1000;

%smooth high freq. noise
II = smoothdata(I,'gaussian',500);

%shift time to start at 0 when logger turns on
t_start = 1.3796;
t_end = 2.30133-0.006;
t_idx = (t>t_start & t<t_end);
I_on = mean(II(t_idx));
t_on = t_end-t_start;

t0 = t - t_start;

%annotation intevals
ti = [-0.1, 0, 0.17, 0.3];
labels = {'Light sleep','Measure','Light sleep'};

figure
hold on
plot(t0,II,'Linewidth',1)
set(gca,'XLim',[-0.1,0.3])
set(gca,'YLim',[-10,50])
set(gca,'YTick',0:10:50)

for i = 1:length(labels)
    textHeight = -2.5;
    text((ti(i)+ti(i+1))/2,textHeight,labels{i},'HorizontalAlignment','center')
end
for i = 2:length(ti)-1
    plot([ti(i),ti(i)],get(gca,'YLim'),'r--','Linewidth',1)
end

xlabel('Time (s)')
ylabel('Current draw (mA)')
title('Measurement cycle, sleep < 5s')
set(gcf,'Units','Inches')
set(gcf,'Position',[2 2 6.5 3])
box on

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/PowerDraw/PowerDraw_continuous.png','Resolution',1200)

%%
close all
clc

I_on = 10.85;
I_off = 0.05;
t_on = 0.96;

LIon = 800;
LiSOCl2 = 2000;

t_off = logspace(log10(5),log10(3600),100)';

I_bar = ((I_on*t_on + I_off.*t_off)./(t_on+t_off));
I_bar_cont = 2;

T1 = LiSOCl2./I_bar;
T1_cont = LiSOCl2./I_bar_cont;

T2 = LIon./I_bar;
T2_cont = LIon./I_bar_cont;


figure
hold on
c = get(gca,'ColorOrder');
plot(t_off,T1/24,'Linewidth',1.5,'Color',c(1,:))
plot(t_off,T2/24,'Linewidth',1.5,'Color',c(2,:))
plot(1, T1_cont/24,'*','Color',c(1,:),'Linewidth',1)
plot(1, T2_cont/24,'*','Color',c(2,:),'Linewidth',1)
xlabel('Measurement interval')
ylabel('Battery life (days)')
title('Estimated Battery Life')
legend('2000 mAh Li-SOCl2','800 mAh Li-ion','Location','SouthEast')
set(gca,'YLim',[10,1700],'XLim',[0.5,10000])
set(gca,'XScale','log','YScale','log')
set(gca,'YTick',[10,100,365,1000])
set(gca,'XTick',[1,5,60,300,900,3600])
set(gca,'XTickLabel',{'1s','5s','1m','5m','15m','60m'})
% grid on
box on

set(gcf,'Units','inches')
set(gcf,'Position',[1 1 4 3]);

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/PowerDraw/BatteryLife.png','Resolution',1200)






