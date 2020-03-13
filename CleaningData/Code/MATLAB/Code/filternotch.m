function data = filternotch(inData, notchF, band, fs)

wo = notchF/(fs/2);
bw = band/(fs/2);
[b,a] = iirnotch(wo,bw);
data = filtfilt(b,a,inData);

end