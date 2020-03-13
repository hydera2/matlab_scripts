function markedData = markSelectedRegions(data, selectedRegions, scale, shiftVal, xData, fs)

    %load(filename);
    
    if (nargin < 3)
        scale = 1;
    end
    
    numIdx = 1;
    numRows = size(data, 1);
    numCols = size(data, 2);
    if numRows == 65
        numRows = 64;
    end
    numCols = size(data, 2);
    numRegions = length(selectedRegions);
  
    if (xData(end) == numCols)
        fs = 1;
    end
    
    %xData = linspace(1, numCols, numCols);

    % Extract data from regions, clean up deleted regions
    rectYLimits = fs*[-1E8 1E9];
    i = 1;
    while (i <= numRegions)
        if (isvalid(selectedRegions(i)))
            arr = fs*selectedRegions(i).getPosition;
            startIdx = floor(arr(1));
            endIdx = startIdx + ceil(arr(3));
            
            if (startIdx > length(data))
                startIdx = length(data);
            elseif (startIdx < 1)
                startIdx = 1;
            end
            
            if (endIdx > length(data))
                endIdx = length(data);
            elseif (endIdx < 1)
                endIdx = 1;
            end
            
            setPosition(selectedRegions(i), [startIdx rectYLimits(1) endIdx-startIdx rectYLimits(2)]/fs);
            
            if (startIdx ~= endIdx)
                idxData(numIdx,:) = [startIdx endIdx];
                numIdx = numIdx + 1;
            end
        else
            selectedRegions(i) = [];
            i = i - 1;
        end
        
        numRegions = length(selectedRegions);
        i = i + 1;
    end
    
    % Plot colors
    plotColor = [0 0.4470 0.7410];
    markedColor = [0.8500 0.3250 0.0980];
              
    % Fix overlapping regions
    for r = 1:(size(idxData, 1) - 1)
        curStartIdx = idxData(r,1);
        curEndIdx = idxData(r,2);

        nextStartIdx = idxData(r+1,1);
        nextEndIdx = idxData(r+1,2);

        curIdx = r;
        nextIdx = r+1;
        
        if (curEndIdx > nextStartIdx)
            if (curEndIdx < nextEndIdx)
                idxData(r,2) = nextEndIdx;
            end
            idxData(r+1,:) = idxData(r,:);
            newEndIdx = idxData(r,2)-curStartIdx;
            
            if (curStartIdx < 0)
                curStartIdx = 1;
            end
            
            if (newEndIdx > length(data))
                newEndIdx = length(data);
            end
            
            setPosition(selectedRegions(r+1), [curStartIdx rectYLimits(1) newEndIdx rectYLimits(2)]/fs);
            selectedRegions(r).delete;
            %selectedRegions(r) = [];
        end
    end
    
    % Clean up deleted regions
    i = 1;
    numRegions = length(selectedRegions);
    while (i <= numRegions)
        if ~(isvalid(selectedRegions(i)))
            selectedRegions(i) = [];
            i = i - 1;
        end
        
        numRegions = length(selectedRegions);
        i = i + 1;
    end
    
    % Sort indices ascending
    idxData = sortrows(idxData, 1);
    
    % Remove duplicate rows and keep the last occurrence
    [~,b] = unique(idxData(:,1),'last');
    idxData = idxData(b,:);
    
    % Save marked indices to the workspace
    assignin('base','idxData_visData',idxData);
    
    % Re-plot data with marked regions
    %figure
    figure(1);
    hold on;
    hAllAxes = findobj(gcf,'type','axes'); % Find all axes
    numAxes = length(hAllAxes);
    
    for i = 1:numAxes
        axes(hAllAxes(i));  % Switch current axis
        for j = 1:numRows
            for k = 1:(size(idxData, 1))
                if (k == 1)
                    prevStartIdx = idxData(k,1);
                    prevEndIdx = idxData(k,2);
                else
                    prevStartIdx = idxData(k-1,1);
                    prevEndIdx = idxData(k-1,2);

                    nextStartIdx = idxData(k,1);
                    nextEndIdx = idxData(k,2);
                end

                if (k == 1)
                    if (prevStartIdx == 1)
                        plot(xData(prevStartIdx:prevEndIdx), (numRows - j)*shiftVal + scale.*data(j,prevStartIdx:prevEndIdx), 'Color', markedColor);
                    else  
                        %plot(xData(1:prevStartIdx), (numRows - j)*shiftVal + scale.*data(j,1:prevStartIdx), 'Color', plotColor);
                        plot(xData(prevStartIdx:prevEndIdx), (numRows - j)*shiftVal + scale.*data(j,prevStartIdx:prevEndIdx), 'Color', markedColor);
                    end
                elseif (k == (size(idxData, 1)))
                    if (nextEndIdx == numCols)
                        %plot(xData(prevEndIdx:nextStartIdx), (numRows - j)*shiftVal + scale.*data(j,prevEndIdx:nextStartIdx), 'Color', plotColor);
                        plot(xData(nextStartIdx:nextEndIdx), (numRows - j)*shiftVal + scale.*data(j,nextStartIdx:nextEndIdx), 'Color', markedColor);
                    else
                        %plot(xData(nextEndIdx:numCols), (numRows - j)*shiftVal + scale.*data(j,nextEndIdx:numCols), 'Color', plotColor);
                        plot(xData(nextStartIdx:nextEndIdx), (numRows - j)*shiftVal + scale.*data(j,nextStartIdx:nextEndIdx), 'Color', markedColor);
                    end
                else
                    %plot(xData(prevEndIdx:nextStartIdx), (numRows - j)*shiftVal + scale.*data(j,prevEndIdx:nextStartIdx), 'Color', plotColor);
                    plot(xData(nextStartIdx:nextEndIdx), (numRows - j)*shiftVal + scale.*data(j,nextStartIdx:nextEndIdx), 'Color', markedColor);
                end
            end
        end
    end
    
    %{
    for j = 1:size(idxData, 1)
        %data(:,idxData(j,1):idxData(j,2)) = ;
    end
    %}
    
    assignin('base','selectedRegions_visData', selectedRegions)
    markedData = data;
    
end