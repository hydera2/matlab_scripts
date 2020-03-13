function [B, acc, tpr, tnr] = RandomForest(new_feats, labels, NTrees)

features_tmp = new_feats;

fprintf('Random Trees...\n');
if(isempty(NTrees))
    NTrees = 1000;
end

B = TreeBagger(NTrees, features_tmp, labels, 'OOBPred', 'on', 'OOBVarImp', 'on');
[Y,scores] = predict(B, features_tmp);
oobErrorBaggedEnsemble = oobError(B);

acc=0;
tpr=0;
tnr=0;

acc = 1 - mode(oobErrorBaggedEnsemble(round(NTrees/2): NTrees,1));
[Yfit,Sfit] = oobPredict(B);
tp = sum(str2num(cell2mat(Yfit)) == labels & labels==1);
tpr = tp / sum(labels==1);

tn = sum(str2num(cell2mat(Yfit)) == labels & labels==0);
tnr = tn / sum(labels==0);

end