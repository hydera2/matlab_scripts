function [data, classification] = removeArtifacts(inData, fs, numWindows, stdFactor, timeThreshold)
% removeArtifacts(inData, numWindows, timeThreshold)
%   
%   Removes artifacts based on a multiple of the dataset's standard
%   deviation (specified by stdFactor) until either no more data can be removed
%   or timeThreshold is reached.
%
%   inData - data to be processed
%   fs - sampling frequency of the data
%   numWindows - number of windows into which to divide the data for processing
%   stdFactor - standard deviation multiple used to determine the threshold for artifact removal
%   timeThreshold - minimum time length for the processed data (in seconds)
%
%   e.g. data = removeArtifacts(inData, 250, 1000, 5, 5*60)
%       Remove artifacts by splitting inData up into 1000 equally sized windows
%       until either no more data is removed or the time length of the data
%       reaches 5 minutes

if (nargin < 2)
    error('Too few input arguments. Usage: removeArtifacts(inData, fs, numWindows, stdFactor, timeThreshold)');
end

if (nargin < 3)
	numWindows = 1000;
end

if (nargin < 4)
    stdFactor = 5;
end

if (nargin < 5)
    timeThreshold = 5*60;
end

classification = 'clean';

[data, timeLength, percentRemoved] = removeArtifactsAmplitude(inData, fs, numWindows, stdFactor);

while ((percentRemoved > 0) && (timeLength > timeThreshold))
    [data, timeLength, percentRemoved] = removeArtifactsAmplitude(data, fs, numWindows, stdFactor);   
end

if (timeLength < timeThreshold)
    classification = 'noisy';
end

end