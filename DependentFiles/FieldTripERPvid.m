
%% setup subjects, bin of interest, and your directories %%
binnames = [24 25 26 27 28 29];
for bin1 = 1:6
    binOfInt=binnames(bin1);
    parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedVid/1_10/';
    addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
    addpath('/Users/amnahyder/Research/DependentFiles');
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    ft_defaults
    fileList= dir(fullfile(parentfolder, '*ica_rej.set'));
    FieldtripERPdir = '/Volumes/TOSHIBA_EXT/Source_video/'
    %fileList(1:2) =[]
    numsubs = length(fileList)
    for subject = 1:numsubs
        currentSubject = fileList(subject).name; %setup current subject name
        subName = char(extractBefore(currentSubject,'_')); %name of current subject for output path
        dsname = [parentfolder, currentSubject]; %EEG subject dataset directory
        fprintf('preparing %s for preprocessing for bin %d\n',subName,binOfInt);

        cfg = [];                                           % empty configuration
        cfg.dataset = dsname;% name of EEG dataset  
        cfg.continuous              = 'no';
        cfg.trialfun                = 'wm_trialfun'; % function that segements data accordign to selected parameters
        cfg.binNumber               = binOfInt;% enter desired bin number from bdf file. If you want to use code labels instead, set this to 0.
        cfg.epochBaseInt            = -0.50; % total baseline interval in data file
        cfg.epochInt                = 1.5; % total post-stim interval in data file
        cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
        cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
        cfg = ft_definetrial(cfg);         
        dataFIC = ft_preprocessing(cfg);
       
        % compute ERP analysis
        cfg = [];
        cfg.covariance = 'yes';
        cfg.covariancewindow = [-0.50 0]; %it will calculate the covariance matrix
        ERPfile = ft_timelockanalysis(cfg, dataFIC);
        saveNameFIC = sprintf('%s/%s_dataERP_bin%d.mat',FieldtripERPdir,subName,bin1);
        save(saveNameFIC, 'ERPfile');
    end
end
clearvars -global
clear all

binnames = [8 9 10 11 12 13];
for bin1 = 1:6
    binOfInt=binnames(bin1);
    parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedVid/11_on/';
    addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
    addpath('/Users/amnahyder/Research/DependentFiles');
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    FieldtripERPdir = '/Volumes/TOSHIBA_EXT/Source_video/'
    fileList= dir(fullfile(parentfolder, '*ica_rej.set'));
    numsubs = length(fileList)
    for subject = 1:numsubs
        currentSubject = fileList(subject).name; %setup current subject name
        subName = char(extractBefore(currentSubject,'_')); %name of current subject for output path
        dsname = [parentfolder, currentSubject]; %EEG subject dataset directory
        fprintf('preparing %s for preprocessing for bin %d\n',subName,binOfInt);

        cfg = [];                                           % empty configuration
        cfg.dataset = dsname;% name of EEG dataset  
        cfg.continuous              = 'no';
        cfg.trialfun                = 'wm_trialfun'; % function that segements data accordign to selected parameters
        cfg.binNumber               = binOfInt;% enter desired bin number from bdf file. If you want to use code labels instead, set this to 0.
        cfg.epochBaseInt            = -0.50; % total baseline interval in data file
        cfg.epochInt                = 5; % total post-stim interval in data file
        cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
        cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
        cfg = ft_definetrial(cfg);         
        dataFIC = ft_preprocessing(cfg);
       
        % compute ERP analysis
        cfg = [];
        cfg.covariance = 'yes';
        cfg.covariancewindow = [-0.50 0]; %it will calculate the covariance matrix
        ERPfile = ft_timelockanalysis(cfg, dataFIC);
        saveNameFIC = sprintf('%s/%s_dataERP_bin%d.mat',FieldtripERPdir,subName,bin1);
        save(saveNameFIC, 'ERPfile');
    end
end


%% FILES 1-10 %%
% BIN1 = Experiment Prep 
% BIN2 = Run Start 
% BIN3 = Means Ordinary
% BIN4 = Intention Ordinary
% BIN5 = Social Ordinary 
% BIN6 = Means Peculiar
% BIN7 = Intention Peculiar
% BIN8 = Social Peculiar 
% BIN9 = Response
% BIN10 = Ordinary Response 
% BIN11 = Peculiar Response 
% BIN12 = Correct Response
% BIN13 = Incorrect Response
% BIN14 = Miss
% BIN15 = Movie End 
% BIN16 = Break Start 
% BIN17 = Break End 
% BIN18 = Probe On
% BIN19 = Trial Start 
% BIN20 = Peculiar Video
% BIN21 = Ordinary Video
% BIN22 = Peculiar On 
% BIN23 = Peculiar Off
% BIN24 = Means Peculiar On 
% BIN25 = Intention Peculiar On 
% BIN26 = Social Peculiar On
% BIN27 = Means Ordinary On 
% BIN28 = Intention Ordinary On 
% BIN29 = Social Ordinary On
% BIN30 = Peculiar Video Event Onset
% BIN31 = Dummy Video Event Onset 
%[24 25 26 27 28 29]



%% Files 11-40 %%
% BIN1 = Means Ordinary
% BIN2 = Intention Ordinary
% BIN3 = Social Ordinary 
% BIN4 = Means Peculiar
% BIN5 = Intention Peculiar
% BIN6 = Social Peculiar 
% BIN7 = Peculiar Off
% BIN8 = Means Peculiar On 
% BIN9 = Intention Peculiar On 
% BIN10 = Social Peculiar On
% BIN11 = Means Ordinary On 
% BIN12 = Intention Ordinary On 
% BIN13 = Social Ordinary On


%[8 9 10 11 12 13]
   
