function outData = filterbandpass(inData, lowCutoff, highCutoff, fs)

% Low-pass
outData = filterlopass(inData, highCutoff, fs);

% High-pass
outData = filterhipass(outData, lowCutoff, fs);

end