function [badChanIdx, channelData] = detectBadSections2(data, idxData)

zScore = 2;

numRows = min(size(data));

if (numRows == 65)
    numRows = 64;
end

data = data(1:numRows, :);

dataSection = data(:, idxData(1):idxData(2));

isChannelBad = zeros(numRows, 1);
badChanIdx = [];

idxData = (1:numRows)';

% Get entire data set variance data
varianceData = var(data, 1, 2);

% Get section variance data
varianceDataSection = var(dataSection, 1, 2);

% Mark indices based on variance threshold
varRatio = varianceDataSection./varianceData;

badChanIdx = [badChanIdx; find(varRatio > zScore)];
badChanIdx = unique(badChanIdx);

% Indicate bad channels
isChannelBad(badChanIdx) = 1;

% Populate the dats
channelData = [idxData isChannelBad];
