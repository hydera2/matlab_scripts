function plot_scatter(testdir, name,  features_svm, feature)

features_new = [features_svm; feature];
[coeff,score,latent] = pca(features_new);
data = score;

figure('Visible', 'Off'), clf;
scatter3(data(1:33,1),data(1:33,2),data(1:33,3),'r','markerfacecolor', 'r','markeredgecolor','r');
hold on;

az = -4;
el = 8;
view(az, el);
scatter3(data(34:end-1,1),data(34:end-1,2),data(34:end-1,3),'g','markerfacecolor', 'g','markeredgecolor','g');
scatter3(data(end,1),data(end,2),data(end,3),'^','b','markerfacecolor', 'b','markeredgecolor','b');
H3 = legend('Control', 'Concussed',name,'location', 'SouthWestOutside');
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
% fig.Visible = 'on';
saveas(gcf,[testdir,'\',name,'\scatterplot.png'])
end