function process_long_data(directory)
cd('/home/eeglewave/Documents/Report Generation/Code/MATLAB/Code/Scatter Plot')
group = [ones(1,4), 2*ones(1,5), 3*ones(1,5), 4*ones(1,2), 5*ones(1,3), 6*ones(1,2), 7*ones(1,5), 8*ones(1,4), 9*ones(1,5), 10*ones(1,5)];

load('svm_selection.mat');
load('features.mat');
load('features_svm.mat');
load('train_labels.mat');

if (~exist('mn','var'))
    load('mean.mat');
end
if (~exist('sd','var'))
    load('std.mat');
end

directory = {directory};
%% TEST dataset
[test_features_nac, test_dir_numsubj, age] = feature_extraction(directory);  % extract features


%% Correct for age
load('age_correction_parameters.mat');
%fitting the line
[rows cols] = size(test_features_nac);

test_features = test_features_nac;
%for each feature
for i=1:cols
    y = p{i}(1)*age'+p{i}(2);
    
    test_features(:,i) = test_features_nac(:,i) - y;
end


%do normanlization based on mean and sd of training data
for i=1:cols
    test_features(:,i)=(test_features(:,i)-mn(i))/sd(i);
end
fprintf('Feature extraction completed...\n');


% For each subject
fprintf('Creating longitudinal scatter plots')

plot_scatter_long(char(directory), group, features_svm, test_features(:,svm_selection));

fprintf('Done.\n');



end