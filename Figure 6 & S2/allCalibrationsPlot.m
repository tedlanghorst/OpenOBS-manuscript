clear
clc
close all

cal_directory = "/Users/Ted/GDrive/OpenOBS-328/calibrations/";
listing = dir(cal_directory);
isCalFile = [listing.isdir] & ~strncmp({listing.name},'.',1) & ~strncmp({listing.name},'000',3);
listing = listing(isCalFile);


%find the most recent calibration file
figure
lgd_names = {};
for i = 1:length(listing)
    calDir = dir(fullfile(listing(i).folder,listing(i).name));
    calDir=calDir(~ismember({calDir.name},{'.','..'})); % remove . and ..
    [~,mostRecent] = max([calDir.datenum]);
    calFile = fullfile(calDir(mostRecent).folder,calDir(mostRecent).name);
    load(calFile,"lm");
    
    sn(1,i) = str2double(calDir(mostRecent).folder(end-2:end));
    R2(1,i) = lm.Rsquared.Ordinary;
    standard(:,i) = lm.Variables.y;
    measured(:,i) = lm.Variables.x1;
    predError(:,i) = predict(lm,lm.Variables.x1) - lm.Variables.y;
    
    lgd_names{i} = num2str(sn(1,i));
end

tiledlayout(1,2,'TileSpacing','compact','Padding','compact')

ax(1) = nexttile;
plot(standard,measured,'-','Linewidth',1)
xlabel("Standard (NTU)");
ylabel("Measured (DN)");
set(gca,'XTick',standard(:,1))
title('Raw Signal')
axis square
box on
% lgd = legend(lgd_names,'Location','WestOutside');
% title(lgd,'Serial No.')

ax(2) = nexttile;
b = boxchart(predError');
hold on
xlabel("Standard (NTU)");
ylabel("Calibration - Standard (NTU)");
set(gca,'XTickLabel',standard(:,1))
title('Calibration Error')
axis square
box on
plot([0,6],[0,0],'k--','Linewidth',1.5)
% set(gca,'XLim',[0,6])

% set(gca,'YScale','log')



set(gcf,'Units','inches')
set(gcf,'Position',[1 1 6.5 3]);

saveas(gcf,fullfile(cal_directory,"all_calibrations.png"))


% lims = get(gca,'XLim') + [-50,50];
% set(gca,'XLim',lims,'YLim',lims)

%%

close all
figure
hold on
for i = 1:5
    [f,xi] = ksdensity(predError(i,:),'Bandwidth',2,'Kernel','normal');
    f = f./(sum(f))*25;
    patch(f+i,xi,lines(1));
end

xlabel("Standard (NTU)");
ylabel("Error (NTU)");
title("Calibration Error")

plot([0,6],[0,0],'k--','Linewidth',1.5)
set(gca,'XLim',[0.5,6])
set(gca,'XTick',1:5)
set(gca,'XTickLabel',standard(:,1))
set(gca,'YTick',-15:5:15)
set(gcf,'Units','inches')
set(gcf,'Position',[1 1 3.5 3]);
box on



exportgraphics(gcf,'/Users/Ted/GDrive/OpenOBS-328/manuscript/figures/calibration/smoothErrors.png','Resolution',1200)







