function idxData = findIdx(numSamplesPerWindow, numWindows, numDataPoints)

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

end