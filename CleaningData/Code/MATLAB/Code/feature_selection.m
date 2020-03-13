function fs = feature_selection(Xtrain, Ytrain)
%this function performs sequential feature selection using 10-fold cross
%validation

fun = @(XT,yT,Xt,yt)...
      (sum(~strcmp(yt,classify(Xt,XT,yT,'quadratic'))));
  
c = cvpartition(y,'k',10);
opts = statset('display','iter');
[fs,history] = sequentialfs(fun,Xtrain,Ytrain,'cv',c,'options',opts);
end