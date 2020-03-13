function [electrode_errors, elec_name, elec_num] = iterate_electrode(method, features, labels, NTrees, feats_selection, num_electrodes, num_top_electrodes) 

% It iterates over each electrode and runs random forest on each one and
% calculate the accuracy of each electrode and store it in electrode_errors variable
%
% method - 'svm' or 'rf'
% features - features to look at (important features)
% labels - labels corresponding to the feature matrix
% NTrees - number of trees to run random forest
% num_electrodes - number of electrodes to analyse (27)
% feats_selection - a vector containing the feature #s of the features to
% look at (indices of the important features)
% num_top_electrodes - How many top electrodes to be selected
%
%
% formerly iterate_electrode_rf.m (Jul 29, 2015)
%

clear B_tree; clear err; clear acc; clear tpr; clear tnr;

electrode_errors=[];
acc_svm=[];
%{
acc=[];
tpr=[];
tnr=[];
acc_gauss = [];
tpr_gauss = [];
tnr_gauss = [];
%}
B = [];

for i=1:num_electrodes % for each electrode
    i
    % indices contain the feature #s of the features corresponding with the
    % corresponding electrode
    indices = ((feats_selection >= (i-1)*9+1)& feats_selection <= i*9) | ( (feats_selection >= (i-1)*21+244) & (feats_selection <= i*21+243));
    electrode_features = features(:,indices);   % features of the corresponding electrodes from the most important features

    if size(electrode_features)
        %TODO: if electrode_features is empty ...do not run this
        if strcmp(method, 'rf') == 1
            [Model accuracy tpr tnr] = RandomForest(electrode_features, labels, NTrees);   % Random Forest classification
            str = ['I', num2str(i)];
            electrode_tree.(str) = Model;      % store information for the random forest of each electrode

            oobErrorBaggedEnsemble = oobError(Model); % error rates (1-accuracy) of the NTrees (i.e. accuracy curve)
            len = length(oobErrorBaggedEnsemble); % number of trees
            mode_error = mode(oobErrorBaggedEnsemble(round(len/2):len,1)); % mode of the error rates in the last third of the curve
            electrode_errors = [electrode_errors mode_error];
        elseif strcmp(method, 'svm') == 1
            [Model accuracy tpr tnr] = SVM_LOO(electrode_features, labels);
            acc_svm = [acc_svm accuracy];
        end
    else
        if strcmp(method, 'svm') == 1
            fprintf('****************WARNING !!!! Electrode %d has no good features************\n',i);
            acc_svm = [acc_svm 0]; % 0 is a marker that the corresponding electrode do not have any associated top important features (i.e. 100% error rate)
        end
        if strcmp(method, 'rf') == 1
            fprintf('****************WARNING !!!! Electrode %d has no good features************\n',i);
            electrode_errors = [electrode_errors 1]; % 1 is a marker that the corresponding electrode do not have any associated top important features (i.e. 100% error rate)
        end
    end

   % add in the error rate as corresponding to this electrode 
    electrode_errors % print out electrode_errors 
    close all;  % close all diagrams
end

% check to make sure electrode_errors has same size of num_electrodes
if size(electrode_errors, 2) ~= num_electrodes && strcmp(method, 'rf') == 1
    error('electrode_errors does not include all electrodes');
elseif size(acc_svm, 2) ~= num_electrodes && strcmp(method, 'svm') == 1
    error('acc_svm does not include all electrodes');
end

if strcmp(method, 'rf') == 1
    acc_rf = 1 - electrode_errors;
    [a, rf] = sort(acc_rf);
    elec_num = rf(num_electrodes-num_top_electrodes:num_electrodes);        % select the top "num_top_electrodes" electrodes
elseif strcmp(method, 'svm') == 1
    electrode_errors = 1-acc_svm;
    [a, svm] = sort(acc_svm);
    elec_num = svm(num_electrodes-num_top_electrodes:num_electrodes);
end

%TODO: convert electrode numbers to electrode character values
[num,name,raw] = xlsread('C:\Users\sgarg\Desktop\EEG\code\Electrode_numbering.csv');
elec_name = name(elec_num,1);

