function PSD_data = getPSD_SingleScalpPlot(data)

%file = 'C:\Users\Andrew\Documents\Work\EEGleWave\EEG Report Generation\trunk\Octave\data\MAT\RFC01B0001\matlab.mat'

%pkg load control
%pkg load signal

%load(file);

sampDuration = 6; % minutes
fs_ref = 250;
numRefSamples = sampDuration*60*fs_ref;
numOfsamples_to = length(data) - mod(length(data),numRefSamples);

fs = numOfsamples_to/(sampDuration*60);
if (fs == 0)
    fs = fs_ref;
end
t_end = numOfsamples_to/fs;
x = linspace(0,t_end,numOfsamples_to);

nRows = size(data,1);

% The 64 electrode configuration contains an extra row, but the 27 channel
% configuration does not
if (nRows == 27)
    nRows = 28;          % add an additional row; we can use this row to store band type
end    

nElec = nRows - 1;
PSD_data = zeros(nElec,1);

for n = 1:nElec
    fcutlow  = 4;
    fcuthigh = 40;
    
    %PSD
    window = 512;
    fftlength = 2^(nextpow2(window))*2;
    [dataN, f_dataN] = pwelch(data(n,:), window, 0, fftlength, fs);

    %% Power spectra calculations
    acceptableError = 0.01;
    lowIdx = find(f_dataN - fcutlow > acceptableError, 1);        % Get index of 4 Hz
    highIdx = find(f_dataN - fcuthigh > acceptableError, 1);      % Get index of 40 Hz
    PSD = 10*log10(dataN);
    PSD_data(n) = mean(PSD(lowIdx:highIdx));
end

end