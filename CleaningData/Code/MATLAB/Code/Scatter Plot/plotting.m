
function [a mind] = plotting(features, labels)

kernel_fcn = 'linear';      % type of kernel function to use ('linear', 'gaussian', or 'polynomial')
C = 1;                     % C parameter (aka box constraint): scale between smooth boundary and fitting training set (default = 1)

mind=[];
%for picking 3 best feauturs
for j=1:3
   
    %for each feature
    for i=1:size(features,2)
        ind = [mind i];
        training_features = features(:, ind);
        training_labels = labels;
        
        %   create test and training sets
        test_sample = features(:,ind);
        test_labels = labels;
        
        %   train svm Model
        svmModel = fitcsvm(training_features, training_labels, ...
            'KernelFunction', kernel_fcn, 'BoxConstraint', C);
        
        %   predict test sample
        out_labels = predict(svmModel, test_sample);
        
        result(i) = sum(abs(out_labels-labels));
    end
    
    [b, mx] = min(result);
     mind=[mind mx]
end
mind = [2, 12,14];
a= features(:,mind);

% figure;
% scatter3(a(1:33,1),a(1:33,2),a(1:33,3),'*r')
% hold on
% scatter3(a(34:55,1),a(34:55,2),a(34:55,3),'^b')
% scatter3(a(56:65,1),a(56:65,2),a(56:65,3),'+g')

num=1;
dim=2;
mn = min(a(:,dim));
mx = max(a(:,dim));

interval = (mx - mn) /num;

cutoff = length(labels) - sum(labels); %33

figure; 
for i=1:num
    ind = find(a(:,dim) <= (mn+i*interval) & a(:,dim) >= (mn+(i-1)*interval))
    b = a(ind(ind<=cutoff),:) %%33
    c = a(ind((ind>cutoff)),:)
    %subplot(1,num,i);
    scatter3(b(:,1),b(:,2),b(:,3),100,'r*')
    hold on
    scatter3(c(:,1),c(:,2),c(:,3),100,'b^')
    hold on
end
xlabel('Feature 1')
ylabel('Feature 2')
zlabel('Feature 3')
legend('Concussed (mTBI)','Controls','Location','NorthEast');

end