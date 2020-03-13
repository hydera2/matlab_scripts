function [PSD_delta, PSD_theta, PSD_alpha, PSD_beta] = mff_read_test(file)
mff_setup
%file= 'C:\Users\sgarg\Desktop\eeg data\RFC01B0001_20160910_095450.mff';
hdr = read_mff_header(file);

chan = []; % all channels
numOfsamples_from = 1;
numOfsamples_to = hdr.nSamples - mod(hdr.nSamples,90000);
data = read_mff_data(file,'sample', numOfsamples_from,numOfsamples_to, [], hdr );
%event = read_mff_event(file, hdr);

sampDuration = 6; % minutes
%fs = 250;
fs = numOfsamples_to/(sampDuration*60);
t_end = numOfsamples_to/fs;
e1 = data(1,:);
x = linspace(0,t_end,numOfsamples_to);

order    = 2;
fcutlow  = 0.1;
fcuthigh = 30;
[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');
e1_filt        = filtfilt(b,a,e1);

%delta (f < 4 Hz)
fdeltalow  = 0.1;
fdeltahigh = 4;
[b,a]    = butter(order,[fdeltalow,fdeltahigh]/(fs/2), 'bandpass');
delta        = filtfilt(b,a,e1_filt);

%theta (4 =< f < 8 Hz)
fthetalow  = 4;
fthetahigh = 8;
[b,a]    = butter(order,[fthetalow,fthetahigh]/(fs/2), 'bandpass');
theta        = filtfilt(b,a,e1_filt);

%alpha (8 =< f < 14 Hz)
falphalow  = 8;
falphahigh = 14;
[b,a]    = butter(order,[falphalow,falphahigh]/(fs/2), 'bandpass');
alpha        = filtfilt(b,a,e1_filt);

%beta (f >= 14)
fbetalow  = 14;
fbetahigh = 30;
[b,a]    = butter(order,[fbetalow,fbetahigh]/(fs/2), 'bandpass');
beta        = filtfilt(b,a,e1_filt);

%figure;
%plot(x,e1);
%hold on;
%plot(x,e1_filt);
%hold off;
ylowlim = -300;
yhighlim = 300;

%PSD
[psd_delta, f_delta]=pwelch(delta, numOfsamples_to, 0.5*numOfsamples_to, numOfsamples_to, fs);
[psd_theta, f_theta]=pwelch(theta, numOfsamples_to, 0.5*numOfsamples_to, numOfsamples_to, fs);
[psd_alpha, f_alpha]=pwelch(alpha, numOfsamples_to, 0.5*numOfsamples_to, numOfsamples_to, fs);
[psd_beta, f_beta]=pwelch(beta, numOfsamples_to, 0.5*numOfsamples_to, numOfsamples_to, fs);

pxx_delta = pwelch(delta);
pxx_theta = pwelch(theta);
pxx_alpha = pwelch(alpha);
pxx_beta = pwelch(beta);

%% Create plots
% EEG plots
figure;
subplot(4,2,1);
plot(x,delta);
title('\delta');
%ylim([ylowlim yhighlim]);
subplot(4,2,3);
plot(x,theta);
title('\theta');
%ylim([ylowlim yhighlim]);
subplot(4,2,5);
plot(x,alpha);
title('\alpha');
%ylim([ylowlim yhighlim]);
subplot(4,2,7);
plot(x,beta);
title('\beta');
%ylim([ylowlim yhighlim]);
%% PSD Plots
psdlowf = 0;
psdhighf = 35;
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

%% Power spectra calculations
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

%legend('RAW EEG', 'Filtered EEG', '\delta', '\theta','\alpha','\beta');
end