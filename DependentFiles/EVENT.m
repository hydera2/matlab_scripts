
%% Set up EEGLAB and dependencies %%
clear all
clc
addpath(genpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0'));
addpath(genpath('/Users/amnahyder/Research/DependentFiles'));
eeglab

%% GET ALL THE SUBJECTS FROM FOLDER %%
parentfolder = '/Users/amnahyder/Research/localizerEEG';
stepsPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/localizerEEG';
%change to .mff if you want to load mff files
fileList = dir(fullfile(stepsPath, '*.raw'));
fileList(1:18,:,:)=[]
numsubjects=length(fileList)
ALLERP = buildERPstruct([]);
CURRENTERP = 0;


%% Loop through all subjects %%
for s=11:40
    p = num2str(s)
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '_'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    %subjectfile = ['s',p, 'loc_raw.set'];
    subjectfile = [stepsPath subject];
    fprintf('\n\n\n**** %s: Importing set file into dataset ****\n\n\n', subject); 
    %EEG = pop_loadset('filename',subjectfile,'filepath',stepsPath);
    EEG = pop_readegi(subjectfile, [],[],'auto');
    pop_expevents(EEG,[parentfolder '/' EEG.setname 'events.csv'], 'samples');
    %EEG = pop_importevent( EEG, 'append','no','event',[parentfolder EEG.setname 'events.csv'],'fields',{'number' 'type' 'latency' 'uevent'},'skipline',1,'timeunit',0.001,'align',0);
end