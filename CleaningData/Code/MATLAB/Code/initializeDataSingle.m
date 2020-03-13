function initializeDataSingle(mffFile, subjectName, subjectAge, interpolationWeightsFile)

mff_setup

% Load Interpolation Weights Matrix
interpolationWeightsMAT = matfile(interpolationWeightsFile);
vars = whos(interpolationWeightsMAT);
W = interpolationWeightsMAT.(vars(1).name);

saveDir = fileparts(mffFile);

fprintf('\t\tReading data... ');
hdr = read_mff_header(mffFile);
chan = []; % all channels
numOfsamples_from = 1;
numOfsamples_to = hdr.nSamples;
data = read_mff_data(mffFile,'sample', numOfsamples_from, numOfsamples_to, chan, hdr );
%originalData = data;

newSubFolder = strcat(saveDir, '/MAT/', subjectName);

if ~exist(newSubFolder, 'dir')
    mkdir(newSubFolder);
end

savefileMATRaw = strcat(newSubFolder, '/matlab_raw.mat');
savefileMATFiltered = strcat(newSubFolder, '/matlab_filtered.mat');
savefileMATArtifactsRemoved = strcat(newSubFolder, '/matlab_artifacts_removed.mat');

% Save raw data to .mat file
%save(savefileMATRaw, 'data');
fprintf('Done.\n');

%% Determine bad channels
fprintf('\t\tDetermining bad channels... ');
savefileBadChan = strcat(newSubFolder, '/bad_channels.mat');
[badChannels, ~] = detectBadChannels(data);
save(savefileBadChan, 'badChannels');
fprintf('Done.\n');

%% Filter the data
% Determine sampling rate
fs_ref = 250;       % Reference sampling rate
fs = hdr.Fs;

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
savefileClass = strcat(newSubFolder, '/', classification, '.txt');
fclose(fopen(savefileClass, 'w'));
fprintf('\t\tDone.\n');

% Save processed data
%save(savefileMATArtifactsRemoved, 'data');

%% Interpolate using the weights matrix
fprintf('\t\tInterpolating data... ');
data = data'*W;     % Apply interpolation weights
data = data';       % Transpose
fprintf('Done.\n');

%% Truncate data
truncatePercent = 5;
truncateSize = ceil(max(size(data))*truncatePercent/100);
data = data(:, truncateSize:end-truncateSize);
%truncateStart = 10000;
%truncateEnd = 90000;
%data = data(:, truncateStart:truncateEnd);

%% Normalize data
data = data';   % Transpose
data = data - repmat(mean(data),size(data,1),1);
data = data./repmat(std(data),size(data,1),1);

savefileMAT_interp = strcat(newSubFolder, '/matlab.mat');
%savefileMAT_PSD = strcat(newSubFolder, '/PSD_data.mat');
savefileMAT_PSD_Single = strcat(newSubFolder, '/PSD_data_single_scalp_plot.mat');
savefileTXT = strcat(newSubFolder, '/', num2str(subjectAge), '.txt');

%% Save the fully processed data
fprintf('\t\tCreating matlab.mat... ');
save(savefileMAT_interp, 'data');
data = data';   % Transpose back
fprintf('Done.\n');

%% Save a text file of the subject's age
fprintf('\t\tCreating %i.txt... ', subjectAge);
fclose(fopen(savefileTXT, 'w'));
fprintf('Done.\n');

%% Calculate PSDs
fprintf('\t\tCreating PSD_data.mat... ');
PSD_data = getPSD_SingleScalpPlot(data);

%% Save the PSD data
save(savefileMAT_PSD_Single, 'PSD_data');
fprintf('Done.\n');

fprintf('\tSuccessfully created files for subject %s.\n', subjectName);

end