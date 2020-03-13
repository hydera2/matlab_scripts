
[COEFF, SCORE, LATENT] = princomp(features_svm, tbi_feat);
features_svm_1 = [features_svm; tbi_feat];
[COEFF, SCORE, LATENT] = pca(features_svm_1);
a= SCORE(:,1:4);
% figure; 
% plot(a(1:33,1),a(1:33,2),'*r')
% hold on
% plot(a(34:55,1),a(34:55,2),'^b')
% 
figure;
scatter3(a(1:33,1),a(1:33,2),a(1:33,3),'*r')
hold on
scatter3(a(34:55,1),a(34:55,2),a(34:55,3),'^b')
scatter3(a(56:65,1),a(56:65,2),a(56:65,3),'+g')


%%
num=4;
dim=3;
mn = min(a(:,dim));
mx = max(a(:,dim));

interval = (mx - mn) /num;

figure;
for i=1:num
    ind = find(a(:,dim) < (mn+i*interval));
    b = a(ind(ind<33),:);
    c = a(ind(~(ind<33)),:);
    subplot(1,num,i);
    scatter(b(:,1),b(:,2),40*i/num,'*')
    hold on
    scatter(c(:,1),c(:,2),40*i/num,'o')
end

%%

[COEFF, SCORE, LATENT] = princomp(features_svm);
[COEFF, SCORE, LATENT] = pca(features_svm);
a= SCORE(:,1:4);
% figure; 
% plot(a(1:33,1),a(1:33,2),'*r')
% hold on
% plot(a(34:55,1),a(34:55,2),'^b')
% 
% figure;
% scatter3(a(1:33,1),a(1:33,2),a(1:33,3),'*r')
% hold on
% scatter3(a(34:55,1),a(34:55,2),a(34:55,3),'^b')


num=1;
dim=3;
mn = min(a(:,dim));
mx = max(a(:,dim));

interval = (mx - mn) /num;

figure;
for i=1:num
    ind = find(a(:,dim) < (mn+i*interval));
    b = a(ind(ind<33),:);
    c = a(ind(~(ind<33)),:);
    subplot(1,num,i);
    scatter(b(:,1),b(:,2),40*i/num,'*')
    hold on
    scatter(c(:,1),c(:,2),40*i/num,'o')
end
