%   This code was originally written by Saurabh.
%   Compatibility edits have been by Arnold Yeung.

% features = new_feats;
% fprintf('Random Trees...\n');
% if(isempty(NTrees))
%     NTrees = 1000;
% end
% 
% B = TreeBagger(NTrees, features, labels, 'OOBPred', 'on', 'OOBVarImp', 'on');
% [Y,scores] = predict(B, features);
% oobErrorBaggedEnsemble = oobError(B);

%%
clf;

% feats3D = feats_norm_3D;
features = new_feats;

numElectrode=27;
numFeatures=27;
feature=[];
kfold=5;
testeval=[];

fprintf('Random Trees...\n');

NTrees = 1000;
fprintf('Number of trees: %d...\n', NTrees);
B = TreeBagger(NTrees, features, labels, 'OOBPred', 'on', 'OOBVarImp', 'on');
fprintf('Done generating ensemble...\n');
[Y,scores] = predict(B, features);
fprintf('Done calculating scores...\n');
%use scores to calculate the probability of it belonging to a class

oobErrorBaggedEnsemble = oobError(B);
%classError = figure(1);
%plot(oobErrorBaggedEnsemble);
%xlabel('Number of grown trees');
%ylabel('Out-of-bag classification error');

% determining the importance of each feature
%importance = figure(2);
%bar(B.OOBPermutedVarDeltaError);
%xlabel('Feature number');
%ylabel('Out-of-bag feature importance');
%title('Feature importance results');

%figure(1);
%figure(2);



fprintf('Done.\n');