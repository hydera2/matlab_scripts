function powerSpecFeats = buildPowerSpecFeats_spectrumonly(EEG)
% This script builds a feature matrix for all Power Spectral Analysis
% related functions.  
%
% How to use this script:
%           powerSpecFeats = [];        % do not repeat this line
%           Load 1st subject's data into EEGLab
%           buildPowerSpecFeats;
%           Load 2nd subject's data into EEGLab
%           buildPowerSpecFeats;
%           Repeat, etc.
%
% Custom Functions Used:   - powerSpec.m
%                          - msCoher.m
%                          - phaseLag.m
%
% Written by Arnold Yeung, Feb 21 2015

format short

% frequency bands
freq_range.delta_freq = [0.5 4];
freq_range.theta_freq = [4 7];
freq_range.alpha_freq = [7 14];
freq_range.beta_freq = [15 30];
freq_range.gamma_freq = [30 40];

freq_names = fieldnames(freq_range);

% save EEG data as matrix
dataset = EEG.data;
numChans = EEG.nbchan;
srate = EEG.srate;

newPowerSpecFeats = [];

fprintf('New row created...\n');

% find average power of each frequency band
% delta freq
cols = 0;  % indicate the feature that is to be entered into matrix
power = powerSpec(dataset, freq_range, srate, 'n');

for i = 1:numel(freq_names)
    
    addlength = length(power.(freq_names{i}));      % number of features to add
    
    newPowerSpecFeats(1, cols+1:cols+addlength) = (power.(freq_names{i}))';   % copy avg_power into matrix
    cols = cols + addlength;
end

fprintf('Average power computed for all electrodes and frequency bands...\n');


powerSpecFeats = newPowerSpecFeats;

fprintf('Whew...finally done.\n');

%}
end