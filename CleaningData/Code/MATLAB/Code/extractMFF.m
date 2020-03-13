function extractMFF(dataPath)
% dataPath: parent directory of all of the .mff files

D = dir([dataPath, '/*.mff']);
%numFiles = length(D(not([D.isdir])));
numFiles = length(D); % .mff files are treated as directories

fprintf('Extracting .mff data... \n\n');
mff_setup
for n = 1:numFiles
    filepath = strcat(dataPath, '/', D(n).name);
    hdr = read_mff_header(filepath);
    str = strsplit(D(n).name, '_');
    subjID = str{1};
    
    fprintf('\tProcessing file %i of %i (subject ID: %s)...\n', n, numFiles, subjID);
    chan = []; % all channels
    numOfsamples_from = 1;
    numOfsamples_to = hdr.nSamples;
    fprintf('\t\tReading data... ');
    data = read_mff_data(filepath,'sample', numOfsamples_from,numOfsamples_to, [], hdr );
    fprintf('Done.\n');
    %[pathstr,name,ext] = fileparts(filepath);
    newSubFolder = strcat(dataPath, '/MAT/', subjID);
    if ~exist(newSubFolder, 'dir')
        mkdir(newSubFolder);
    end
    
    fprintf('\t\tSaving raw data... ');
    savefileRaw = strcat(newSubFolder, '/matlab_raw.mat');
    save(savefileRaw, 'data');
    fprintf('Done.\n');
    
    % Determine sampling rate
    fs_ref = 250;       % Reference sampling rate
    fs = hdr.Fs;

    fprintf('\t\tFiltering data... ');
    % Resample data at 250 Hz
    % Make sure to leave it as a matrix of column vectors
    data = resample(data', fs_ref, fs);    % fs_ref/fs * fs = fs_ref = 250 Hz is the new sampling rate;

    fs = fs_ref;

    % Cutoff and notch frequencies (Hz)
    lowCutoff = 4;      % Low cutoff for high-pass
    highCutoff = 40;    % High cutoff for low-pass
    notchF = 60;        % Notch freq
    band = 2;           % Bandwidth for notch

    % Apply filters            
    data = filterbandpass(data, lowCutoff, highCutoff, fs);
    data = filternotch(data, notchF, band, fs);
    fprintf('Done.\n');

    % Transpose the data set
    data = data';
    
    fprintf('\t\tSaving filtered data... ');
    savefileFilt = strcat(newSubFolder, '/matlab_filt.mat');
    save(savefileFilt, 'data');
    fprintf('Done.\n');
    
    fprintf('\tFinished processing file.\n\n');
    
    %{
    if ~exist(savefile, 'file')
        save(savefile, 'data');
        display('Data saved to .mat file in the "data" subfolder.');
    else
        prompt = 'File already exists. Would you like to overwrite? (y/n)\n';
        choice = input(prompt, 's');
        if strcmpi(choice, 'y')
            save(savefile, 'data');
            display('Data saved to .mat file in the "data" subfolder.');
        else
            display('File not saved.');
        end
    end
    %}
end
fprintf('Done.\n');

end