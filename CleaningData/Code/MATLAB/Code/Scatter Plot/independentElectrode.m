
function [list , acc] = independentElectrode(rf_selection, features_rf,  results )
list = combntns(1:11,5);
[rows cols] = size(list);
acc=[];
for j=1:rows
    j
    combine_features=[];
    for k=1:cols
        num = list(j,k);
        i = results.RFFeat.RF.electrode_num(num);
        indices = ((rf_selection >= (i-1)*9+1)& rf_selection <= i*9) | ( (rf_selection >= (i-1)*21+244) & (rf_selection <= i*21+243));
        combine_features = [combine_features features_rf(:,indices)];
    end
    

    [Model accuracy tpr tnr] = RandomForest(combine_features, results.labels, 1000);   % Random Forest classification
    acc = [acc; accuracy];
end