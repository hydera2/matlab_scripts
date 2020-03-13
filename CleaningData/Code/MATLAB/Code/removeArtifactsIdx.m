function [data, percentRemoved] = removeArtifactsIdx(data, idxData)

if (nargin ~= 2)
	error('Too few input arguments. Usage: cleanedData = removeArtifacts(dataFile, numWindows)');
end

numDataPoints = length(data);
numWindows = size(idxData, 1);

% Remove artifacts
% Start from the end so we don't have to deal with data set length changing after removal
fprintf('Removing artifacts...\n');
for i = numWindows:-1:1
	data(:,idxData(i,1):idxData(i,2)) = [];
end

if isempty(data)
	error('Data set is empty. Try increasing the threshold value.');
	fprintf('Operation cancelled.\n');
	return;
end

percentRemoved = 100*(1 - length(data)/numDataPoints);

fprintf('Removed %.2f%% of the data.\n', percentRemoved);

fprintf('Operation finished.\n');

end