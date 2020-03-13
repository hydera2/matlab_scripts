function outData = filterlopass(inData, highCutoff, fs)

[b,a] = butter(1,highCutoff/(fs/2),'low');
outData = filtfilt(b,a, inData);

end