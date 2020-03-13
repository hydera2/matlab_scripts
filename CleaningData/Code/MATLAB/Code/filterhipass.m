function outData = filterhipass(inData, lowCutoff, fs)

[b,a] = butter(1,lowCutoff/(fs/2),'high');
outData = filter(b,a, inData);

end