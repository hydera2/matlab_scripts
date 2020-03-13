function dataFiltered = firfiltworker(data, b, nFrames)

if nargin < 2
    error('Not enough input arguments.');
end
if nargin < 3 || isempty(nFrames)
    nFrames = 1000;
end

% Filter's group delay
if mod(length(b), 2) ~= 1
    error('Filter order is not even.');
end
groupDelay = (length(b) - 1) / 2;

dcArray = [1 length(data) + 1];

dataFiltered = data;

for iDc = 1:(length(dcArray) - 1)
    % Pad beginning of data with DC constant and get initial conditions
    ziDataDur = min(groupDelay, dcArray(iDc + 1) - dcArray(iDc));
    [temp, zi] = filter(b, 1, double([data(:, ones(1, groupDelay) * dcArray(iDc)) ...
                              data(:, dcArray(iDc):(dcArray(iDc) + ziDataDur - 1))]), [], 2);
    blockArray = [(dcArray(iDc) + groupDelay):nFrames:(dcArray(iDc + 1) - 1) dcArray(iDc + 1)];
    
    for iBlock = 1:(length(blockArray) - 1)
        % Filter the data
        [dataFiltered(:, (blockArray(iBlock) - groupDelay):(blockArray(iBlock + 1) - groupDelay - 1)), zi] = ...
            filter(b, 1, double(data(:, blockArray(iBlock):(blockArray(iBlock + 1) - 1))), zi, 2);
    end

    % Pad end of data with DC constant
    temp = filter(b, 1, double(data(:, ones(1, groupDelay) * (dcArray(iDc + 1) - 1))), zi, 2);
    dataFiltered(:, (dcArray(iDc + 1) - ziDataDur):(dcArray(iDc + 1) - 1)) = ...
        temp(:, (end - ziDataDur + 1):end);
end

end
