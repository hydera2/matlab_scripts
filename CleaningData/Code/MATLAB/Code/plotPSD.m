function getPSD(file)

%file = 'C:\Users\Andrew\Documents\Work\EEGleWave\EEG Report Generation\trunk\code\mat_data\RFC01B0001_20160910_095450.mat'

%pkg load control
%pkg load signal

load(file);

sampleLength = length(data);
numElec = size(data, 1);
numOfsamples_to = sampleLength - mod(sampleLength,90000);

sampDuration = 6; % minutes
%fs = 250;
fs = numOfsamples_to/(sampDuration*60);
t_end = sampleLength/fs;

figure
subplot(4,1,1);
hold on;
subplot(4,1,2);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;

for n = 1:numElec
    eeg_data = data(n,:);

    order    = 2;
    fcutlow  = 0.1;
    fcuthigh = 40;
    [b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');
    eeg_filt = filtfilt(b,a,eeg_data);

    %delta (f < 4 Hz)
    fdeltalow  = 0.1;
    fdeltahigh = 4;
    [b,a]      = butter(order,[fdeltalow,fdeltahigh]/(fs/2), 'bandpass');
    delta      = filtfilt(b,a,eeg_filt);

    %theta (4 =< f < 8 Hz)
    fthetalow  = 4;
    fthetahigh = 8;
    [b,a]      = butter(order,[fthetalow,fthetahigh]/(fs/2), 'bandpass');
    theta      = filtfilt(b,a,eeg_filt);

    %alpha (8 =< f < 14 Hz)
    falphalow  = 8;
    falphahigh = 14;
    [b,a]      = butter(order,[falphalow,falphahigh]/(fs/2), 'bandpass');
    alpha      = filtfilt(b,a,eeg_filt);

    %beta (f >= 14)
    fbetalow  = 14;
    fbetahigh = 40;
    [b,a]     = butter(order,[fbetalow,fbetahigh]/(fs/2), 'bandpass');
    beta      = filtfilt(b,a,eeg_filt);

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
    
    %PSD
    window = 512;
    fftlength = 2^(nextpow2(window))*2;
    [psd_delta, f_delta] = pwelch(delta, window, 0, fftlength, fs);
    [psd_theta, f_theta] = pwelch(theta, window, 0, fftlength, fs);
    [psd_alpha, f_alpha] = pwelch(alpha, window, 0, fftlength, fs);
    [psd_beta, f_beta] = pwelch(beta, window, 0, fftlength, fs);

    %% Create PSD Plots
    psdlowf = 0;
    psdhighf = 40;
    subplot(4,1,1);
    %plot(10*log10(pxx_delta));
    plot(f_delta, 10*log10(psd_delta));
    xlim([psdlowf, psdhighf]);
    subplot(4,1,2);
    %plot(10*log10(pxx_theta));
    plot(f_theta, 10*log10(psd_theta));
    xlim([psdlowf, psdhighf]);
    subplot(4,1,3);
    %plot(10*log10(pxx_alpha));
    plot(f_alpha, 10*log10(psd_alpha));
    xlim([psdlowf, psdhighf]);
    subplot(4,1,4);
    %plot(10*log10(pxx_beta));
    plot(f_beta, 10*log10(psd_beta));
    xlim([psdlowf, psdhighf]);

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
end
hold off;
end