clear
close all
clc

cd /Users/Ted/GDrive/OpenOBS-328/manuscript/figures/Tanana
d{1} = readtable("./209175.csv");
d{2} = readtable("./210571.csv");
d{3} = readtable("./211590.csv");

sd_data = readtable("/Users/Ted/GDrive/OpenOBS-328/manuscript/rev1/TananaLakes/201-20221004-20230616.csv");
sd_data.time = datetime(sd_data.unixTime, 'ConvertFrom', 'posixtime','Format','dd-MM-yyyy HH:mm:ss');


sn = [200, 201, 202];

calDir = "/Users/Ted/GDrive/OpenOBS/calibrations_v2/";
for i=1:length(d)
    %trim data
%     d{i} = d{i}(d{i}.time<datetime('2022-10-19') & d{i}.time>datetime("2022-10-7"),:);
    
    %apply calibrations
    calPath = dir(sprintf("%s%03u/*.mat",calDir,sn(i)));
    if isempty(calPath)
        d{i}.NTU = NaN(length(d{i}.time),1);
    else
        [~,mostRecent] = max([calPath.datenum]);
        calFile = fullfile(calPath(mostRecent).folder,calPath(mostRecent).name);
        load(calFile,"lm");
        d{i}.NTU = predict(lm,d{i}.backscatter);
        bias = quantile(d{i}.NTU,0.1);
        d{i}.NTU = d{i}.NTU - bias +5; %remove bias
        d{i}.NTU = smooth(convertTo(d{i}.time,'excel'),d{i}.NTU,12);
        
        if sn(i) == 200
            sd_data.NTU = predict(lm,sd_data.backscatter);
            sd_data.NTU = sd_data.NTU - bias +5; %remove bias
            sd_data.NTU = smooth(convertTo(sd_data.time,'excel'),sd_data.NTU,12);
        end
    end
end

transmitted = false(height(sd_data),1);
for i=1:height(sd_data)
    if any(abs(d{1}.time - sd_data.time(i)) < minutes(30))
        transmitted(i) = true;
    end
end
sd_data.transmitted = transmitted;

c = lines;

figure
hold on

%fake some lines for the legend.
for i = 1:3
   plot(sd_data.time(end-1:end),[0,1],'.-','Color',c(i,:),'Linewidth',1,'MarkerSize',15)
end

plot(sd_data.time,sd_data.NTU,'-','Color',c(1,:),'Linewidth',1)
plot(sd_data.time(transmitted),sd_data.NTU(transmitted),'.','Color',c(1,:),'MarkerSize',15)
   
plot(d{2}.time,d{2}.NTU,'.-','Color',c(2,:),'Linewidth',1,'MarkerSize',15)
plot(d{3}.time,d{3}.NTU,'.-','Color',c(3,:),'Linewidth',1,'MarkerSize',15)
   
ylabel("Turbidity (NTU)")
set(gca,'YLim',[0,200])
set(gca,'XLim',[datetime('2022-10-7'), datetime('2022-10-16')])
% set(gca,'XTick',get(gca,'XTick'))


% set(gca,'XTickMode','manual')
lgd = legend("1","2","3",'Location','NorthWest');
box on
title(lgd,'Site number')


set(gcf,'Units','Inches')
set(gcf,'Position',[1 1 5 3.5])
set(gca,'XTick',get(gca,'XTick'))
set(gca,'XTickLabel',get(gca,'XTickLabel')) %stupid but removes the year.

exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/Tanana/Tananaloggers.png','Resolution',1200)