path2use = '/Users/amnahyder/Research/AmnaPreProcessedLoc/'
fileList = dir(fullfile(path2use, '*ica_rej.fdt'));
fileList2 = dir(fullfile(path2use, '*ica_rej.set'));
num = length(fileList2)
folder = '/Volumes/NABIL_128/FILESFORERP';
for s=1:num
    subject = char([path2use fileList(s).name]);
    copyfile(subject, folder)
end
for s=1:num
    subject = char([path2use fileList2(s).name]);
     copyfile(subject, folder)
end