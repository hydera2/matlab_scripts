
function [badChannels, EEG] = amnaFASTER(EEG, outputFilesPath, subjname)
badChannelsPath = fullfile(outputFilesPath,'badChannels');
%% Identify and interpolate bad channels using FASTER %%
fprintf('\nPerforming bad channel detection...\n');
eeg_chans = 1:EEG.nbchan; %set your 2nd number value to be total electrodes
ref_chan = EEG.nbchan;
c_properties = channel_properties(EEG,eeg_chans,ref_chan);
c_properties = c_properties(1:EEG.nbchan-1,1:3);
eeg_chans_new = 1:EEG.nbchan-1;

% z-score calculations
z_c_properties = c_properties;
z_cor = (c_properties(:,1)-mean(c_properties(:,1)))/std(c_properties(:,1));
z_var = (c_properties(:,2)-mean(c_properties(:,2)))/std(c_properties(:,2));
z_hur = (c_properties(:,3)-mean(c_properties(:,3)))/std(c_properties(:,3));

%create a matrix of z-scores
for i = 1:length(eeg_chans_new)
    z_c_properties(i,1)= z_cor(i); %channel correlations
    z_c_properties(i,2)= z_var(i); %channel variances
    z_c_properties(i,3)= z_hur(i); %channel hurst exponents 
end;

%identify bad channels using z-score thresholds (+/- 3) and save them as
%'badChannels'
badChannels = [];
c = 1;
badchan_arr= {'Channel_Number', 'Z_Correlations', 'Z_Variances', 'Z_Hurst'};

for i = 1:length(eeg_chans_new)
    if ((z_c_properties(i,1) >= 3) | (z_c_properties(i,1) <= -3)) | ((z_c_properties(i,2) >= 3) |    		(z_c_properties(i,2) <= -3)) | ((z_c_properties(i,3) >= 3) | (z_c_properties(i,3) <= -3))
        badChannels(c) = i;
        badChannels(c) = i;
        badchan_arr{c+1,1} = i;
        badchan_arr{c+1,2} = z_c_properties(i,1);
        badchan_arr{c+1,3} = z_c_properties(i,2);
        badchan_arr{c+1,4} = z_c_properties(i,3);
        c=c+1;
    end;    
end;

ds=cell2dataset(badchan_arr); % cell2dataset requires statistics toolbox!
badChannelsFileName = sprintf('%s_badChannels.txt',subjname);
badChannelsFile = fullfile(badChannelsPath,badChannelsFileName );
%export(ds,'file', badChannelsFile, 'delimiter', '\t');

fprintf([num2str(length(badChannels)) ' Bad Channels Identified: ' num2str(badChannels) '.\n']);


%clear index variables and channel metrics from workspace, but keep
%badChannels
clear c;
clear i;
clear z_c_properties;
clear z_cor;
clear z_hur;
clear z_var;