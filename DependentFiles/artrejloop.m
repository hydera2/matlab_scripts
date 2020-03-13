%stepsPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/AmnaPreProcessedLoc/';
clear all
addpath(genpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0'));
addpath(genpath('/Users/amnahyder/Research/DependentFiles'));
stepsPath = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/AmnaPreProcessedVid/';
fileList = dir(fullfile(stepsPath, '*_epoched.set'));
numsubjects=length(fileList)

for s=32
   subject = fileList(s).name;
   subjname = char(extractBefore(subject, '_'))    
   EEG = pop_loadset('filename',subject,'filepath',stepsPath); 
   fprintf('\n\n\n**** %s: Artifact detection (visual inspection) ****\n\n\n', subjname);     
   visualrejcheck = input(['Press 1 to reject by visual inspection, press 0 to SKIP visual inspection and continue:']);                
   if visualrejcheck == 0
       EEG = pop_syncroartifacts(EEG); 
   end        
   if visualrejcheck==1
        display('Visual check. Either press Ctrl+C to abort, or inspect data now and update marks when done.'); 
        %pop_eegplot(EEG, 1, 1, 0);
        eeglab redraw
        visualrejcheck = input(['Need to double check visual detection? Press 1 for yes (check again), press 0 for no (continue):     ']);            
   end
   badChannelsVis = input('Enter BAD electrodes here as a vector (e.g., blank if none, [2] if only elec 2, [2 34] if elecs 2 & 34):    ');   % bad electrodes: those that are fuzzy/caterpiller and/or blank
   display(' ');
   if ~isempty(badChannelsVis) 
       YesorNo = input('Definitely interpolate these channels? Press 1 for yes, press 0 for no:     ');
       if YesorNo == 1
           EEG = pop_interp(EEG, badChannelsVis, 'spherical');
       end
   end
   EEG.setname = [subjname '_manreject.set'];
   EEG = pop_saveset( EEG, 'filename', EEG.setname,'filepath', stepsPath);
end