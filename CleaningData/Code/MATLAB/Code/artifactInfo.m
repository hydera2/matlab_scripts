function data = artifactInfo(dataPath, numWindows)

matPath = strcat(dataPath, '/MAT/');
filesInfo = dir(matPath);
filesInfo = struct2cell(filesInfo);
dummy = strfind(filesInfo(1,:), 'RFC01B');

numSubjects = length([dummy{:}]);   % Number of subject folders
numFiles = size(filesInfo, 2);      % Number of all files/folders

% Initialize data
IDs = cell(numSubjects, 1);
percentageData = zeros(numSubjects, 1);
count = 1;  % Index for the number of subjects (won't be the same as the file indices)

for n = 1:numFiles
	if (strncmpi(filesInfo{1,n}, 'RFC01B', 6))
		subjectID = filesInfo{1,n};
		subjectDir = strcat(matPath, subjectID);
		subjectFile = strcat(subjectDir, '/matlab.mat');
		fprintf('\n');
		fprintf('Subject %s:\n', subjectID);
		[~, percentRemoved] = removeArtifacts(subjectFile, numWindows);
		IDs(count) = {subjectID};
		percentageData(count) = percentRemoved;
		fprintf('Done.\n');
		count = count + 1;
	end
end

data = table(percentageData, 'RowNames', IDs);

%sortrows(data);

fprintf('\n');

end