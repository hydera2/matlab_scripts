%% Time Frequency Analysis with fieldtrip
% Ella Weik August 2018
% Use preprocessed, clean, bin-based epoched data
% 
% wm_trialfun is a seperate function. Error: Can't find events, check if
% cfg.epochBaseInt  and cfg.epochInt are in line with epochs in EEG


%% setup subjects, bin of interest, and your directories %%
parentfolder = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/videoPreprocessed/'; %where to input EEG set files
TFRdir = '/Users/amnahyder/Research/AmnaVideoTFR';
addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
fileList = dir(fullfile(parentfolder, '*icarej.set'));

for binOfInt = 30

%binOfInt = 31;%have it loop through the bins in the set file - what are the bin numbers for the ones I am interested in?;
    
for subject = 37:length(fileList)
    %subject = fileList(s).name;
    %subjname = char(extractBefore(subject, '_'))
    currentSubject = fileList(subject).name; %setup current subject name
    subName = char(extractBefore(currentSubject,'_')); %name of current subject for output path
    dsname = [parentfolder, currentSubject]; %EEG subject dataset directory
    fprintf('preparing %s for preprocessing and time-frequency analysis for bin %d\n',subName,binOfInt);

    cfg = [];                                           % empty configuration
    cfg.dataset = dsname;% name of EEG dataset  
    cfg.continuous              = 'no';
    cfg.trialfun                = 'wm_trialfun'; % function that segements data accordign to selected parameters
    %cfg.codeLabel               = 'rightValTargOn'; % can define conditions of interest either with a code label or with a bin number. Program will default to bin number if it is defined.
    cfg.binNumber               = binOfInt;% enter desired bin number from bdf file. If you want to use code labels instead, set this to 0.
    cfg.epochBaseInt            = -0.50; % total baseline interval in data file
    cfg.epochInt                = 5; % total post-stim interval in data file
    cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
    %cfg.trialdef.prestim        = cfg.epochBaseInt - 0.01; %baseline to extract (need to leave 10 ms gap)
    cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
    
    cfg = ft_definetrial(cfg);         
    dataFIC = ft_preprocessing(cfg);
    saveNameFIC = sprintf('%s/%s_dataFIC_bin%d.mat',TFRdir,subName,binOfInt);
    save(saveNameFIC, 'dataFIC');
    
    
    % compute wavelet transform
    % see ft_freqanalysis for information. All parameters are
    % optional/changable.
    cfg = [];
    cfg.channel    = 'EEG';	 
    cfg.trials     = 'all' ;%or a selection given as a 1xN vector (default = 'all')
    cfg.keeptrials = 'no'; % 'yes' or 'no', return individual trials or average (default = 'no')
    cfg.output     = 'pow';	%powandcsd
    cfg.foi        = 0.5:0.5:50;% what frequencies are you interested in? This is a vector of whatever length you want.
    cfg.toi        = -0.5:0.01:5; % what times are you interested in? Can not exceed total epoch length. For individual trials, include baseline "pre" interval (event is at 0). For erps, the epoch window includes the basel9ine, but starts at 0 (event time is at 0 + baseline interval). 	
    cfg.pad        = 'nextpow2';
    % for using a wavelet transform, use the following 3 parameters (and
    % comment out the mtmconvol section)
    % cfg.method     = 'wavelet';
    % cfg.width      = 4; % width of wavelet in number of cycles (decreasing this number increases temporal resolution at the cost of frequency resolution
    % cfg.length     = 7; % height of wavelet in the frequency domain (i.e., spread across frequencies) 
    % for using a mtmconvol transform, use the following 4 parameters (and
    % comment out the wavelt section above)
    cfg.method = 'mtmconvol';
    cfg.tapsmofrq = 6;
    cfg.taper = 'hanning';
    cfg.t_ftimwin = ones(length(cfg.foi)).*0.4; % 400 ms windows
    TFR = ft_freqanalysis(cfg, dataFIC);
    saveNameTFR = sprintf('%s/%s_TFR_bin%d.mat',TFRdir,subName,binOfInt);
    save(saveNameTFR, 'TFR');
end

end


%% Average across subjects with fieldtrip 
% average across participants, subgroups for each bin seperately 
% indicate the bin, subgroup, etc. above


parentfolder = '/home/tipperlab/Documents/projects/SocialExclusion/Data/EEG/timeFreqAnalysis/TFR'; %where to input EEG set files
outputDir = '/home/tipperlab/Documents/projects/SocialExclusion/Data/EEG/timeFreqAnalysis/groupAnalysis'; %where analyzed data is saved
currentDir = pwd;
subjectlistTFR  = {'soe001', 'soe002', 'soe003'}; %list of subjects you are analyzing (must match file naming structure)
strBin = 1;
endBins = 6;

cfg = [];
cfg.keepindividual = 'yes';           % individual data needed for stats
cfg.foilim         = 'all';          % define specific frequencies you want to average
cfg.toilim         = 'all' ;         % define specific time interval you want to average
%cfg.channel        = 'all' ;         % define channels
%cfg.channel        = [3, 116, 117, 123, 125];  %right
cfg.channel        = [23, 24, 27, 28, 34];  %left
cfg.parameter      = 'powspctrm';   % what do you want to average
  
elecSubject = subjectlistTFR{1};  
subNameElec = char(elecSubject);
nameTRFelec = sprintf('%s/%s_TFR_bin1',parentfolder,subNameElec); 
load(nameTRFelec);
elec = TFR.elec;

avPowspectrmList = {1,length(subjectlistTFR)};
for i = strBin:endBin
    for subject = 1:length(subjectlistTFR)
        currentSubject = subjectlistTFR{subject};    
        subNameAv = char(currentSubject);       % converts the subj name into charracter array
        nameTRFinput = sprintf('%s_TFR_bin%d',subNameAv,binOfInt); 
        avPowspectrmList{1,subject} = nameTRFinput; % list with all subjects to averag 
    end
        binOfInt = i;
        cd(TFRdir);
        cfg.inputfile   = avPowspectrmList; 
        [avgTFR] = ft_freqgrandaverage(cfg);
        TFRavg.elec = elec;
        saveName= sprintf('%s/avgTFR_bin%d.mat',outputDir,binOfInt);
        save(saveName, 'avgTFR');      
end


%% Plot Powerspectra

cfg = [];
cfg.parameter = 'powspctrm';
cfg.renderer = 'painters';
cfg.layout = avgTFR.elec;
cfg.layout = 'ordered'; 
%cfg.channel  = [142 143];
%cfg.channel  = 'all';
cfg.baseline     = [-0.5 0]; 
%cfg.baselinetype = 'absolute'; 
cfg.baselinetype = 'relative'; 

%cfg.colormap = jet;
cfg.fontsize = 16;
cfg.title = 'TimeFreq 30';
cfg.zlim=[ 0.5 1.5];
cfg.showlabels   = 'yes';	    
cfg.channel = [1:8:256]; 

figure;
ft_multiplotTFR(cfg,avgTFR);
%figure;
%ft_singleplotTFR(cfg,avgTFR)
figure;
ft_topoplotTFR(cfg,avgTFR);



%% Plot Powerspectra

cfg = [];
cfg.parameter = 'powspctrm';
cfg.renderer = 'painters';
cfg.layout = avgTFR31.elec;
cfg.layout = 'ordered'; 
%cfg.channel  = [142 143];
%cfg.channel  = 'all';
cfg.baseline     = [-0.5 0]; 
cfg.baselinetype = 'absolute'; 
cfg.colormap = jet;
cfg.fontsize = 16;
cfg.title = 'Titel';
cfg.zlim=[ -1.5 1.5];
cfg.showlabels   = 'yes';	    
cfg.channel = [1:8:256]; 

figure;
ft_multiplotTFR(cfg,avgTFR31);
%figure;
%ft_singleplotTFR(cfg,avgTFR31)

