function PSD_data = getPSD_ArtifactRemoval(file, numWindows)

page_screen_output(0);
page_output_immediately(1);

if (nargin != 2)
	error('Too few input arguments. Usage: PSD = getPSD_ArtifactRemoval(file, numWindows)');
end

% NOTE: requires Octave 'signal' package (which requires the 'control' package)
pkg load signal

load(file); % Contains 'data' variable
workingData = data;

sampDuration = 6; % minutes
fs_ref = 250;

numDataPoints = length(data); % possibly change so that we can cut off garbage data near beginning and end of sampling
numOfsamples_to = numDataPoints - mod(numDataPoints,sampDuration*fs_ref*60); % used to find sampling freq

fs = numOfsamples_to/(sampDuration*60);
t_end = numOfsamples_to/fs;

if (fs == 0)
	fs = fs_ref;
end

numRows = size(data,1);
if (numRows == 65)
	nElec = numRows - 1;
	PSD_data = zeros(numRows,4); % includes E65 zero row; we can use this row to store band type
else
	nElec = numRows;
	PSD_data = zeros(numRows + 1,4);
end

% Filter data
order    = 2;
fcutlow  = 0.1;
fcuthigh = 40;
[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2));
for n = 1:nElec
	workingData(n,:)   = filtfilt(b,a,data(n,:));
end

threshold = 100;				% Threshold value used for window rejection (change based on subjects?)

%numWindows = 10;				% Number of windows to divide the data set into
windowSize = 1/numWindows;		% Size of windows used to divide the data set, expressed as a fraction of the data set (0.1 to 1);
numSamplesPerWindow = ceil(windowSize*numDataPoints);
idxData = ones(numWindows, 2);	% Store window indices

% Find window indices
for i = 1:numWindows
	startIdx = (i - 1)*numSamplesPerWindow + 1;
	endIdx = i*numSamplesPerWindow;
	
	if (endIdx > numDataPoints)
		endIdx = numDataPoints;
	end
	
	idxData(i,:) = [startIdx endIdx];
end

% Remove artifacts
% Start from the end so we don't have to deal with data set length changing after removal
fprintf('Removing artifacts...\n');
for i = numWindows:-1:1
	% Find if any absolute data values are > threshold
	if any(find(abs(workingData(:,idxData(i,1):idxData(i,2))) > threshold))
		workingData(:,idxData(i,1):idxData(i,2)) = [];
		data(:,idxData(i,1):idxData(i,2)) = [];
		fprintf('\tFound artifacts: indices %d to %d removed.\n', idxData(i,1), idxData(i,2));
	end
end

if isempty(workingData)
	error('Data set is empty. Try increasing the threshold value.');
	fprintf('Operation cancelled.\n');
	return;
end

fprintf('Calculating PSD values... ');
for n = 1:nElec
  % Filter data to get band types

  %delta (f < 4 Hz)
  fdeltalow  = 0.1;
  fdeltahigh = 4;
  [b,a]    = butter(order,[fdeltalow,fdeltahigh]/(fs/2));
  delta        = filtfilt(b,a,workingData(n,:));

  %theta (4 =< f < 8 Hz)
  fthetalow  = 4;
  fthetahigh = 8;
  [b,a]    = butter(order,[fthetalow,fthetahigh]/(fs/2));
  theta        = filtfilt(b,a,workingData(n,:));

  %alpha (8 =< f < 14 Hz)
  falphalow  = 8;
  falphahigh = 14;
  [b,a]    = butter(order,[falphalow,falphahigh]/(fs/2));
  alpha        = filtfilt(b,a,workingData(n,:));

  %beta (f >= 14)
  fbetalow  = 14;
  fbetahigh = 40;
  [b,a]    = butter(order,[fbetalow,fbetahigh]/(fs/2));
  beta        = filtfilt(b,a,workingData(n,:));

  %PSD estimation (used in calculation)
  window = 512;
  fftlength = 2^(nextpow2(window))*2;
  [psd_delta, f_delta] = pwelch(delta, window, 0, fftlength, fs);
  [psd_theta, f_theta] = pwelch(theta, window, 0, fftlength, fs);
  [psd_alpha, f_alpha] = pwelch(alpha, window, 0, fftlength, fs);
  [psd_beta, f_beta] = pwelch(beta, window, 0, fftlength, fs);

  %% PSD calculations
  acceptableError = 0.01;
  deltaLowIdx = find(f_delta - fdeltalow > acceptableError, 1);        % Get index of 0.1 Hz
  deltaHighIdx = find(f_delta - fdeltahigh > acceptableError, 1);      % Get index of 4 Hz
  PSD_delta = 10*log10(psd_delta);
  PSD_delta = mean(PSD_delta(deltaLowIdx:deltaHighIdx));               % Sum over band frequency range?
  %deltaHighIdx = find(f_delta - 40 > acceptableError, 1);
  %PSD_delta = mean(PSD_delta(1:deltaHighIdx));                         % Sum over 0.1-40Hz frequency range?

  thetaLowIdx = find(f_theta - fthetalow > acceptableError, 1);        % Get index of 4 Hz
  thetaHighIdx = find(f_theta - fthetahigh > acceptableError, 1);      % Get index of 8 Hz
  PSD_theta = 10*log10(psd_theta);
  PSD_theta = mean(PSD_theta(thetaLowIdx:thetaHighIdx));               % Sum over band frequency range?
  %thetaHighIdx = find(f_theta - 40 > acceptableError, 1);
  %PSD_theta = mean(PSD_theta(1:thetaHighIdx));                         % Sum over 0.1-40Hz frequency range?

  alphaLowIdx = find(f_alpha - falphalow > acceptableError, 1);        % Get index of 8 Hz
  alphaHighIdx = find(f_alpha - falphahigh > acceptableError, 1);      % Get index of 14 Hz
  PSD_alpha = 10*log10(psd_alpha);
  PSD_alpha = mean(PSD_alpha(alphaLowIdx:alphaHighIdx));               % Sum over band frequency range?
  %alphaHighIdx = find(f_alpha - 40 > acceptableError, 1);
  %PSD_alpha = mean(PSD_alpha(1:alphaHighIdx));                        % Sum over 0.1-40Hz frequency range?

  betaLowIdx = find(f_beta - fbetalow > acceptableError, 1);        % Get index of 14 Hz
  betaHighIdx = find(f_beta - fbetahigh > acceptableError, 1);      % Get index of 40 Hz
  PSD_beta = 10*log10(psd_beta);
  PSD_beta = mean(PSD_beta(betaLowIdx:betaHighIdx));                % Sum over band frequency range?
  %betaHighIdx = find(f_beta - 40 > acceptableError, 1);
  %PSD_beta = mean(PSD_beta(1:betaHighIdx));                         % Sum over 0.1-40Hz frequency range?
  
  PSD_data(n,:) = [PSD_delta, PSD_theta, PSD_alpha, PSD_beta];
end
fprintf('Done.\n');

%% Store band type
% 0 = delta
% 1 = theta
% 2 = alpha
% 3 = beta

PSD_data(numRows,:) = [0, 1, 2, 3];

parentDir = fileparts(file);
newFile = strcat(parentDir,'\matlab_cleaned.mat');
newFileFilt = strcat(parentDir,'\matlab_filt_cleaned.mat');
fprintf('Saving files...\n');
fprintf('\t%s... ', newFile);
save('-mat-binary', newFile, 'data');
fprintf('Done.\n');
fprintf('\t%s... ', newFileFilt);
save('-mat-binary', newFileFilt, 'workingData');
fprintf('Done.\n');

fprintf('Operation finished.\n');

end