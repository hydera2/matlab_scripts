%% ICA LOOP MANUAL %%
clc
clear all
addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
addpath(genpath('/Users/amnahyder/Research/DependentFiles'));
eeglab
DependentFiles='/Users/amnahyder/Research/DependentFiles';
parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedLoc/';
%parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedLoc/SUBJ1_12/';

%% GET ALL THE SUBJECTS FROM FOLDER %%
fileList = dir(fullfile(parentfolder, '*_ica.set'));
numsubjects=length(fileList)
% Initialize the ALLERP structure and CURRENTERP *** should this be set to
% 0 before each subject?
ALLERP = buildERPstruct([]);
CURRENTERP = 0;


 for s=31:35
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '_'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    EEG = pop_loadset('filename',subject,'filepath',parentfolder);
    eeglab redraw
    pop_selectcomps(EEG, [1:32] );
    visualcheckcomp = input(['Press 1 to reject by visual inspection, press 0 to SKIP visual inspection and continue:']);                
    while visualcheckcomp==1
       num_comp = input(['Which component would you like to look at?']);
       EEG = pop_subcomp( EEG, [num_comp], 2); 
       visualcheckcomp = input(['Press 1 to reject by visual inspection, press 0 to SKIP visual inspection and continue:']);                
    end
    visualcheckcomp = input(['Press 1 to reject by visual inspection, press 0 to SKIP visual inspection and continue:']);                

    if visualcheckcomp==0
        comp_to_remove = input(['Which components would you like to remove?']);
        EEG = pop_subcomp( EEG, comp_to_remove, 0);
        savecomptoremove = ['comp_to_remove' subjname '.mat']
        save(savecomptoremove, 'comp_to_remove')
    end
    EEG.setname = [subjname '_ica_rej.set']; % Save _be
    EEG = eeg_checkset(EEG);
    EEG = pop_saveset( EEG, 'filename', EEG.setname,'filepath', parentfolder);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    fprintf('ICA saved and complete.\n\n');
    eeglab redraw
    moveonwithloop = input(['Press any Key to Move ON']);  
    close all
 end
 %% MANUALLY GO THROUGH EACH OF THE PCA/ICA COMPONENTS %%
%pop_selectcomps(EEG, [1:32] );

 %EEG = pop_subcomp( EEG, [n], 2);
 %         pop_eegplot( EEG, 1, 1, 0);
 
 %% replace n with the channel of interest
 %n = 10
 %figure; pop_erpimage(EEG,1, [n],[[]],['E' num2str(n)],10,1,{},[],'' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [n] EEG.chanlocs EEG.chaninfo } );
