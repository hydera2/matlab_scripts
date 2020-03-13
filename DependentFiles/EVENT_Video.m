
stepsPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/videoPreprocessed/';
%change to .mff if you want to load mff files
fileList = dir(fullfile(stepsPath, '*filt.set'));
%fileList(1:13,:,:)=[]
numsubjects=length(fileList)
ALLERP = buildERPstruct([]);
CURRENTERP = 0;
parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedVid/Events';

%% Loop through all subjects %%
for s=1:numsubjects
    p = num2str(s)
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '_'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    %subjectfile = ['s',p, 'loc_raw.set'];
    subjectfile = [stepsPath subject];
    fprintf('\n\n\n**** %s: Importing set file into dataset ****\n\n\n', subject); 
    %EEG = pop_loadset('filename',subjectfile,'filepath',stepsPath);
    EEG = pop_loadset('filename',subject,'filepath',stepsPath); 
    pop_expevents(EEG,[parentfolder '/' subjname 'events.csv'], 'samples');
    %EEG = pop_importevent( EEG, 'append','no','event',[parentfolder EEG.setname 'events.csv'],'fields',{'number' 'type' 'latency' 'uevent'},'skipline',1,'timeunit',0.001,'align',0);
end