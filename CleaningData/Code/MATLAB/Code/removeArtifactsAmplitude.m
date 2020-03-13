function [data, timeLength, percentRemoved] = removeArtifactsAmplitude(data, fs, numWindows, stdFactor)

if (nargin < 2)
	error('\t\t\tToo few input arguments. Usage: removeArtifactsAmplitude(data, fs, numWindows, stdFactor)');
end

if (nargin < 3)
	numWindows = 1000;
end

if (nargin < 4)
    stdFactor = 5;
end

%{
sampDuration = 6; % minutes
fs_ref = 250;

numOfsamples_to = numDataPoints - mod(numDataPoints,sampDuration*fs_ref*60); % used to find sampling freq

fs = numOfsamples_to/(sampDuration*60);
if (fs == 0)
	fs = fs_ref;
end
%}

numDataPoints = length(data);
threshold = stdFactor*max(abs(std(data, 1, 2)));	% Threshold value used for window rejection

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
fprintf('\t\t\tRemoving artifacts...\n');
for i = numWindows:-1:1
	% Find if any absolute data values are > threshold
	if any(find(abs(data(:,idxData(i,1):idxData(i,2))) > threshold))
		data(:,idxData(i,1):idxData(i,2)) = [];
		%fprintf('\tFound artifacts: indices %d to %d removed.\n', idxData(i,1), idxData(i,2));
	end
end

if isempty(data)
	error('\t\t\tOperation cancelled: Data set is empty. Try increasing the threshold value.');
	%fprintf('Operation cancelled.\n');
	%return;
end

percentRemoved = 100*(1 - length(data)/numDataPoints);
timeLength = round(length(data)/fs);
timeMinutes = floor(length(data)/fs/60);
timeSeconds = round((length(data)/fs/60 - timeMinutes)*60);

strMinutes = num2str(timeMinutes);

if (timeSeconds < 10)
    strSeconds = strcat('0', num2str(timeSeconds));
else
    strSeconds = num2str(timeSeconds);
end

fprintf('\t\t\t\tRemoved %.2f%% of the data (%s:%s of data remaining).\n', percentRemoved, strMinutes, strSeconds);

fprintf('\t\t\tOperation finished.\n');

end