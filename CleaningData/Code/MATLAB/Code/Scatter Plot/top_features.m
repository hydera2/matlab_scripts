

%% finding the top features

svmModel = fitcsvm(features_svm, train_labels, 'KernelFunction', 'linear', 'BoxConstraint', 1);
[a,b] = sort(abs((svmModel.Beta')), 'descend');

[c,d] = xlsread('C:\Users\sgarg\Desktop\EEG\code\Electrode_numbering.csv',1)
num_electrodes=27;
feats_selection = b(1:15);
%get the electrode
elec=[];
for j=1:size(feats_selection,2)
    feat = svm_selection(feats_selection(j));
    if (feat <= 243)
        elec = [elec d(ceil(feat/9))];
    else
        feat = feat - 243;
        elec = [elec d(ceil(feat /21))];
    end
end
unique(elec, 'stable')
