function plotFFT(data, fs)

% Plot FFT
N = max(size(data));
x_mags = abs(fft(data));
bin_vals = (0 : N-1);
fax_Hz = bin_vals*fs/N;
N_2 = ceil(N/2);
plot(fax_Hz(1:N_2), x_mags(1:N_2))
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)'); axis tight;

end