function [badChanIdx, channelData] = detectBadChannels(data)
% data is channels x time_points

truncatePercent = 1;
truncateSize = ceil(max(size(data))*truncatePercent/100);

numRows = min(size(data));

if (numRows == 65)
    numRows = 64;
end

data = data(1:numRows, :);

isChannelBad = zeros(numRows, 1);
badChanIdx = [];

%data = data(:,truncateSize:end-truncateSize);
%fprintf('Operation started.\n\n');

idxData = (1:numRows)';

% Get kurtosis data
kurtosisData = kurtosis(data, 1, 2);
%kurtosisData = kurtosis(data')';
% Get correlation between the channels
corrMatrix = corr(data(:,truncateSize:end-truncateSize)', data(:,truncateSize:end-truncateSize)');
correlationData = mean(corrMatrix)';

% Get variance data
varianceData = var(data(:,truncateSize:end-truncateSize), 1, 2);

% Get Hurst data
HurstData = zeros(numRows, 1);
for i = 1:numRows    
    %fprintf('\tWorking on channel %i... ', i);
    H = wfbmesti(data(i,truncateSize:end-truncateSize));
    HurstData(i) = H(2);
    %fprintf('Done\n');
end

% Trim kurtosis data -- 20% trimming (10% low and 10% high)
tmpkurt = sort(kurtosisData);
minind  = max(round(length(tmpkurt)*0.1),1);
maxind  = round(length(tmpkurt)-round(length(tmpkurt)*0.1));
tmpkurt = tmpkurt(minind:maxind);

% Mark indices based on kurtosis threshold
stdKurt = std(kurtosisData);
meanKurt = mean(kurtosisData);
badChanIdx = find(abs(kurtosisData - meanKurt)/abs(stdKurt) > 5);
kurtosisData = (kurtosisData - meanKurt)/abs(stdKurt);

% Mark indices based on correlation threshold
% No need to check the ones already rejected previously (use setdiff for indexing)
stdCorr = std(correlationData(setdiff(1:end, badChanIdx)));
meanCorr = mean(correlationData(setdiff(1:end, badChanIdx)));
badChanIdx = [badChanIdx; find(abs(correlationData - meanCorr)/abs(stdCorr) > 5)];
badChanIdx = unique(badChanIdx);
correlationData = (correlationData - meanCorr)/abs(stdCorr);

% Mark indices based on variance threshold
% No need to check the ones already rejected previously (use setdiff for indexing)
stdVar = std(varianceData(setdiff(1:end, badChanIdx)));
meanVar = mean(varianceData(setdiff(1:end, badChanIdx)));
badChanIdx = [badChanIdx; find(abs(varianceData - meanVar)/abs(stdVar) > 5)];
badChanIdx = unique(badChanIdx);
varianceData = (varianceData - meanVar)/abs(stdVar);

% Mark indices based on Hurst exponent threshold
% No need to check the ones already rejected previously (use setdiff for indexing)
stdHurst = std(HurstData(setdiff(1:end, badChanIdx)));
meanHurst = mean(HurstData(setdiff(1:end, badChanIdx)));
badChanIdx = [badChanIdx; find(abs(HurstData - meanHurst)/abs(stdHurst) > 5)];
badChanIdx = unique(badChanIdx);
HurstData = (HurstData - meanHurst)/abs(stdHurst);

% Indicate bad channels
isChannelBad(badChanIdx) = 1;

% Populate the dats
channelData = [idxData kurtosisData correlationData varianceData HurstData isChannelBad];

%fprintf('Operation complete.\n');
