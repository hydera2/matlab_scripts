%Amna Hyder modified from Ella Weik's code 2019. Using EEGlab2019

%% Set up EEGLAB and dependencies %%
clear all
clc
addpath(genpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0'));
addpath(genpath('/Users/amnahyder/Research/DependentFiles'));
eeglab
%make sure that the sfp file is in the specified folder
sfpfile ='GSN-HydroCel-257.sfp'
elecSetup = {'1:256' 'Cz'};
save_everything = 1; %set to 0 if you dont want steps in between saved
DependentFiles='/Users/amnahyder/Research/DependentFiles';


%% GET ALL THE SUBJECTS FROM FOLDER %%
parentfolder = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/videoEEG/';
stepsPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/AmnaPreProcessedVid/';
outputFilesPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/AmnaVideoERP/';
%change to .mff if you want to load mff files
fileList = dir(fullfile(parentfolder, '*.raw'));
fileList(1:13,:,:)=[]
numsubjects=length(fileList)
% Initialize the ALLERP structure and CURRENTERP *** should this be set to
% 0 before each subject?
ALLERP = buildERPstruct([]);
CURRENTERP = 0;


%% Loop through all subjects %%
for s=16:numsubjects
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '_'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    subjectfile = [parentfolder subject];
    fprintf('\n\n\n**** %s: Importing .raw into dataset ****\n\n\n', subject); 
    EEG = pop_readegi(subjectfile, [],[],'auto');
    EEG = eeg_checkset( EEG );
    EEG.setname = subjname; % Save .set; initial dataset
    EEG = pop_saveset( EEG, 'filename', subjname,'filepath', stepsPath);
    
    %% Read Event Information in from exported files %%
    fprintf('\n\n\n**** %s: Importing updated event information into dataset ****\n\n\n', subject); 
    eventspath = '/Users/amnahyder/Research/AmnaPreProcessedVid/Events/';
    EEG = pop_importevent( EEG, 'append','no','event',[eventspath subjname 'events.csv'],'fields',{'number' 'type' 'latency' 'uevent'},'skipline',1,'timeunit',0.001,'align',0);

    %% Read and setup channel location information %%
    %add empty reference channel
    fprintf('\n\n\n**** %s: Adding channel location info ****\n\n\n', subject);
    EEG.data(end+1,:) = 0;
    EEG.nbchan = size(EEG.data,1);
    if ~isempty(EEG.chanlocs)
        EEG.chanlocs(end+1).label = 'Cz';
    end;
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;
    %EEG=pop_chanedit(EEG, 'lookup','GSN-HydroCel-257.sfp');
    EEG=pop_chanedit(EEG, 'load',{sfpfile 'filetype' 'autodetect'},'setref',elecSetup);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG.setname = [subjname '_chan']; % Save _chan
        if (save_everything)
            EEG = pop_saveset( EEG, 'filename', [EEG.setname '.set']);
        end
        
    %% Filter Data FOR ERPs%%
    filtSaveName = sprintf('%s_filt.set',subjname);
    filtSavePath = fullfile(stepsPath,filtSaveName);
    EEG = pop_eegfilt( EEG, 0.05, 50, [], 0, 1, 0, 'fir1', 0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',filtSaveName,'savenew',filtSavePath,'overwrite','on','gui','off'); 
    EEG  = pop_basicfilter( EEG,  1:256 , 'Boundary', 'epoc', 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180, 'RemoveDC', 'on' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',filtSaveName,'savenew',filtSavePath,'overwrite','on','gui','off');
%     eeglab redraw;
%     EEG
    
   
    %% IDENTIFY BAD CHANNELS %%
    %this runs the FASTER algorithm to get the hurst coefficient and other
    %channel properties to get a very conservative estimate of bad channels
    [badChannels, EEG] = amnaFASTER(EEG, outputFilesPath, subjname);
    BadChannelsPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/AmnaPreProcessedVid/BadChannels/';
    save([BadChannelsPath subjname], 'badChannels');
%     pop_spectopo( EEG);
%     badChannelsVis = input('Enter BAD electrodes here as a vector (e.g., blank if none, [2] if only elec 2, [2 34] if elecs 2 & 34):    ');   % bad electrodes: those that are fuzzy/caterpiller and/or blank
%     display(' ');
%     YesorNo = input('Definitely interpolate these channels? Press 1 for yes, press 0 for no:     ');
    EEG = pop_interp(EEG, badChannels, 'spherical');
    
    
    %% INTERPOLATE BAD CHANNELS %%
    %remove empty data channel
    EEG = eeg_checkset( EEG );
    EEG = pop_select( EEG,'nochannel',{'Cz'});
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
    fprintf('Removed empty data channel. ');
    eeglab redraw;

    %interpolate bad channels
    EEG = eeg_checkset( EEG );
    %interpolating
    EEG = pop_interp(EEG, badChannels, 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
    eeglab redraw;
    fprintf('Interpolation saved and complete.\n\n');

    %% RE-REFERENCE CHANNELS TO AVERAGE %%
    EEG = eeg_checkset( EEG );
    %rereferencing
    EEG = pop_reref( EEG, []);
    avRefname = sprintf('%s_filt_int_reref.set',subjname);
    avRefPath = fullfile(stepsPath,avRefname);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',avRefname,'savenew',avRefPath,'overwrite','on','gui','off'); 
    eeglab redraw;
    fprintf('... Re-referencing complete.');
    
    %% IMPORT EVENTS %%
    fprintf('\n\n\n**** %s: Creating eventlist (labelling event codes) ****\n\n\n', subject);
    %replace with the correct event file
    Eventfile = fullfile(DependentFiles,'videoTask_eventList.txt');
    EEG  = pop_editeventlist( EEG , 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List', Eventfile, 'SendEL2', 'EEG', 'UpdateEEG', 'code', 'Warning', 'on' ); % GUI: 10-Aug-2018 12:56:53
    EEG  = pop_overwritevent( EEG, 'code');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
    %replace with the correct BDF file
    BDFfile = fullfile(DependentFiles,'videoTask_bdf.txt')
    EEG  = pop_binlister( EEG , 'BDF', BDFfile, 'IndexEL',  1, 'SendEL2', 'Workspace&EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 10-Aug-2018 12:57:14
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    
    %% EPOCH DATA %%
    EEG = pop_epochbin( EEG , [-500 1000],  'pre');
    EEG.setname = [subjname '_epoched.set']; % Save _be
    if (save_everything)
        EEG = pop_saveset( EEG, 'filename', EEG.setname,'filepath', stepsPath);
    end
    eeglab redraw;
    fprintf('Epochs saved and complete.\n\n');
end