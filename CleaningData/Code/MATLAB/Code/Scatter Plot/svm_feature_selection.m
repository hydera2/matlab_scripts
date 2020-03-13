function c = svm_feature_selection(features, labels, numFeats)
%
%labels: labels 
%numFeats: number of features selected

[svmModel,na,nb,nc] = SVM_LOO(features, labels);

weights = svmModel.weights;
[a,b] = sort(abs(mean(weights')), 'descend');
c = b(1:numFeats);

end
