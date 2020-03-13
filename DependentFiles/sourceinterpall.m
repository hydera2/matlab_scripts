%% Script for doing Source Reconstruction %%
clear all
clearvars -global
%keep headmodel and other files in dependent files folder
cd('/Users/amnahyder/Research/DependentFiles')
load('Subject01_sourcemodel_15684.mat')
load('vol.mat')
load('elec_new.mat')
load('Subject01_leadfield.mat')

addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
ft_defaults
parentfolder = '/Volumes/TOSHIBA_EXT/Source_video/';
savefolder = '/Volumes/TOSHIBA_EXT/Source_video/SourceInterp/';
%FieldtripERPdir = '/Volumes/Amnas_Data/socialBrainBackup/socialBrainEEG/AMNASOURCE/grandav/'
fileList= dir(fullfile(parentfolder, '*.mat'));
fileList(1)= []
for n = 1:length(fileList)
    load([parentfolder fileList(n).name]);
    ERPfile.elec = elec_new;
    cfg               = [];
    cfg.method        = 'mne';
    cfg.grid          = leadfield;
    cfg.headmodel     = vol;
    cfg.mne.prewhiten = 'yes';
    cfg.mne.lambda    = 3;
    cfg.mne.scalesourcecov = 'yes';
    sourceFC          = ft_sourceanalysis(cfg,ERPfile);
    savename          = [savefolder fileList(n).name]
    save(savename, 'sourceFC');
end
% m=sourceFC.avg.pow(:,450); % plotting the result at the 450th time-point that is
%                      % 500 ms after the zero time-point
% 
% ft_plot_mesh(sourceFC, 'vertexcolor', m);
% view([180 0]); h = light; set(h, 'position', [0 1 0.2]); lighting gouraud; material dull
% cfg = [];
% cfg.projectmom = 'yes';
% sdFC  = ft_sourcedescriptives(cfg,sourceFC);
% cfg = [];
% cfg.funparameter = 'pow';
% ft_sourcemovie(cfg,sdFC);