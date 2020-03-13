function [Model, accuracy, tpr, tnr] = SVM_LOO(features, labels)
%   This code is a leave-one-out method

%%   SVM parameters
fprintf('Reading SVM parameters...\n');       
kernel_fcn = 'linear';      % type of kernel function to use ('linear', 'gaussian', or 'polynomial')
C = 1;                     % C parameter (aka box constraint): scale between smooth boundary and fitting training set (default = 1)

%%   training dataset
fprintf('Loading training dataset...\n');

weights = [];           % weights of each feature per interation

num_out = 5;
indices = 1:size(features, 1);
for i = 1:size(features, 1)        % for each sample
    
    test_indices = i:1+num_out;
    train_indices = setdiff(indices, test_indices);
    %   create test and training sets
    test_sample = features(i, :);
    test_labels(i, 1) = labels(i, :);
    
    if i == 1
        training_features = features(2:end, :);
        training_labels = labels(2:end, :);
    elseif i == size(training_features, 1)
        training_features = features(1:size(features, 1)-1, :);
        training_labels = labels(1:size(features, 1)-1, :);
    else
        training_features = [features(1:i-1, :); features(i+1:end, :)];
        training_labels = [labels(1:i-1, :); labels(i+1:end, :)];
    end
    
    %   train svm Model
    svmModel = fitcsvm(training_features, training_labels, ...          
            'KernelFunction', kernel_fcn, 'BoxConstraint', C);
    
    %   predict test sample    
    out_labels(i, 1) = predict(svmModel, test_sample);    
    
    %   get weights
    weights = [weights svmModel.Beta];
end

%%  calculate accuracy, true positive rate, true negative rate

true_pos = 0;
true_neg = 0;
false_pos = 0;
false_neg = 0;

Model.svmModel = svmModel;
Model.weights = weights;
%   count true positives, true negatives, false positives, and false
%   negatives
for i = 1:length(out_labels)
    if test_labels(i, 1) == 1        % real positive
        if out_labels(i, 1) == 1     % predicted positive
            true_pos = true_pos + 1;
        else                        % predicted negative
            false_neg = false_neg + 1;
        end
    else                            % real negative
        if out_labels(i, 1) == 0     % predicted negative
            true_neg = true_neg + 1;
        else                        % predicted positive
            false_pos = false_pos + 1;
        end
    end
end

%   calculate accuracy
accuracy = (true_pos + true_neg) / (true_pos + true_neg + false_pos + false_neg);
tpr= true_pos / (true_pos + false_neg);
tnr = true_neg / (true_neg + false_pos);


end
