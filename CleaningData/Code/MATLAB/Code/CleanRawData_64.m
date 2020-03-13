function [files] =  CleanRawData(saveDir)
% read .RAW files and generate processed intepolated mat files
%
% saveDir: where to find the input files and save the output mat files
%
% author: Amna modified Saurabhs algorithm
addpath('/Volumes/Seagate Backup Plus Drive/Amna Lab Scripts/Matlab Scripts/CleaningData/Code/MATLAB/Code')
addpath(genpath('/Volumes/Seagate Backup Plus Drive/Amna Lab Scripts/Matlab Scripts/CleaningData/Code/MATLAB/eeglab13_6_5b'))
%addpath(genpath('/Users/egi/Documents/Amna Lab Scripts/Matlab Scripts/CleaningData/MATLAB/Biosig3.3.0'))
saveDir = char(saveDir)
[~,listfiles] = unix(['find "', saveDir,'" -name *.RAW | grep -v Copy']);

files = strsplit(listfiles,'\n')'

nSubj = length(files)-1;

for num=1:nSubj
[path, name] = fileparts(files{num});
d = strsplit(path,{'/'});save
subjectName = d{end};
disp(['Processing ',subjectName, ' ...']);
newSubFolder = strcat(saveDir, '/MAT/', subjectName);
mkdir(newSubFolder);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
A = pop_readegi(files{num},[],[],'auto');
savedata=A;
data = double(A.data);
srate = A.srate;
%% Determine bad channels
fprintf('\t\tDetermining bad channels... ');
savefileBadChan = strcat(newSubFolder, '/bad_channels.mat');
[badChannels, ~] = detectBadChannels(data);
save(savefileBadChan, 'badChannels');
savefileAlldata= strcat(newSubFolder, '/all_data.mat');
save(savefileAlldata, 'savedata');
fprintf('Done.\n');

%% Filter the data
% Determine sampling rate
fs_ref = 250;       % Reference sampling rate
fs = srate;

fprintf('\t\tFiltering data... ');
% Resample data at 250 Hz
% Make sure to leave it as a matrix of column vectors
data = resample(data', fs_ref, fs);    % fs_ref/fs * fs = fs_ref = 250 Hz is the new sampling rate;

fs = fs_ref;

% Cutoff and notch frequencies (Hz)
lowCutoff = 4;      % Low cutoff for high-pass
highCutoff = 40;    % High cutoff for low-pass
notchF = 60;        % Notch freq
band = 2;           % Bandwidth for notch

% Apply filters
data = filterbandpass(data, lowCutoff, highCutoff, fs);
data = filternotch(data, notchF, band, fs);
fprintf('Done.\n');

% Transpose the data set
data = data';

% Save filtered data
%save(savefileMATFiltered, 'data');

%% Remove artifacts
fprintf('\t\tRemoving artifacts...\n');
numWindows = 500;
stdFactor = 6;
timeThreshold = 5*60;
[data, classification] = removeArtifactsRecursive(data, fs, numWindows, stdFactor, timeThreshold);
if (strcmp(classification, 'noisy'))
    fprintf(2,'\t\tWarning: the raw EEG data appeared to be very noisy, and much of it was removed. This may give unreliable results.\n');
end
fprintf('\t\tDone.\n');

% Save processed data
%save(savefileMATArtifactsRemoved, 'data');

%% Interpolate using the weights matrix
fprintf('\t\tSavingData... ');
% Load Interpolation Weights Matrix
% interpolationWeightsFile='/home/eeglewave/Documents/Report Generation/Data/Interpolation/65Ch210-10Avg.mat';
% interpolationWeightsMAT = matfile(interpolationWeightsFile);
% vars = whos(interpolationWeightsMAT);
% W = interpolationWeightsMAT.(vars(1).name);

 if(size(data,1) == 64)
     %add another row
     data = [data; zeros(1,size(data,2))];
 end
% 
% data = data'*W;     % Apply interpolation weights
% data = data';       % Transpose
fprintf('Done.\n');

data = data';   % Transpose
data = data - repmat(mean(data),size(data,1),1);
data = data./repmat(std(data),size(data,1),1);

savefileMAT_interp = strcat(newSubFolder, '/matlab.mat');
%% Save the fully processed data
fprintf('\t\tCreating matlab.mat... ');
save(savefileMAT_interp, 'data');
new=savedata;
new.data=data;
savefile2 = strcat(newSubFolder, '/matlab2.mat');
save(savefile2 , 'new');
justdata = strcat(newSubFolder, '/justdata.mat');
save(justdata , 'data');
BESADATA = strcat(newSubFolder, '/besadata');
%data = data';   % Transpose back
%A2=pop_importdata('data',data');
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',justdata,'srate',250,'pnts',0,'xmin',0,'chanlocs','/Users/amnahyder/Documents/MATLAB/eeglab14_1_1b/sample_locs');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','newdata','gui','off');
% [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
%pop_writeeeg(EEG, '/home/eeglewave/testfile2', 'TYPE','BDF');
%pop_writeeeg(EEG, BESADATA, 'TYPE','BDF');
fprintf('Done.\n');
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
