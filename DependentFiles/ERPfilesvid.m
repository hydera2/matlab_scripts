%% POINT TO DATA AND FILE LOCATIONS %%
clear all
addpath('/Users/amnahyder/Research/MATLAB/eeglab2019_0');
addpath(genpath('/Users/amnahyder/Research/DependentFiles'));
eeglab
%make sure that the sfp file is in the specified folder
DependentFiles='/Users/amnahyder/Research/DependentFiles';
parentfolder = '/Users/amnahyder/Research/AmnaPreProcessedVid/';
outputfolder = '/Users/amnahyder/Research/AmnaVideoERP/';

%% GET ALL THE SUBJECTS FROM FOLDER %%
%change to .mff if you want to load mff files
fileList = dir(fullfile(parentfolder, '*_ica_rej.set'));
numsubjects=length(fileList)
ALLERP = buildERPstruct([]);
CURRENTERP = 0;


 for s=26:29
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '_'))
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    EEG = pop_loadset('filename',subject,'filepath',parentfolder);
    ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
    subjectsavename = [num2str(subjname) '.erp']
    ERP = pop_savemyerp(ERP, 'erpname', num2str(subjname), 'filename', subjectsavename, 'filepath', outputfolder, 'Warning', 'on');
 end
 
 
 
 %% CREATE NEW BINS %% 
clear all
parentfolder = '/Users/amnahyder/Research/AmnaVideoERP/';
outputfolder = '/Users/amnahyder/Research/AmnaVideoERP/ERPBinUPDATE/';
fileList = dir(fullfile(parentfolder, '*.erp'));
numsubjects=length(fileList)
ALLERP = buildERPstruct([]);
CURRENTERP = 0;

for s=1:10
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '.'));
    ERP = pop_loaderp( 'filename', subject, 'filepath', parentfolder);
    savefilename = [subjname '_new.erp'];
    ERP = pop_binoperator( ERP, '/Users/amnahyder/Research/AmnaVideoERP/listname1_10.txt');
    ERP = pop_savemyerp(ERP, 'erpname', subjname, 'filename', savefilename, 'filepath', outputfolder, 'Warning', 'on');
end

 %% CREATE NEW BINS %% 
clear all
parentfolder = '/Users/amnahyder/Research/AmnaVideoERP/';
outputfolder = '/Users/amnahyder/Research/AmnaVideoERP/ERPBinUPDATE/';
fileList = dir(fullfile(parentfolder, '*.erp'));
numsubjects=length(fileList)
ALLERP = buildERPstruct([]);
CURRENTERP = 0;

for s=11:numsubjects
    subject = fileList(s).name;
    subjname = char(extractBefore(subject, '.'));
    ERP = pop_loaderp( 'filename', subject, 'filepath', parentfolder);
    savefilename = [subjname '_new.erp'];
    ERP = pop_binoperator( ERP, '/Users/amnahyder/Research/AmnaVideoERP/listname11up.txt');
    ERP = pop_savemyerp(ERP, 'erpname', subjname, 'filename', savefilename, 'filepath', outputfolder, 'Warning', 'on');
end