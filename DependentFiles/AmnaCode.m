%% Set up EEGLAB and dependencies %%
clear all
clc
addpath(genpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0'));
eeglab
%make sure that the sfp file is in the specified folder
sfpfile ='GSN-HydroCel-257.sfp'
elecSetup = {'1:256' 'Cz'};
save_everything = 1; %set to 0 if you dont want steps in between saved
addpath(genpath('/Users/amnahyder/Research/LocalizerEEGData'));

%% GET ALL THE SUBJECTS FROM FOLDER %%
parentfolder = '/Users/amnahyder/Research/LocalizerEEGData/';
stepsPath = '/Users/amnahyder/Research/LocalizerEEGData/preprocessed/preprocessedSteps';
outputFilesPath = '/Users/amnahyder/Research/LocalizerEEGData/preprocessed/';
%change to .mff if you want to load mff files
fileList = dir(fullfile(parentfolder, '*.raw'));
numsubjects=length(fileList)
% Initialize the ALLERP structure and CURRENTERP *** should this be set to
% 0 before each subject?
ALLERP = buildERPstruct([]);
CURRENTERP = 0;


%% Loop through all subjects %%
for s=1:numsubjects
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '.'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    subjectfile = [parentfolder subject];
    fprintf('\n\n\n**** %s: Importing .raw into dataset ****\n\n\n', subject); 
    EEG = pop_readegi(subjectfile, [],[],'auto');
    EEG = eeg_checkset( EEG );
    EEG.setname = subject; % Save .set; initial dataset
    EEG = pop_saveset( EEG, 'filename', subject,'filepath', parentfolder);

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
    filtSavePath = fullfile(parentfolder,filtSaveName);
    EEG = pop_eegfilt( EEG, 0.05, 30, [], 0, 1, 0, 'fir1', 0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',filtSaveName,'savenew',filtSavePath,'overwrite','on','gui','off'); 
    EEG  = pop_basicfilter( EEG,  1:256 , 'Boundary', 'epoc', 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180, 'RemoveDC', 'on' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',filtSaveName,'savenew',filtSavePath,'overwrite','on','gui','off');
    eeglab redraw;
    EEG
    
   
    %% IDENTIFY BAD CHANNELS %%
    %this runs the FASTER algorithm to get the hurst coefficient and other
    %channel properties to get a very conservative estimate of bad channels
    [badChannels, EEG] = amnaFASTER(EEG, outputFilesPath, subjname)    
    pop_spectopo( EEG);
    badChannelsVis = input('Enter BAD electrodes here as a vector (e.g., blank if none, [2] if only elec 2, [2 34] if elecs 2 & 34):    ');   % bad electrodes: those that are fuzzy/caterpiller and/or blank
    display(' ');
    YesorNo = input('Definitely interpolate these channels? Press 1 for yes, press 0 for no:     ');
    badChannels = [badChannels badChannelsVis]
    
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
    avRefPath = fullfile(parentfolder,avRefname);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',avRefname,'savenew',avRefPath,'overwrite','on','gui','off'); 
    eeglab redraw;
    fprintf('... Re-referencing complete.');
    
    %% IMPORT EVENTS %%
    
    
    %% EPOCH DATA %%
    
    
    %% MANUALLY CLEAN DATA %%
    
    
    %% ICA OR PCA ON DATA %%
    EEG = pop_runica(EEG, 'binica','pca',64);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',icaSaveName,'savenew',icaSavePath,'overwrite','on','gui','off'); 
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;
    fprintf('ICA saved and complete.\n\n');
    
    %% AVERAGE ERPS %% 
    fprintf('\n\n\n**** %s: FINISHED SUBJECT ****\n\n\n', subject);   
end % end looping through all subjects

%eeglab redraw

