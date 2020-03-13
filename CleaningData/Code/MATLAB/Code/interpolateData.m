function data = interpolateData(dataFile, oldMontageFile, newMontageFile)

% Load the data and apply the montages
EEG = pop_importdata('setname', 'EEG', 'data', dataFile, 'dataformat','matlab');
EEG = pop_chanedit(EEG, 'load', oldMontageFile);
outEEG = pop_interp_mont(EEG, newMontageFile, 'manual', 'off');
data = outEEG.data;

% Remove fiducial channels and convert to double
%data = double(data(4:end,:));
data = double(data);

end