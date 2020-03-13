%% RUN TO AVERAGE STEP 2 %%
% clear all
% %% LOCALIZER AVERAGING %%
clear all
addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
addpath('/Users/amnahyder/Research/DependentFiles');
addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
ft_defaults
parentfolder = '/Volumes/Amnas_Data/socialBrainBackup/socialBrainEEG/AMNASOURCE/SourceInterp/'
   
FieldtripERPdir = '/Volumes/Amnas_Data/socialBrainBackup/socialBrainEEG/AMNASOURCE/grandav/'

fileList= dir(fullfile(parentfolder, '*.mat'));
ni=1;
for n = 1:length(fileList)
   FileListNew(ni).name = fileList(n).name;
   FileListNew(ni).bin = extractBefore(extractAfter(fileList(n).name,'bin'),'.mat');
   ni=1+ni;
end
FileListNew(1)=[]

for i = 1:4
    cfg = [];
    cfg.keepindividual = 'yes';          
%     cfg.foilim         = 'all';          
%     cfg.toilim         = 'all' ;        
%     cfg.channel        = 'all';
%     cfg.method         = 'within';
%    cfg.parameter      = 'avg';
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
    cfg.parameter 	= 'avg.pow';
    [avgERP]        = ft_sourcegrandaverage(cfg);
    saveName= [FieldtripERPdir 'avgsource' binnum '.mat'];
    save(saveName, 'avgERP', '-v7.3'); 

    %avgERP.elec = elec;
%     cfg = [];
%     cfg.keepindividual = 'yes';
%     cfg.foilim         = 'all';
%     cfg.toilim         = 'all' ;
%     cfg.channel        = 'all';
%     cfg.method         = 'within';
%     cfg.parameter      = 'avg';
%     cfg.inputfile   = avPowspectrmList; 
%     [avgERP2]          =  ft_timelockgrandaverage(cfg);
%     avgERP.individual = avgERP2.individual;
%     avgERP.dimord = avgERP2.dimord;
%     saveName= [FieldtripERPdir 'avgERP' binnum '.mat'];
%     save(saveName, 'avgERP', '-v7.3'); 
    clear avPowspectrmList
    clear avgERP
    %clear avgERP2
end

