%% RUN TO AVERAGE STEP 2 %%
% clear all
% %% LOCALIZER AVERAGING %%
%run sourceinterpall_vid.m
clear all
addpath('/Users/amnahyder/Research/DependentFiles');
addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
ft_defaults
parentfolder = '/Volumes/TOSHIBA_EXT/Source_video/SourceInterp/'
   
FieldtripERPdir = '/Volumes/TOSHIBA_EXT/Source_video/grandav/'

fileList= dir(fullfile(parentfolder, '*.mat'));
ni=1;
for n = 1:length(fileList)
   FileListNew(ni).name = fileList(n).name;
   FileListNew(ni).bin = extractBefore(extractAfter(fileList(n).name,'bin'),'.mat');
   ni=1+ni;
end
FileListNew(1)=[]

for i = 1:6
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
        BinNumbers = {'1' '2' '4' '5','6'}; 
        binnum= char(BinNumbers(i));
        subjbin = char(FileListNew(subject).bin);
        if isequal(subjbin, binnum)
            avPowspectrmList{1,bi} = FileListNew(subject).name;
            bi = bi +1;
        end
    end
    cd(parentfolder);
    cfg.inputfile   = avPowspectrmList; 
    cfg.parameter 	= 'avg.pow';
    [avgERP]        = ft_sourcegrandaverage(cfg);
    saveName= [FieldtripERPdir 'avgsource' binnum '.mat'];
    save(saveName, 'avgERP', '-v7.3'); 
    clear avPowspectrmList
    clear avgERP
    %clear avgERP2
end
% BIN1 = Means Peculiar On 
% BIN2 = Intention Peculiar On 
% BIN3 = Social Peculiar On
% BIN4 = Means Ordinary On 
% BIN5 = Intention Ordinary On 
% BIN6 = Social Ordinary On
