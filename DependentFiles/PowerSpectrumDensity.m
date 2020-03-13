function [files] =  PowerSpectrumDensity(saveDir)

addpath('/Users/amnahyder/Documents/Lab work/CleaningData/Code/MATLAB/Code')
%addpath(genpath('/Users/amnahyder/Documents/Lab work/CleaningData/MATLAB/eeglab13_6_5b'))


for num=1:nSubj
[path, name] = fileparts(files{num});
d = strsplit(path,{'/'});save
subjectName = d{end};
disp(['Processing ',subjectName, ' ...']);
newSubFolder = strcat(saveDir, '/MAT/', subjectName);
justdata = strcat(newSubFolder, '/justdata.mat');
load(justdata)
ALLDATA_1{num}=data;
fprintf('Done.\n');
end
%justdata = strcat(newSubFolder, '/justdata.mat');
%save(justdata , 'data');
subfolder=strcat(saveDir, '/MAT/alldata.mat');
save(subfolder,'ALLDATA_1');



%START POWER SPECTRUM!!!
subjects=length(ALLDATA_1);
p=cell(subjects,1);
avgpowerperband=cell(7,1);
    bands=[2 3; 4 8 ;8 12; 12 20 ; 21 30; 30 50; 4 50]; 
    nchannels=length(ALLDATA_1{1}(:,1))-1; %all subjects have the same number of channels; 
    fs=500;
for k=1:subjects %for each subject in our ALLEEG array    
    data=ALLDATA_1{k};
    nfft= 2^( nextpow2(length(data(1,:))));
    %nfft = 2^( nextpow2(length(channeldata)) );
    p{k}=zeros(nchannels,7); 
    for i=1:nchannels %for each channel 
       channeldata=data(i,:); %temporary variable to make indexing easier 
       [pxx,f]=pwelch(channeldata,512,0,nfft,fs, 'psd');
       for j=1:7 %for each band of interested ( 5 bands)
           freqrange=bands(j,:);
            %returns psd and corresponding freq vector 
           p{k}(i,j)=bandpower(pxx,f,freqrange,'psd'); %returns average power in freq band 
       end
    end
end

for subj=1:subjects
    for freqband=1:7
        avpower(subj,freqband)=mean(p{subj}(:,freqband));
    end
end
boxplot(avpower,'Notch','on','Labels',{'Delta','Theta','Alpha','LowBeta','HighBeta','Gamma','ALL'},'Whisker',1)
title('Control1')



for subj=1:subjects
    for freqband=3:6
        avpower2(subj,freqband-2)=mean(p{subj}(:,freqband));
    end
end
boxplot(avpower2,'Notch','on','Labels',{'Alpha','LowBeta','HighBeta','Gamma'},'Whisker',1)
title('Control2')
subfolder2=strcat(saveDir, '/MAT/PSD.mat');
save(subfolder2,'avpower');

end

%/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp;
%pop_editset(A2,
%'chanlocs','/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp');

% %[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_importdata('dataformat','matlab','nbchan',0,'data','/home/eeglewave/Documents/Report Generation/Data/Maya/MAT/ANDCon 20130312 2003/justdata.mat','srate',250,'pnts',0,'xmin',0,'chanlocs','/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','newdata','gui','off');
% [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
% EEG = eeg_checkset( EEG );
% pop_writeeeg(EEG, '/home/eeglewave/testfile2', 'TYPE','BDF');
