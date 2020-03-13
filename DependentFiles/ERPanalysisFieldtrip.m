
%% setup subjects, bin of interest, and your directories %%
binnames = [1 2 4 5];
for bin1 = 1:4
    binOfInt=binnames(bin1);
    parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedLoc/1_12'; 
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    fileList = dir(fullfile(parentfolder, '*ica_rej.set'));
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    addpath('/Users/amnahyder/Research/DependentFiles')
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
        cfg.epochInt                = 1; % total post-stim interval in data file
        cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
        cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
        cfg = ft_definetrial(cfg);         
        dataFIC = ft_preprocessing(cfg);
       
        % compute ERP analysis
        cfg = [];
        ERPfile = ft_timelockanalysis(cfg, dataFIC);
        saveNameFIC = sprintf('%s/%s_dataERP_bin%d.mat',FieldtripERPdir,subName,binOfInt);
        save(saveNameFIC, 'dataFIC');
    end
end
clearvars -global
clear all

binnames = [1 2 3 4];
for bin1 = 1:4
    binOfInt=binnames(bin1);
    parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedLoc/12_40'; 
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    fileList = dir(fullfile(parentfolder, '*ica_rej.set'));
    addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
    addpath('/Users/amnahyder/Research/DependentFiles')
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
        cfg.epochInt                = 1; % total post-stim interval in data file
        cfg.trialdef.prestim        = cfg.epochBaseInt + 0.01; %baseline to extract (need to leave 10 ms gap) Because cgf.epochBaseInt is minus, this needs to be a plus
        cfg.trialdef.poststim       = cfg.epochInt - 0.01 ; % epoch to extract (need to leave 10 ms gap)
        cfg = ft_definetrial(cfg);         
        dataFIC = ft_preprocessing(cfg);
       
        % compute ERP analysis
        cfg = [];
        ERPfile = ft_timelockanalysis(cfg, dataFIC);
        saveNameFIC = sprintf('%s/%s_dataERP_bin%d.mat',FieldtripERPdir,subName,binOfInt);
        save(saveNameFIC, 'dataFIC');
    end
end
clearvars -global
clear all
                
        
cfg = [];  % use only default options
ft_databrowser(cfg, dataFIC);


   


%% AVERAGE ACROSS SUBJECTS %%
%% LOCALIZER AVERAGING %%
%% Average across subjects with fieldtrip 

clear all
%% LOCALIZER AVERAGING %%
parentfolder = '/home/tipperlab/Desktop/socialBrainEEG/AmnaTFRLoc/ALLCLEAN'; 
cd(parentfolder)
outputDir = '/home/tipperlab/Desktop/socialBrainEEG/AmnaTFRLoc/Avg/';
addpath('/home/tipperlab/Desktop/socialBrainEEG/AmnaDependentFiles/DependentFiles');
addpath('/home/tipperlab/Documents/fieldtrip-20191028/');
fileList= dir(fullfile(parentfolder, '*.mat'));
ni=1;
for n = 1:length(fileList)
   FICorTFR = extractBefore(extractAfter(fileList(n).name,'_'),'_');
   if isequal(FICorTFR, 'TFR')
       FileListNew(ni).name= char(fileList(n).name);
       FileListNew(ni).bin = extractBefore(extractAfter(fileList(n).name,'bin'),'.mat');
       ni=1+ni;
   end
end

cfg = [];
cfg.keepindividual = 'yes';          
cfg.foilim         = 'all';          
cfg.toilim         = 'all' ;        
cfg.method         = 'within'
load('elec')
for ch=1:5
    channelType = char(channelTypes(ch));
    cfg.channel = channelSites{ch};
    for i = 1:4
        avPowspectrmList = {1,length(FileListNew)};
        bi=1;
        for subject = 1:length(FileListNew)
            subjnum = str2num(extractBefore(extractAfter(FileListNew(subject).name,'s'),'loc'));
            if subjnum <= 11
                BinNumbers = {'1' '2' '4' '5'}; 
                binnum= char(BinNumbers(i));
                subjbin = char(FileListNew(subject).bin);
                if isequal(subjbin, binnum)
                    avPowspectrmList{1,bi} = FileListNew(subject).name;
                    bi = bi +1;
                end
            elseif subjnum > 11
                BinNumbers = {'1' '2' '3' '4'};
                binnum= char(BinNumbers(i));
                subjbin = char(FileListNew(subject).bin);
                if isequal(subjbin, binnum)
                    avPowspectrmList{1,bi} = FileListNew(subject).name;
                    bi = bi +1;
                end
            end
        end
        cd(parentfolder);
        cfg.inputfile   = avPowspectrmList; 
        [avgERP] = ft_timelockgrandaverage(cfg);
        avgERP.elec = elec;
        saveName= [outputDir 'avgERP' binnum channelType '.mat'];
        save(saveName, 'avgERP', '-v7.3'); 
        clear avPowspectrmList
    end
end
clear all

