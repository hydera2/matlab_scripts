function plot_scatter(testdir, group,  features_svm, feature)

len  = length(group);
features_new = [features_svm; feature];
[coeff,score,latent] = pca(features_new);
data = score;

figure('Visible', 'Off'), clf;
scatter3(data(1:33,1),data(1:33,2),data(1:33,3),'r','markerfacecolor', 'r','markeredgecolor','r');
hold on;


markers= ['+', '*' ,'.' ,'x','s','d','^' ,'>','p','<','v','h'];
clr =  ['c','m','y','b','w','k'];

grp = unique(group);
az = -4;
el = 8;
view(az, el);
scatter3(data(34:54,1),data(34:54,2),data(34:54,3),'g','markerfacecolor', 'g','markeredgecolor','g');
for i=1:length(grp)
    idx = find(group==grp(i));
    for j=idx(1):idx(end)
        scatter3(data(j+54,1),data(j+54,2),data(j+54,3),markers(1),clr(j-idx(1)+1),'markerfacecolor', clr(j-idx(1)+1),'markeredgecolor',clr(j-idx(1)+1));
    end
end
H3 = legend('Control', 'Concussed','long data','location', 'SouthWestOutside');
set(gcf, 'Position', [469 58 1194 920]);
set(H3,'fontsize',12)
set(gca,'color', 'k')
% set(gca,'Xtick',[])
% set(gca,'Ytick',[])
% set(gca,'Ztick',[])
box on;
set(gca, 'BoxStyle','full')
set(gca,'Xcolor','white')
set(gca,'Ycolor','white')
set(gca,'Zcolor','white')
set(gcf,'color', 'k')
set(gca, 'LineWidth',2)
fig = gcf;
fig.InvertHardcopy = 'off';
fig.Visible = 'on';
% saveas(gcf,[testdir,'\',name,'\scatterplot.png'])
end