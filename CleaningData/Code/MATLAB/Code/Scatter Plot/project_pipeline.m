%  This script is the overhead script for obtaining the features and labels
%  of a dataset in a given directory
%
%
%
%

%%  INPUT PARAMETERS ----- change parameters here
%TODO: Finding the top electrodes with each method
desc=input('Enter description of this test: ');

svm_feat = 1; %run svm feature selection
rf_feat = 0; %run random forest feature selection
num_feats = 165; % number of features to reduce to for SVM feature selection
top_electrode = 1;  % run search for top individual electrodes

%   list of directories to include for these features
traindir={'C:\Users\sgarg\Desktop\EEG\New Data\Controls', 'C:\Users\sgarg\Desktop\EEG\New Data\Concussion', 'C:\Users\sgarg\Desktop\EEG\New Shaun Data'};
testdir={'C:\Users\sgarg\Desktop\EEG\Shaun_Data_03', 'C:\Users\sgarg\Desktop\EEG\Shaun_Data_04'};
tbi_dir={'C:\Users\sgarg\Desktop\EEG\Arrowsmith EEG - Norm'};

%   classification indicators for the above directories (0 = control, 1 =
%   concussed)
classdir = [0; 1; 1];
test_classdir = [1;1];
NTrees = 1000; % number of trees for random forest
NElectrodes = 27; % number of electrodes
top_elec = 10; % how many electrodes to output when determining the rank of the individual electrodes


%%  FEATURES AND LABELS EXTRACTION
[features_no_age_correction, dir_numsubj, age, files] = feature_extraction(traindir);  % extract features


%%TODO: read age
age(age==0) = 14+round(rand(size(age(age==0)))*3);

%% Correct for age
load('C:\Users\sgarg\Documents\MATLAB\age_correction_parameters.mat');
%fitting the line
[rows cols] = size(features_no_age_correction);

features = features_no_age_correction;
%for each feature
for i=1:cols
    y = p{i}(1)*age'+p{i}(2);
    
    features(:,i) = features_no_age_correction(:,i) - y;
end


%% save mean and standard deviation
mn= mean(features);
sd = std(features);
[rows cols] = size(features);
for i=1:cols
    features(:,i)=(features(:,i)-mn(i))/sd(i);
end
%save the mean and sd for testing
save mean.mat mn
save std.mat sd

fprintf('Feature extraction completed...\n');

% create list of classification labels corresponding to the order of the 
% features
train_labels = [];

for i = 1:numel(traindir)
    
    if classdir(i, 1) == 1      % if corresponding directory is concussed
        train_labels = [train_labels; ones(dir_numsubj(1, i),1)];
    elseif classdir(i, 1) == 0
        train_labels = [train_labels; zeros(dir_numsubj(1, i),1)];
    else
        error('You messed up bro.');
    end
    
end
fprintf('Labels created...\n');
results.desc = desc;
results.features = features;
results.labels = train_labels;
%   features and labels extracted and saved in the following variables:
%       - features
%       - labels
% CORRECT----CHECKED BY ARNOLD YEUNG JUL 30, 2015



%% SUBJECT CLASSIFICATION 
fprintf('Classifying subjects using all electrodes and features...\n');
if(svm_feat == 1)
    [results.All.SVMModel_LOO results.All.SVM.acc results.All.SVM.tpr results.All.SVM.tnr] = SVM_LOO(features, train_labels);        % SVM leave-one-out classification
    fprintf('Linear SVM completed...\n');
end
if(rf_feat == 1)
    [results.All.RFModel results.All.RF.acc results.All.RF.tpr results.All.RF.tnr] = RandomForest(features, train_labels, NTrees);   % Random Forest classification
    fprintf('Random Forest completed...\n');
end


num = 1:length(features);

%% FEATURE SELECTION
if(svm_feat==1)     % feature selection using SVM
        fprintf('Running SVM feature selection...\n');
    [svm_selection] = svm_feature_selection(features, train_labels, num_feats);
    features_svm = features(:,svm_selection);   % features reduced to only most important features
else
    features_svm = features;
end
save svm_selection.mat svm_selection
results.SVMFeat.features = features_svm;

indices_mat = [];
if (rf_feat==1)     % feature selection using Random Forest
    fprintf('Running Random Forest feature selection...\n');
    [rf_selection, indices_mat] = rf_feature_selection(features, train_labels, NTrees, num);
    features_rf = features(:,rf_selection);
else
    features_rf = features;
end
results.RFFeat.features = features_rf;
results.RFFeat.iterate_FeatSelect = indices_mat;
% CORRECT (FOR SVM) ----CHECKED BY ARNOLD YEUNG JUL 30, 2015

%% TOP INDEPENDENT ELECTRODES
if(top_electrode == 1)
    if(svm_feat==1)
        fprintf('Calculating top electrodes using SVM...\n');
        [results.SVMFeat.SVM.electrode_errors, results.SVMFeat.SVM.electrode_name, results.SVMFeat.SVM.electrode_num] = iterate_electrode('svm', features_svm, train_labels, NTrees, svm_selection, NElectrodes, top_elec ); % calculates the error for each individual electrode
        if (rf_feat==1)
        [results.SVMFeat.RF.electrode_errors, results.SVMFeat.RF.electrode_name, results.SVMFeat.RF.electrode_num] = iterate_electrode('rf', features_svm, train_labels, NTrees, svm_selection, NElectrodes,top_elec );
        end
        %[svm_elec_tally, svm_feat_tally] = sort_features(svm_selection);           % sort important features based on which electrode and which "location-independent" feature
    end
    if(rf_feat==1)
        fprintf('Calculating top electrodes using RF...\n');
        [results.RFFeat.SVM.electrode_errors, results.RFFeat.SVM.electrode_name, results.RFFeat.SVM.electrode_num] = iterate_electrode('svm', features_rf, train_labels, NTrees, rf_selection, NElectrodes, top_elec ); % calculates the error for each individual electrode
        [results.RFFeat.RF.electrode_errors, results.RFFeat.RF.electrode_name, results.RFFeat.RF.electrode_num] = iterate_electrode('rf', features_rf, train_labels, NTrees, rf_selection, NElectrodes,top_elec );     % calculates the error for each individual electrode
        %[rf_elec_tally, rf_feat_tally] = sort_features(rf_selection);           % sort important features based on which electrode and which "location-independent" feature
    end
end

%% SUBJECT CLASSIFICATION 
fprintf('Classifying subjects...\n');
if(svm_feat == 1)
    results.SVMFeat.SVM.desc='Features selected using SVM';
    [results.SVMFeat.SVMModel_LOO results.SVMFeat.SVM.acc results.SVMFeat.SVM.tpr results.SVMFeat.SVM.tnr] = SVM_LOO(features_svm, train_labels);        % SVM leave-one-out classification
    if (rf_feat==1)
    [results.SVMFeat.RFModel results.SVMFeat.RF.acc results.SVMFeat.RF.tpr results.SVMFeat.RF.tnr] = RandomForest(features_svm, train_labels, NTrees);
    end
    fprintf('Linear SVM completed...\n');
end
if(rf_feat == 1)
    results.RFFeat.RF.desc='Features selected using Random Forest';
    [results.RFFeat.RFModel results.RFFeat.SVM.acc results.RFFeat.SVM.tpr results.RFFeat.SVM.tnr] = SVM_LOO(features_rf, train_labels);        % SVM leave-one-out classification
    [results.RFFeat.RFModel results.RFFeat.RF.acc results.RFFeat.RF.tpr results.RFFeat.RF.tnr] = RandomForest(features_rf, train_labels, NTrees);   % Random Forest classification
    fprintf('Random Forest completed...\n');
end


[Model5y, accuracy, tpr, tnr] = SVM_LOO(features, train_labels, 1 ,1)
[Model10y, accuracy, tpr, tnr] = SVM_LOO(features, train_labels, 2 ,1)


[Model5ysvm, accuracy, tpr, tnr] = SVM_LOO(features_svm, train_labels, 1 ,1)
[Model10ysvm, accuracy, tpr, tnr] = SVM_LOO(features_svm, train_labels, 2 ,1)

%% TEST dataset
[test_features, test_dir_numsubj] = feature_extraction(testdir);  % extract features

%do normanlization based on mean and sd of training data
for i=1:cols
    test_features(:,i)=(test_features(:,i)-mn(i))/sd(i);
end
fprintf('Feature extraction completed...\n');

test_labels = [];

for i = 1:numel(testdir)
    
    if test_classdir(i, 1) == 1      % if corresponding directory is concussed
        test_labels = [test_labels; ones(test_dir_numsubj(1, i),1)];
    elseif test_classdir(i, 1) == 0
        test_labels = [test_labels; zeros(test_dir_numsubj(1, i),1)];
    else
        error('You messed up bro in testing.');
    end
end

results.test.true_labels = test_labels;
%SVM prediction on Full dataset
svm_out_labels = predict(results.All.SVMModel_LOO.svmModel, test_features);
results.test.All.svm_out_labels = svm_out_labels;
results.test.All.SVM.acc = sum(svm_out_labels == test_labels)/length(test_labels);

%SVM prediction on svm selected features
svm_out_labels = predict(results.SVMFeat.SVMModel_LOO.svmModel, test_features(:,svm_selection));
results.test.SVMFeat.svm_out_labels = svm_out_labels;
results.test.SVMFeat.SVM.acc = sum(svm_out_labels == test_labels)/length(test_labels);

if (rf_feat==1)
    %RF prediction on Full dataset
    [rf_out_labels] = predict(results.All.RFModel, test_features);
    results.test.All.rf_out_labels = rf_out_labels;
    results.test.All.RF.acc = sum(cell2mat(rf_out_labels)==num2str(test_labels))/length(test_labels);
    
    %RF prediction on svm selected features
    [rf_out_labels] = predict(results.All.RFModel, test_features(:,svm_selection));
    results.test.SVMFeat.rf_out_labels = rf_out_labels;
    results.test.SVMFeat.RF.acc = sum(cell2mat(rf_out_labels)==num2str(test_labels))/length(test_labels);
    
    %SVM prediction on RF selected features
    svm_out_labels = predict(results.All.SVMModel_LOO.svmModel, test_features(:,rf_selection));
    results.test.RFFeat.svm_out_labels = svm_out_labels;
    results.test.RFFeat.SVM.acc = sum(svm_out_labels == test_labels)/length(test_labels);
    
    %RF prediction on RF selected features
    [rf_out_labels] = predict(results.All.RFModel, test_features(:,rf_selection));
    results.test.RFFeat.rf_out_labels = rf_out_labels;
    results.test.RFFeat.RF.acc = sum(cell2mat(rf_out_labels)==num2str(test_labels))/length(test_labels);
    
    
    [comb_list , comb_acc] = independentElectrode(rf_selection, features_rf,  results );
    [a,b] = sort(comb_acc,1, 'descend');
    fprintf('Best accuracy obtained by: ');
    comb_list(b(1),:)
end

save results.mat results

str = datestr(datetime('now'));
str = ['workspace-',str];
save(strrep(str,':','_'))

fprintf('Pipeline completed.\n');