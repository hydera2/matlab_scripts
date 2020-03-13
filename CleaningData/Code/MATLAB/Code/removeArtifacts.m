function data = removeArtifacts(data, fs, lengthBlink, zScore, lengthArtifacts)
% A modified FASTER method for artifact removal that includes kurtosis analysis
% data:             input data set
% fs:               sampling frequency for the data set (Hz)
% lengthBlink:      max length of time for a blink artifact (s)
% zScore:           mutiple of std for blink artifact threshold
% lengthArtifacts:  max length of time for other artifacts (s)

% Truncation size (both ends of data)
truncatePercent = 0.5;
truncateSize = ceil(max(size(data))*truncatePercent/100);

% Truncate data to remove end effects of filtering
data = data(:, truncateSize:end-truncateSize);

numRows = min(size(data));
if (numRows == 65)
    numRows = 64;
end

%% Eye blink artifacts
blinkChanIdx = [1 2 3 5];   % Insert channes that measure blinks here
blinkChannels = data(blinkChanIdx,:);
blinkThreshold = zScore*max(abs(std(data, 1, 2)));

numDataPoints = max(size(data));
numSamplesPerWindow = fs*lengthBlink;
numWindows = ceil(numDataPoints/numSamplesPerWindow);

idxData = findIdx(numSamplesPerWindow, numWindows, numDataPoints);

fprintf('\tRemoving blink artifacts...\n');
for i = numWindows:-1:1
	% Find if all absolute data values are > threshold
    if (blinkChannels(:,idxData(i,1):idxData(i,2)) > blinkThreshold)
        fprintf('\t\tFound blink artifacts: indices %d to %d removed.\n', idxData(i,1), idxData(i,2));
        data(:,idxData(i,1):idxData(i,2)) = [];
    end
end
if max(size(data)) == numDataPoints
    fprintf('\t\tNo artifacts found.\n');
end
fprintf('\tDone.\n\n');

%% Other artifacts
numDataPoints = max(size(data));
numSamplesPerWindow = fs*lengthArtifacts;
numWindows = ceil(numDataPoints/numSamplesPerWindow);

idxData = findIdx(numSamplesPerWindow, numWindows, numDataPoints);

fprintf('\tRemoving other artifacts...\n');
for i = numWindows:-1:1
	% Find if any absolute data values are > threshold
    %[badChanIdx, channelData] = detectBadSections(data(:,idxData(i,1):idxData(i,2)));
    [badChanIdx, channelData] = detectBadSections2(data, idxData(i,:));
    
    %{
    if ~isempty(badChanIdx)
        badChanIdx
    end
    %}
    
    if (length(badChanIdx) > floor(0.3*numRows))
        fprintf('\t\tFound artifacts: indices %d to %d removed.\n', idxData(i,1), idxData(i,2));
        data(:,idxData(i,1):idxData(i,2)) = [];
    end
end
if max(size(data)) == numDataPoints
    fprintf('\t\tNo artifacts found.\n');
end
fprintf('\tDone.\n\n');

end