function [elec_tally, feat_tally] = sort_features(feats_selection)

% LOL what is this?
% This function takes in the important features and sorts them based on the
% electrode number (out of 27) and feature number (out of 30) 
%
% feats_selection - feature numbers of the important features 
% 
% elec_tally - vector of 1 x number_of_electrodes with each value indicating
% the number of features that match with said electrode
% feat_tally - vector of 1 x number_of_location_indep_features with each
% value indicating the number of features that match with those features
%
%
% formerly electrodeNum.m (Jul 29, 2015)

len = length(feats_selection);
elec_tally=[];
feat_tally=[];
for i=1:len
    if (feats_selection(i) <= 243 )
        %for power spectral features
        elec_tally = [elec_tally (ceil(feats_selection(i)/9))];
        feat_tally = [feat_tally mod(feats_selection(i), 9)+1];
    else
        %for wavelet features
        elec_tally = [elec_tally (ceil((feats_selection(i) - 243)/21))];
        feat_tally = [feat_tally mod((feats_selection(i) - 243), 21)+10];
    end    
end

hist(elec_tally, 27);
% hist(feat_tally, 165);