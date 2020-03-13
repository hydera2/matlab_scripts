function [Model, accuracy, tpr, tnr] = SVM_LOO(features, labels, num_out, nooverlap)
%   This code is a leave-one-out method

%%   SVM parameters
fprintf('Reading SVM parameters...\n');       
kernel_fcn = 'linear';      % type of kernel function to use ('linear', 'gaussian', or 'polynomial')
C = 1;                     % C parameter (aka box constraint): scale between smooth boundary and fitting training set (default = 1)

%%   training dataset
fprintf('Loading training dataset...\n');

weights = [];           % weights of each feature per interation

if ~exist('num_out','var')
    num_out = 2;
end
if ~exist('nooverlap','var')
    nooverlap=1;
end

indices = 1:size(features, 1);
if(nooverlap)
    jump = 2*num_out+1;
else
    jump=1;
end

true_pos = 0;
true_neg = 0;
false_pos = 0;
false_neg = 0;

% 
% for j = 1:jump:size(features, 1)        % for each sample
% 
%     
%     if(j+num_out > size(features, 1))
%         break;
%     end
%     test_indices = j:j+num_out;
%     test_indices = [test_indices (size(features, 1)-j+1 - num_out):(size(features, 1)-j+1)];
conc = sum(labels);
cntrl = sum(~labels);

tp = zeros(1,100);
fp = zeros(1,100);
fn = zeros(1,100);
tn = zeros(1,100);
out=zeros(4*num_out+2,100);
ind =zeros(4*num_out+2,100);
lab =zeros(4*num_out+2,100);
for j=1:100
    
    list = 1+unique(round(rand(1,100*num_out)*(cntrl-1)), 'stable'); %generate 100 numbers in a hope that there will be (2*num_out+1) unique numbers in them
    test_indices = list(1:2*num_out+1);
    list = cntrl+unique(round(rand(1,100*num_out)*conc), 'stable');
    test_indices = [test_indices list(1:2*num_out+1)];
    
    train_indices = setdiff(indices, test_indices);
    %   create test and training sets
    test_sample = features(test_indices, :);
    test_labels = labels(test_indices, :);
    
    training_features = features(train_indices, :);
    training_labels = labels(train_indices, :);
    
    
    %   train svm Model
    svmModel = fitcsvm(training_features, training_labels, ...          
            'KernelFunction', kernel_fcn, 'BoxConstraint', C);
    
    %   predict test sample    
    out_labels = predict(svmModel, test_sample);  
    out(:,j) = out_labels;
    ind(:,j) = test_indices; 
    lab(:,j) = test_labels;
    %%  calculate accuracy, true positive rate, true negative rate
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
    tp(j) = true_pos;
    fp(j) = false_pos;
    tn(j) = true_neg;
    fn(j) = false_neg;
    %   get weights
    weights = [weights svmModel.Beta];
end


Model.svmModel = svmModel;
Model.weights = weights;
Model.tp = tp;
Model.fp = fp;
Model.tn = tn;
Model.fn = fn;
Model.out_labels =out;
Model.test_indices = ind;
Model.test_labels = lab;
%   calculate accuracy
accuracy = (true_pos + true_neg) / (true_pos + true_neg + false_pos + false_neg);
tpr= true_pos / (true_pos + false_neg);
tnr = true_neg / (true_neg + false_pos);


end
