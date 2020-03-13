%% MICROSTATE ANAlYSIS %%
clear;
close all;
cd('/Users/amnahyder/Research/MATLAB/brainstorm3');
brainstorm;
PATHIN  = fullfile('/Users/amnahyder/Research/TestFiles/ERPsInd/');      % path containing rawdata                   
PATHOUT = fullfile('/Users/amnahyder/Research/TestFiles/OUTPUT/');  % path for script output

ProtocolInfo = bst_get('ProtocolInfo'); 
Path_bs = [ProtocolInfo.STUDIES filesep];

%Video Bins 31=ALLordinary, 30=ALLPeculiar, 24=MeansPeculiar, 25=IntentionPeculiar,
%26=SocialPeculiar, 27=MeansOrdinary, 28=IntentionOrdinary,
%29=SocialOrdinary
%elec_file = fullfile('/Users/amnahyder/Research/DependentFiles','projected_channels.sfp')
elec_file = fullfile('/Users/amnahyder/Research/MATLAB/brainstorm3/defaults/eeg/ICBM152/channel_GSN_HydroCel_256_E1.mat')
% specific brainstorm variable used for all processes
sFiles = [];

cd(PATHIN)
list=dir('*.erp');   
% list=dir('*.set');
%Video Bins 31=ALLordinary, 30=ALLPeculiar, 24=MeansPeculiar, 25=IntentionPeculiar,
%26=SocialPeculiar, 27=MeansOrdinary, 28=IntentionOrdinary,
%29=SocialOrdinary
% nbin1 = peculiar means b8                            
% nbin2 = peculiar intent + social (b9+b10)/2                    
% nbin3 = peculiar all (b8+b9+b10)/3                 
% nbin4 = ordinary means b11                           
% nbin5 = ordinary intent + social (b12+b13)/2                   
% nbin6 = ordinary all (b11+b12+b13)/3               
% nbin7 = peculiar minus ordinary (b8+b9+b10)/3 -(b11+b12+b13)/3
% nbin8 = ALL averaged (b8+b9+b10+b11+b12+b13)/6     


len=length(list);   
for s = 1:len
    subj{s} = strrep(list(s).name, list(s).name(4:end), '');
    % start a new report
    bst_report('Start', sFiles);
    
    % process: Import MEG/EEG: Existing epochs
    sFiles = bst_process('CallProcess', 'process_import_data_epoch', ...
        sFiles, [], ...
        'subjectname',  subj{s}, ...
        'condition',    '', ...
        'datafile',     {{[PATHIN list(s).name ]}, 'EEG-ERPLAB'}, ...
        'iepochs',      [], ...
        'eventtypes',   '', ...
        'createcond',   0, ...
        'channelalign', 1, ...
        'usectfcomp',   1, ...
        'usessp',       1, ...
        'freq',         [], ...
        'baseline',     []);
    
    
    % Process: Set channel file
    sFiles = bst_process('CallProcess', 'process_import_channel', sFiles, [], ...
    'usedefault',   67, ...  % ICBM152: GSN 256
    'channelalign', 1, ...
    'fixunitsin',     1, ...
    'vox2ras',      1);
    sFiles = []
end