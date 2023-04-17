clear
close all
clc

cd /Users/Ted/GDrive/OpenOBS-328/manuscript/figures/Tanana
d{1} = readtable("./209175.csv");
d{2} = readtable("./210571.csv");
d{3} = readtable("./211590.csv");

sn = [200, 201, 202];

calDir = "/Users/Ted/GDrive/OpenOBS/calibrations_v2/";
for i=1:length(d)
    %apply calibrations
    calPath = dir(sprintf("%s%03u/*.mat",calDir,sn(i)));
    if isempty(calPath)
        d{i}.NTU = NaN(length(d{i}.time),1);
    else
        [~,mostRecent] = max([calPath.datenum]);
        calFile = fullfile(calPath(mostRecent).folder,calPath(mostRecent).name);
        load(calFile,"lm");
        d{i}.NTU = predict(lm,d{i}.backscatter);
        d{i}.NTU = d{i}.NTU - quantile(d{i}.NTU,0.1)+5; %remove bias
        d{i}.NTU = smooth(convertTo(d{i}.time,'excel'),d{i}.NTU,12);
    end
end


figure
hold on
for i = 1:length(d)
   plot(d{i}.time,d{i}.NTU,'.-','Linewidth',1,'MarkerSize',15)
end
ylabel("Turbidity (NTU)")
set(gca,'YLim',[0,200])
set(gca,'XLim',[datetime('2022-10-7'), datetime('2022-10-16')])

lgd = legend("1","2","3",'Location','NorthWest');
box on
title(lgd,'Site number')


set(gcf,'Units','Inches')
set(gcf,'Position',[1 1 5 3.5])
set(gca,'XTick',get(gca,'XTick'))
set(gca,'XTickLabel',get(gca,'XTickLabel')) %weird but removes the year.

% exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/Tanana/Tananaloggers.png','Resolution',1200)