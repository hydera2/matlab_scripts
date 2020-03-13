function getPSDAverage(IDs, divisions, dataPath, numPSDVals)

avgPSDPath = strcat(dataPath, '\MAT\AveragePSDs');
if ~exist(avgPSDPath, 'dir')
    mkdir(avgPSDPath);
end

[numDivisions, uniqueDivisions, matches] = cellhist(divisions);

for i = 1:length(uniqueDivisions)
    IDMatch = find(matches{i} == 1);
    subjectsInDivision = length(IDMatch);
    
    division = uniqueDivisions{i};
    %PSDavgFilename = strcat('PSD_', division, '_avg.mat');
    PSD_sum = zeros(numPSDVals,4);
    PSD_limits = zeros(4,2); % For scalp plot colorbar limits
    count = 0;
    % Get average PSD for each division
    for j = 1:subjectsInDivision
        ID = IDs{IDMatch(j)};
        fullSubjectPath = strcat(dataPath, '\MAT\', ID, '\');
        dataFile = strcat(fullSubjectPath, 'PSD_data.mat');
        if ~exist(dataFile, 'file')
            break;
        end
        load(dataFile);
        
        if (j == 1)
            PSD_limits(1,:) = [min(PSD_data(1:end-1,1)) max(PSD_data(1:end-1,1))];
            PSD_limits(2,:) = [min(PSD_data(1:end-1,2)) max(PSD_data(1:end-1,2))];
            PSD_limits(3,:) = [min(PSD_data(1:end-1,3)) max(PSD_data(1:end-1,3))];
            PSD_limits(4,:) = [min(PSD_data(1:end-1,4)) max(PSD_data(1:end-1,4))];
        end
        
        % Get PSD_limits
        % Minima
        if (min(PSD_data(1:end-1,1)) < PSD_limits(1,1))
            PSD_limits(1,1) = min(PSD_data(1:end-1,1));
        end
        if (min(PSD_data(1:end-1,2)) < PSD_limits(2,1))
            PSD_limits(2,1) = min(PSD_data(1:end-1,2));
        end
        if (min(PSD_data(1:end-1,3)) < PSD_limits(3,1))
            PSD_limits(3,1) = min(PSD_data(1:end-1,3));
        end
        if (min(PSD_data(1:end-1,4)) < PSD_limits(4,1))
            PSD_limits(4,1) = min(PSD_data(1:end-1,4));
        end
        % Maxima
        if (max(PSD_data(1:end-1,1)) > PSD_limits(1,2))
            PSD_limits(1,2) = max(PSD_data(1:end-1,1));
        end
        if (max(PSD_data(1:end-1,2)) > PSD_limits(2,2))
            PSD_limits(2,2) = max(PSD_data(1:end-1,2));
        end
        if (max(PSD_data(1:end-1,3)) > PSD_limits(3,2))
            PSD_limits(3,2) = max(PSD_data(1:end-1,3));
        end
        if (max(PSD_data(1:end-1,4)) > PSD_limits(4,2))
            PSD_limits(4,2) = max(PSD_data(1:end-1,4));
        end
        
        PSD_sum = PSD_sum + PSD_data;
        count = count + 1; % Separate count just in case we break out of the loop; might be different from subjectsInDivision
    end
    PSD_avg = PSD_sum./count;
    
    % Save PSD_limit files for each subject?
    %{
    for j = 1:subjectsInDivision
        ID = IDs{idxMatch(j)};
        fullSubjectPath = strcat(dataPath, '\MAT\', ID, '\');
        saveFile = strcat(fullSubjectPath, PSD_limits_filename);
        if ~exist(fullSubjectPath, 'dir')
            break;
        end
        save(saveFile, 'PSD_limits');
    end
    %}
    
    % Save file for each division    
    fullDivPath = strcat(avgPSDPath, '\', division);
    if ~exist(fullDivPath, 'dir')
        mkdir(fullDivPath);
    end
    
    if (count ~= 0)
        saveFile1 = strcat(fullDivPath, '\PSD_limits.mat');
        saveFile2 = strcat(fullDivPath, '\PSD_avg.mat');
        save(saveFile1, 'PSD_limits');
        save(saveFile2, 'PSD_avg');
    end
end

end