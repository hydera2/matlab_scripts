function PSD_data = getPSD_MATLAB(data)

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
PSD_data = zeros(nRows,4);

for n = 1:nElec

    order    = 2;
    fcutlow  = 0.1;
    fcuthigh = 40;
    [b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');
    eeg_filt        = filtfilt(b,a,data(n,:));

    %delta (f < 4 Hz)
    fdeltalow  = 0.1;
    fdeltahigh = 4;
    [b,a]    = butter(order,[fdeltalow,fdeltahigh]/(fs/2), 'bandpass');
    delta        = filtfilt(b,a,eeg_filt);

    %theta (4 =< f < 8 Hz)
    fthetalow  = 4;
    fthetahigh = 8;
    [b,a]    = butter(order,[fthetalow,fthetahigh]/(fs/2), 'bandpass');
    theta        = filtfilt(b,a,eeg_filt);

    %alpha (8 =< f < 14 Hz)
    falphalow  = 8;
    falphahigh = 14;
    [b,a]    = butter(order,[falphalow,falphahigh]/(fs/2), 'bandpass');
    alpha        = filtfilt(b,a,eeg_filt);

    %beta (f >= 14)
    fbetalow  = 14;
    fbetahigh = 40;
    [b,a]    = butter(order,[fbetalow,fbetahigh]/(fs/2), 'bandpass');
    beta        = filtfilt(b,a,eeg_filt);

    %{
    fcutlow  = 0.1;
    fcuthigh = 40;
    nyq = fs*0.5;
    filtorder = 3*fix(fs/fcutlow);
    filtorder = max(15, filtorder);
    f = [0 (0.85)*fcutlow/nyq fcutlow/nyq fcuthigh/nyq (1.15)*fcuthigh/nyq 1];
    m = [0 0 1 1 0 0];
    filtwts = firls(filtorder,f,m); % get FIR filter coefficients
    eeg_filt = filtfilt(filtwts,1,eeg_data);

    fdeltalow  = 0.1;
    fdeltahigh = 4;
    nyq = fs*0.5;
    filtorder = 3*fix(fs/fdeltalow);
    filtorder = max(15, filtorder);
    f = [0 (0.85)*fdeltalow/nyq fdeltalow/nyq fdeltahigh/nyq (1.15)*fdeltahigh/nyq 1];
    m = [0 0 1 1 0 0];
    filtwts = firls(filtorder,f,m); % get FIR filter coefficients
    delta = filtfilt(filtwts,1,eeg_filt);

    fthetalow  = 4;
    fthetahigh = 8;
    nyq = fs*0.5;
    filtorder = 3*fix(fs/fthetalow);
    filtorder = max(15, filtorder);
    f = [0 (0.85)*fthetalow/nyq fthetalow/nyq fthetahigh/nyq (1.15)*fthetahigh/nyq 1];
    m = [0 0 1 1 0 0];
    filtwts = firls(filtorder,f,m); % get FIR filter coefficients
    theta = filtfilt(filtwts,1,eeg_filt);

    falphalow  = 8;
    falphahigh = 14;
    nyq = fs*0.5;
    filtorder = 3*fix(fs/falphalow);
    filtorder = max(15, filtorder);
    f = [0 (0.85)*falphalow/nyq falphalow/nyq falphahigh/nyq (1.15)*falphahigh/nyq 1];
    m = [0 0 1 1 0 0];
    filtwts = firls(filtorder,f,m); % get FIR filter coefficients
    alpha = filtfilt(filtwts,1,eeg_filt);

    fbetalow  = 14;
    fbetahigh = 40;
    nyq = fs*0.5;
    filtorder = 3*fix(fs/fbetalow);
    filtorder = max(15, filtorder);
    f = [0 (0.85)*fbetalow/nyq fbetalow/nyq fbetahigh/nyq (1.15)*fbetahigh/nyq 1];
    m = [0 0 1 1 0 0];
    filtwts = firls(filtorder,f,m); % get FIR filter coefficients
    beta = filtfilt(filtwts,1,eeg_filt);
    %}

    %figure;
    %plot(x,e1);
    %hold on;
    %plot(x,e1_filt);
    %hold off;
    ylowlim = -300;
    yhighlim = 300;

    %PSD
    window = 512;
    fftlength = 2^(nextpow2(window))*2;
    [psd_delta, f_delta] = pwelch(delta, window, 0, fftlength, fs);
    [psd_theta, f_theta] = pwelch(theta, window, 0, fftlength, fs);
    [psd_alpha, f_alpha] = pwelch(alpha, window, 0, fftlength, fs);
    [psd_beta, f_beta] = pwelch(beta, window, 0, fftlength, fs);

    %{
    %% Create plots
    % EEG plots
    figure;
    subplot(6,1,1);
    plot(x,eeg_data);
    title('EEG Data (Raw)');
    subplot(6,1,2);
    plot(x,eeg_filt);
    title('EEG Data (Filtered)');
    %ylim([ylowlim yhighlim]);
    subplot(6,1,3);
    plot(x,delta);
    title('\delta');
    %ylim([ylowlim yhighlim]);
    subplot(6,1,4);
    plot(x,theta);
    title('\theta');
    %ylim([ylowlim yhighlim]);
    subplot(6,1,5);
    plot(x,alpha);
    title('\alpha');
    %ylim([ylowlim yhighlim]);
    subplot(6,1,6);
    plot(x,beta);
    title('\beta');
    %ylim([ylowlim yhighlim]);
    %% PSD Plots
    %{
    psdlowf = 0;
    psdhighf = 40;
    subplot(4,2,2);
    %plot(10*log10(pxx_delta));
    plot(f_delta, 10*log10(psd_delta));
    xlim([psdlowf, psdhighf]);
    subplot(4,2,4);
    %plot(10*log10(pxx_theta));
    plot(f_theta, 10*log10(psd_theta));
    xlim([psdlowf, psdhighf]);
    subplot(4,2,6);
    %plot(10*log10(pxx_alpha));
    plot(f_alpha, 10*log10(psd_alpha));
    xlim([psdlowf, psdhighf]);
    subplot(4,2,8);
    %plot(10*log10(pxx_beta));
    plot(f_beta, 10*log10(psd_beta));
    xlim([psdlowf, psdhighf]);
    %}
    %}

    %% Power spectra calculations
    acceptableError = 0.01;
    deltaLowIdx = find(f_delta - fdeltalow > acceptableError, 1);        % Get index of 0.1 Hz
    deltaHighIdx = find(f_delta - fdeltahigh > acceptableError, 1);      % GEt index of 4 Hz
    PSD_delta = 10*log10(psd_delta);
    PSD_delta = mean(PSD_delta(deltaLowIdx:deltaHighIdx));

    thetaLowIdx = find(f_theta - fthetalow > acceptableError, 1);        % Get index of 0.1 Hz
    thetaHighIdx = find(f_theta - fthetahigh > acceptableError, 1);      % GEt index of 4 Hz
    PSD_theta = 10*log10(psd_theta);
    PSD_theta = mean(PSD_theta(thetaLowIdx:thetaHighIdx));

    alphaLowIdx = find(f_alpha - falphalow > acceptableError, 1);        % Get index of 0.1 Hz
    alphaHighIdx = find(f_alpha - falphahigh > acceptableError, 1);      % GEt index of 4 Hz
    PSD_alpha = 10*log10(psd_alpha);
    PSD_alpha = mean(PSD_alpha(alphaLowIdx:alphaHighIdx));

    betaLowIdx = find(f_beta - fbetalow > acceptableError, 1);        % Get index of 0.1 Hz
    betaHighIdx = find(f_beta - fbetahigh > acceptableError, 1);      % GEt index of 4 Hz
    PSD_beta = 10*log10(psd_beta);
    PSD_beta = mean(PSD_beta(betaLowIdx:betaHighIdx));

    PSD_data(n,:) = [PSD_delta, PSD_theta, PSD_alpha, PSD_beta];

end
%{
fft_delta = fft(delta);
PS_delta = (1/(fs*t_end))*abs(fft_delta).^2;
PSD_delta = sum(PS_delta);
PSD_delta = 10*log10(PSD_delta);

fft_theta = fft(theta);
PS_theta = (1/(fs*t_end))*abs(fft_theta).^2;
PSD_theta = sum(PS_theta);
PSD_theta = 10*log10(PSD_theta);

fft_alpha = fft(alpha);
PS_alpha = (1/(fs*t_end))*abs(fft_alpha).^2;
PSD_alpha = sum(PS_alpha);
PSD_alpha = 10*log10(PSD_alpha);

fft_beta = fft(beta);
PS_beta = (1/(fs*t_end))*abs(fft_beta).^2;
PSD_beta = sum(PS_beta);
PSD_beta = 10*log10(PSD_beta);
%}

%legend('RAW EEG', 'Filtered EEG', '\delta', '\theta','\alpha','\beta');

%% Store band type
% 0 = delta
% 1 = theta
% 2 = alpha
% 3 = beta
PSD_data(nRows,:) = [0, 1, 2, 3];

end