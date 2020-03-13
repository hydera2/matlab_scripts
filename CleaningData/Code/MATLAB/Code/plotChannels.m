function plotChannels(data, markBadChannels)

if size(data, 1) == 65
	numChan = 64;
else
	numChan = size(data, 1);
end

displayBadChannels = false;

if (nargin > 1)
    if (isnumeric(markBadChannels))
        if (markBadChannels == 1)
            [~, channelData] = detectBadChannels(data);
            isChannelBad = channelData(:,end);
            displayBadChannels = true;
        else
            isChannelBad = zeros(numChan, 1);
        end
    else
        error('Invalid value for mark bad channels flag. Must be 1 (true) or 0 (false).');
    end
else
    isChannelBad = zeros(numChan, 1);
end

plotColor = [0 0.4470 0.7410];
badColor = [0.8500 0.3250 0.0980];

numOfsamples_to = length(data);
sampDuration = 6; % minutes
fs_ref = 250;
numRefSamples = sampDuration*60*fs_ref;
numTruncSamples = numOfsamples_to - mod(numOfsamples_to, numRefSamples);

fs = numTruncSamples/(sampDuration*60);
if (fs == 0)
    fs = fs_ref;
end

figure
hold on
for i = 1:numChan
    if (isChannelBad(i))
        plot((1:length(data))/fs, (numChan - i)*5000+data(i,1:length(data)), 'Color', badColor);
    else
        plot((1:length(data))/fs, (numChan - i)*5000+data(i,1:length(data)), 'Color', plotColor);
    end
end
hold off

if (displayBadChannels)
    fprintf('\nBad channels: ');
    badChannelIdx = find(isChannelBad == 1);
    for i = 1:length(badChannelIdx)
        fprintf('%i ', badChannelIdx(i));
    end
    fprintf('\n');
end

end