%% POINT TO DATA AND FILE LOCATIONS %%
clear all
addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
addpath(genpath('/Users/amnahyder/Research/DependentFiles'));
eeglab
%make sure that the sfp file is in the specified folder
sfpfile ='GSN-HydroCel-257.sfp';
elecSetup = {'1:256' 'Cz'};
%DependentFiles='/Users/amnahyder/Research/DependentFiles';
DependentFiles='/Users/amnahyder/Research/DependentFiles';
%parentfolder = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/AmnaPreProcessedLoc/';
parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedVid/';


%% GET ALL THE SUBJECTS FROM FOLDER %%
%change to .mff if you want to load mff files
fileList = dir(fullfile(parentfolder, '*_manreject.set'));
numsubjects=length(fileList)
% Initialize the ALLERP structure and CURRENTERP *** should this be set to
% 0 before each subject?
ALLERP = buildERPstruct([]);
CURRENTERP = 0;


 for s=26:29
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '_'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    EEG = pop_loadset('filename',subject,'filepath',parentfolder);
    %eeglab redraw
    EEG = pop_runica(EEG, 'icatype', 'binica', 'pca',32);
    %EEG = pop_runica(EEG, 'binica','pca',32);
    EEG.setname = [subjname '_ica.set']; % Save _be
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[subjname '_ICA.set'],'savenew',parentfolder,'overwrite','on','gui','off'); 
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset(EEG);
    EEG = pop_saveset( EEG, 'filename', EEG.setname,'filepath', parentfolder);
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     eeglab redraw;
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    fprintf('ICA saved and complete.\n\n');
 end
 %% MANUALLY GO THROUGH EACH OF THE PCA/ICA COMPONENTS %%
%pop_selectcomps(EEG, [1:32] );

 %EEG = pop_subcomp( EEG, [n], 2);
 %         pop_eegplot( EEG, 1, 1, 0);
 
 %% replace n with the channel of interest
 %n = 10
 %figure; pop_erpimage(EEG,1, [n],[[]],['E' num2str(n)],10,1,{},[],'' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [n] EEG.chanlocs EEG.chaninfo } );

