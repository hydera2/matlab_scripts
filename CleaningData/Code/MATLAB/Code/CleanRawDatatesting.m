
% read .RAW files and generate processed intepolated mat files
%
% saveDir: where to find the input files and save the output mat files
%
% author: Amna modified Saurabhs algorithm
addpath('/Users/amnahyder/Documents/Lab work/CleaningData/Code/MATLAB/Code')
addpath(genpath('/Users/amnahyder/Documents/Lab work/CleaningData/MATLAB/eeglab13_6_5b'))
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

savefileMAT_interp = strcat(newSubFolder, '/matlab.mat');
%% Save the fully processed data
fprintf('\t\tCreating matlab.mat... ');
justdata = strcat(newSubFolder, '/justdata.mat');
save(justdata , 'data');
BESADATA = strcat(newSubFolder, '/besadata');
%data = data';   % Transpose back
%A2=pop_importdata('data',data');
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',justdata,'srate',250,'pnts',0,'xmin',0,'chanlocs','/Users/amnahyder/Documents/Lab work/CleaningData/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','newdata','gui','off');
% [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
%pop_writeeeg(EEG, '/home/eeglewave/testfile2', 'TYPE','BDF');
savedata.data=data';
pop_writeeeg(savedata, BESADATA, 'TYPE','BDF');
fprintf('Done.\n');
end



% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',justdata,'srate',256,'pnts',0,'xmin',0,'chanlocs','/Users/amnahyder/Documents/Lab work/CleaningData/MATLAB/eeglab13_6_5b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','newdata','gui','off');
% [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);


%pop_writeeeg(EEG, '/home/eeglewave/testfile2', 'TYPE','BDF');
% pop_writeeeg(savedata, BESADATA, 'TYPE','BDF');
% fprintf('Done.\n');
% %/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp;
%pop_editset(A2,
%'chanlocs','/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp');

% %[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_importdata('dataformat','matlab','nbchan',0,'data','/home/eeglewave/Documents/Report Generation/Data/Maya/MAT/ANDCon 20130312 2003/justdata.mat','srate',250,'pnts',0,'xmin',0,'chanlocs','/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/sample_locs/GSN65v2_0.sfp');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','newdata','gui','off');
% [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
% EEG = eeg_checkset( EEG );
% pop_writeeeg(EEG, '/home/eeglewave/testfile2', 'TYPE','BDF');
