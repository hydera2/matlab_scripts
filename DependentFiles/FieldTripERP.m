
%% setup subjects, bin of interest, and your directories %%
binnames = [1 2 4 5];
for bin1 = 1:4
    binOfInt=binnames(bin1);
    parentfolder = '/Volumes/NABIL_128/FILESFORERP/';
    addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
    addpath('/Users/amnahyder/Research/DependentFiles');
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    ft_defaults
    fileList= dir(fullfile(parentfolder, '*ica_rej.set'));
    FieldtripERPdir = '/Volumes/Amnas_Data/socialBrainBackup/socialBrainEEG/AMNASOURCE/'
    fileList(1:2) =[]
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
        cfg.epochInt                = 1; % total post-stim interval in data file
        cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
        cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
        cfg = ft_definetrial(cfg);         
        dataFIC = ft_preprocessing(cfg);
       
        % compute ERP analysis
        cfg = [];
        cfg.covariance = 'yes';
        cfg.covariancewindow = [-0.50 0]; %it will calculate the covariance matrix
        ERPfile = ft_timelockanalysis(cfg, dataFIC);
        saveNameFIC = sprintf('%s/%s_dataERP_bin%d.mat',FieldtripERPdir,subName,binOfInt);
        save(saveNameFIC, 'ERPfile');
    end
end
clearvars -global
clear all

binnames = [1 2 3 4];
for bin1 = 1:4
    binOfInt=binnames(bin1);
    parentfolder = '/Volumes/NABIL_128/FILESFORERP/12_40/';
    addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
    addpath('/Users/amnahyder/Research/DependentFiles');
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    FieldtripERPdir = '/Volumes/Amnas_Data/socialBrainBackup/socialBrainEEG/AMNASOURCE/'
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
        cfg.epochInt                = 1; % total post-stim interval in data file
        cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
        cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
        cfg = ft_definetrial(cfg);         
        dataFIC = ft_preprocessing(cfg);
       
        % compute ERP analysis
        cfg = [];
        cfg.covariance = 'yes';
        cfg.covariancewindow = [-0.50 0]; %it will calculate the covariance matrix
        ERPfile = ft_timelockanalysis(cfg, dataFIC);
        saveNameFIC = sprintf('%s/%s_dataERP_bin%d.mat',FieldtripERPdir,subName,binOfInt);
        save(saveNameFIC, 'ERPfile');
    end
end
   
