function [features svm_features] = progress_over_time(feat_num, svm_selection)

%feat_num in feature selected stage
%use svm_selection(feat_num(i)) for in whole feature space
testdir={'C:\Users\sgarg\Desktop\EEG\New Shaun Data', 'C:\Users\sgarg\Desktop\EEG\New Shaun Data 2', 'C:\Users\sgarg\Desktop\EEG\Shaun_Data_03', 'C:\Users\sgarg\Desktop\EEG\Shaun_Data_04','C:\Users\sgarg\Desktop\EEG\Shaun_Data_05'};
% Correct for age
load('C:\Users\sgarg\Documents\MATLAB\age_correction_parameters.mat');

load('C:\Users\sgarg\Documents\MATLAB\mean.mat');
load('C:\Users\sgarg\Documents\MATLAB\std.mat');

feat = svm_selection(feat_num);
age = [];
for eachdir =1:length(testdir)
    [features_no_age{eachdir}, p_age, dir_numsubj] = feature_extraction(cellstr(testdir{eachdir}));    
    
    if(isempty(age))
        age = p_age;
    end
    %fitting the line
    [rows cols] = size(features_no_age{eachdir});
    
    features{eachdir} = features_no_age{eachdir};
    %for each feature
    for i=1:cols
        y = p{i}(1)*age'+p{i}(2);
        
        features{eachdir}(:,i) = features_no_age{eachdir}(:,i) - y;
    end
    %do normanlization based on mean and sd of training data
%     mn= mean(features{eachdir});
%     sd = std(features{eachdir});
    [rows cols] = size(features{eachdir});
    for i=1:cols
        features{eachdir}(:,i)=(features{eachdir}(:,i)-mn(i))/sd(i);
    end
end



numfeat = length(feat_num);
for i=1:numfeat
    for time =1:length(testdir)
        [nsubj,num]  = size(features{time});
        for subj = 1:nsubj
            sel = features{time};
            svm_features{i}(time,subj) = sel(subj, feat(i));
        end
    end
end

for i=1:numfeat
    svm_features{i}(svm_features{i}==0)=nan;
end
plot(nanmean(svm_features{1}'))
figure; plot(nanmean(svm_features{2}'))



% Try without feature normalization

%one paper on clinical assessment
%another one on return to play
%another one on severity
%accuracy prediction over time using the same model at baseline
%probability of concussion?