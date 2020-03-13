traindir={'C:\Users\sgarg\Desktop\EEG\New Data\Controls', 'C:\Users\sgarg\Desktop\EEG\New Data\Concussion', 'C:\Users\sgarg\Desktop\EEG\New Shaun Data'};
testdir={'C:\Users\sgarg\Desktop\EEG\Shaun_Data_03'};
tbi_dir={'C:\Users\sgarg\Desktop\EEG\Arrowsmith EEG - Norm'};
tbi_controls={'C:\Users\sgarg\Desktop\EEG\Arrowsmith_controls'};
%%  FEATURES AND LABELS EXTRACTION
[features, dir_numsubj] = feature_extraction(traindir);  % extract features
[tbi_feat, dir_numsubj] = feature_extraction(tbi_dir);  % extract features
[tbi_feat_cont, dir_numsubj] = feature_extraction(tbi_controls);  % extract features
fprintf('Feature extraction completed...\n');


[COEFF, SCORE, LATENT] = pca(features_svm);
a= SCORE(:,1:4);

% figure;
% scatter3(a(1:33,1),a(1:33,2),a(1:33,3),'*r')
% hold on
% scatter3(a(34:55,1),a(34:55,2),a(34:55,3),'^b')
% scatter3(a(56:65,1),a(56:65,2),a(56:65,3),'+g')

num=4;
dim=2;
mn = min(a(:,dim));
mx = max(a(:,dim));

interval = (mx - mn) /num;

figure; 
for i=1:num
    ind = find(a(:,dim) < (mn+i*interval) & a(:,dim) > (mn+(i-1)*interval));
    b = a(ind(ind<33),:);
    c = a(ind(~(ind<33)),:);
    %subplot(1,num,i);
    scatter3(b(:,1),b(:,2),b(:,3),400*i/num,'r')
    hold on
    scatter3(c(:,1),c(:,2),c(:,3),400*i/num,'b')
    hold on
end

features_svm_1 = [features; tbi_feat];
[COEFF, SCORE, LATENT] = pca(features_svm);