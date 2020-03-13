parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedLoc/'; %where to input EEG set files
savefolder = '/Users/amnahyder/Research/TestFiles/Noise';
fileList = dir(fullfile(parentfolder, '*ica_rej.set'));
for i = 1:length(fileList)
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    filename = fileList(i).name
    subjname = char(extractBefore(filename, '_'))    
    EEG = pop_loadset('filename',filename,'filepath',parentfolder);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = pop_epochbin( EEG , [-500.0  0.0],  'none'); % GUI: 25-Nov-2019 21:29:38
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    EEG.setname = [subjname '_noisecovdata.set'];
    EEG = pop_saveset( EEG, 'filename', EEG.setname,'filepath', savefolder);
end