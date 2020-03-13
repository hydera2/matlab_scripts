function testing_new_data(directory)

directory = {directory};

test_classdir = [0 0 0];

%%TODO: need svm_selection and SVM MODEL
load('svm_selection.mat');
load('features.mat');
load('features_svm.mat');
load('train_labels.mat');

if (~exist('mn','var'))
    load('mean.mat');
end
if (~exist('sd','var'))
    load('std.mat');
end

svmModel_all = fitcsvm(features, train_labels, 'KernelFunction', 'linear', 'BoxConstraint', 1);
svmModel_svm = fitcsvm(features_svm, train_labels, 'KernelFunction', 'linear', 'BoxConstraint', 1);

%% TEST dataset
[test_features_nac, test_dir_numsubj, age] = feature_extraction(directory);  % extract features

%age= 14+round(rand(size(age))*3);

%% Correct for age
load('age_correction_parameters.mat');
%fitting the line
[rows cols] = size(test_features_nac);

test_features = test_features_nac;
%for each feature
for i=1:cols
    y = p{i}(1)*age'+p{i}(2);
    
    test_features(:,i) = test_features_nac(:,i) - y;
end


%do normanlization based on mean and sd of training data
for i=1:cols
    test_features(:,i)=(test_features(:,i)-mn(i))/sd(i);
end
fprintf('Feature extraction completed...\n');

subj_num=1;
[list_dir]=dir(char(directory));
% For each subject
fprintf('Creating scatter plots')
for file = list_dir'
    if(strcmp(file.name, '.') == 0 && strcmp(file.name,'..') == 0 && strcmp(file.name, 'desktop.ini') == 0 && strcmp(file.name, '$Recycle.Bin') == 0 && strcmp(file.name, 'Config.Msi') == 0 && strcmp(file.name, 'ScalpPlotData') == 0)
        fprintf('Now on: %s... ', file.name);
        plot_scatter(char(directory), file.name, features_svm, test_features(subj_num,svm_selection));
        subj_num=subj_num+1;
        fprintf('Done.\n');
    end
end


test_labels = [];

for i = 1:numel(directory)
    
    if test_classdir(i) == 1      % if corresponding directory is concussed
        test_labels = [test_labels; ones(test_dir_numsubj(1, i),1)];
    elseif test_classdir(i) == 0
        test_labels = [test_labels; zeros(test_dir_numsubj(1, i),1)];
    else
        error('You messed up bro in testing.');
    end
end

[ScoreSVMModel_all,ScoreParameters_all]  = fitSVMPosterior(svmModel_all);
[ScoreSVMModel_svm,ScoreParameters_svm]  = fitSVMPosterior(svmModel_svm);


results.test.true_labels = test_labels;
%SVM prediction on Full dataset
[svm_out_labels, scores_all] = predict(ScoreSVMModel_all, test_features)
acc = sum(svm_out_labels == test_labels)/length(test_labels);


%SVM prediction on svm selected features
[svm_out_labels, scores_svm] = predict(ScoreSVMModel_svm, test_features(:,svm_selection))
acc = sum(svm_out_labels == test_labels)/length(test_labels);
end