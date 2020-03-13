function [avg_power, total_power, spec_entropy] = powerSpec(data, freq_range, srate, plothuh)

% This function determines the power of the channel within a certain
% frequency range.  
% INPUT: - data: EEG data formatted with size (num_chans, num_timepoints)
%        - freq_range: structure with fields each a 1 x 2 row vector 
%                      denoting a frequency range to look at (e.g. [2 25])
%        - srate: sampling rate (e.g. 250)
%        - plot: whether the power spectrum is plotted or not ('y' or 'n')
%
% OUTPUT: - avg_power: struct representing average power of all channels within the 
%                      specified frequency ranges, with each field a column
%                      vector 
%         - total_power: struct representing total power of all channels within the 
%                        specified frequency ranges, with each field a column
%                        vector
%         frequency range (NOTE: The wider the range, the higher the power)
%
% NOTE: Even though variables are denoted 'power', the real-term should be
% 'power density' and should be power/frequency.
%
% Written by Arnold Yeung, Feb. 13, 2015
% Editted by Arnold Yeung Feb. 27, 2015 - made compatiable so that won't have to run
%                                         once for every channel
% Editted by Arnold Yeung May 30, 2015 - added entropy calculations

% name of field names of freq_range
freq_names = fieldnames(freq_range);

if plothuh == 'y'
    plot_switch = 'on';
else
    plot_switch = 'off';
end


% convert data to frequency domain
[spectra, freqs] = spectopo(data, length(data), ...
    srate, 'freqrange', [freq_range.(freq_names{1})(1, 1) freq_range.(freq_names{end})(1, 2)], ...
    'plot', plot_switch); 

% filter data based on frequency range
for i = 1:numel(freq_names)
    filt_spectra = spectra(:, find(freqs >= freq_range.(freq_names{i})(1, 1)...
        & freqs <= freq_range.(freq_names{i})(1, 2)));                  % spectral power corresponding to Hz in freq range
    filt_freqs = freqs(find(freqs >= freq_range.(freq_names{i})(1, 1)... 
        & freqs <= freq_range.(freq_names{i})(1, 2)));

    % WHY ARE POWERS NEGATIVE????
    
    
    % calculate entropy
    for j = 1:size(filt_spectra, 1) % for each channel
        
        % normalize features
        
        ent_spectra = filt_spectra(j, :)';
        mn=mean(ent_spectra);
        sd=std(ent_spectra);
        norm_ent_spectra = (ent_spectra-mn)/sd;
        
        spectral_entropy(j, 1) = entropy(norm_ent_spectra);
        
        % spectral_entropy(j, 1) = entropy(filt_spectra(j, :)');
        % spectral_entropy(j, 1) = -1*sum(filt_spectra(j, :)'.*log2((filt_spectra(j, :)')));
    end
    
    
    spec_entropy.(freq_names{i}) = spectral_entropy;
    avg_power.(freq_names{i}) = mean(filt_spectra, 2);
    total_power.(freq_names{i}) = sum(filt_spectra, 2);
end




% fprintf('The average power is : %d\n', avg_power);
% fprintf('The total power is : %d\n', total_power);

