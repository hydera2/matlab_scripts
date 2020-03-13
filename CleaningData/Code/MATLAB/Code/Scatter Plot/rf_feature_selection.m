function [num, indices_mat] = rf_feature_selection(features, labels, NTrees, num)

% num = list of feature #s of the most important features

close all;

%test = feats_norm_ratio_unorder;
%num=1:length(features);
new_feats = features;
clear err; clear indices_mat; clear B_tree;
err=[];
B = [];

iter=4;
for i=1:iter
        
    str = ['I', num2str(i)];
    
    fprintf('Iterating ... %d\n',i);
    %classify_feature;
    [B,a,b,c] = RandomForest(new_feats, labels, NTrees);
    B_tree.(str) = B;
    
    indices = B.OOBPermutedVarDeltaError>0;
    
    num=num(indices);
    indices_mat.(str).indices = indices;
    indices_mat.(str).num = num;
    
    new_feats = features(:,indices);
    
    oobErrorBaggedEnsemble = oobError(B);
    len = length(oobErrorBaggedEnsemble);
    err = [err oobErrorBaggedEnsemble(len,1)];
    
    % plot figures
%     plot(oobErrorBaggedEnsemble);
%     xlabel('Number of grown trees');
%     ylabel('Out-of-bag classification error');
    
    %title(['Iteration ', num2str(i)]);
end
save workspace;
end
