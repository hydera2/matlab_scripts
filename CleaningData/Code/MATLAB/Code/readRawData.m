function [files] =  readRawData(saveDir)
% read .RAW files and generate processed intepolated mat files
%
% saveDir: where to find the input files and save the output mat files
%
% author: Saurabh
addpath(genpath('/home/eeglewave/Documents/MATLAB/eeglab13_6_5b/'))
[junk,listfiles] = unix(['find "', saveDir,'" -name *.RAW | grep -v Copy']);

files = strsplit(listfiles,'\n')'

nSubj = length(files)-1;

for num=1:nSubj
[path, name] = fileparts(files{num});
d = strsplit(path,{'/'});save
subjectName = d{end};
disp(['Processing ',subjectName, ' ...']);
newSubFolder = strcat(saveDir, '/MAT/', subjectName);
mkdir(newSubFolder);

A = pop_readegi(files{num});

data = double(A.data);
srate = A.srate;
%% Determine bad channels
fprintf('\t\tDetermining bad channels... ');
savefileBadChan = strcat(newSubFolder, '/bad_channels.mat');
[badChannels, ~] = detectBadChannels(data);
save(savefileBadChan, 'badChannels');
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
fprintf('\t\tInterpolating data... ');
% Load Interpolation Weights Matrix
interpolationWeightsFile='/home/eeglewave/Documents/Report Generation/Data/Interpolation/65Ch210-10Avg.mat';
interpolationWeightsMAT = matfile(interpolationWeightsFile);
vars = whos(interpolationWeightsMAT);
W = interpolationWeightsMAT.(vars(1).name);

if(size(data,1) == 64)
    %add another row
    data = [data; zeros(1,size(data,2))];
end

data = data'*W;     % Apply interpolation weights
data = data';       % Transpose
fprintf('Done.\n');

data = data';   % Transpose
data = data - repmat(mean(data),size(data,1),1);
data = data./repmat(std(data),size(data,1),1);

savefileMAT_interp = strcat(newSubFolder, '/matlab.mat');
%% Save the fully processed data
fprintf('\t\tCreating matlab.mat... ');
save(savefileMAT_interp, 'data');
data = data';   % Transpose back
fprintf('Done.\n');
end
end