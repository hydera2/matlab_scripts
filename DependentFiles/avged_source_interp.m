%% Script for doing Source Reconstruction on averaged sources %%

addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
ft_defaults

load('/Users/amnahyder/Research/Source/avgSource_loc/avgsource1.mat')
c1= avgERP;
load('/Users/amnahyder/Research/Source/avgSource_loc/avgsource2.mat')
c2= avgERP;
load('/Users/amnahyder/Research/Source/avgSource_loc/avgsource3.mat')
c3= avgERP;
load('/Users/amnahyder/Research/Source/avgSource_loc/avgsource4.mat')
c4= avgERP;
load('/Users/amnahyder/Research/DependentFiles/Subject01_leadfield.mat')


% Need to move tri object from a single subject
c1.tri = leadfield.tri;
c2.tri = leadfield.tri;
c3.tri = leadfield.tri;
c4.tri = leadfield.tri;

cfg = [];
cfg.projectmom = 'yes';
sdC1  = ft_sourcedescriptives(cfg, c1);
sdC2 = ft_sourcedescriptives(cfg, c2);
sdC3 = ft_sourcedescriptives(cfg, c3);
sdC4 = ft_sourcedescriptives(cfg, c4);
%  1           "howF"    []                   ""
%     2           "howH"    []                   ""
%     3           "whyF"    []                   ""
%     4           "whyH"    []                   ""

sdDIFF         = c3;
sdDIFF.pow = c3.pow;%-c4.pow;%(c1.pow + c2.pow)/2-(c3.pow + c4.pow)/2;%c2.pow; %
%3 is higher in frontal and 1 is higher in occipital

cfg = [];
cfg.funparameter = 'pow';
%cfg.xparam = 0.01;
%cfg.time = ['0.3'];
cfg.atlas = '/Users/amnahyder/Downloads/fieldtrip-20181231/template/atlas/aal/ROI_MNI_V4.nii';
ft_volumelookup(cfg,sdDIFF);
ft_sourcemovie(cfg,sdDIFF);




% cfg = [];
% cfg.method          = 'surface';
% cfg.funparameter    = 'pow';
% %cfg.funcolormap     = [min max];
% cfg.latency         = [.092];
% %cfg.avgovertime     = 'yes';
% cfg.colorbar        = 'yes';
% cfg.funcolorlim   = [0 40];
% cfg.opacitylim = [20 40];
% cfg.projthresh = [20];
% cfg.threshold = [-40];
% ft_sourceplot(cfg, c1)
% 
% %% Check if we can slice
% addpath('/Users/nkhaja/Documents/fieldtrip/');
% ft_defaults
% 
% 
% load('/Users/nkhaja/Documents/s04loc_dataERP_bin1.mat')
% 
% mri = ft_read_mri('/Users/nkhaja/Downloads/Subject01.mri');
% 
% cfg = [];
% mri = ft_volumereslice(cfg, mri);
% 
% cfg            = [];
% cfg.downsample = 2;
% cfg.parameter  = 'pow';
% sourceDiffInt  = ft_sourceinterpolate(cfg, sourceDiff , mri);
% 
% 
% % spatially normalize the anatomy and functional data to MNI coordinates
% % cfg = [];
% % cfg.nonlinear = 'no';
% % sourceDiffIntNorm = ft_volumenormalise(cfg, sourceDiffInt);
% 
% 
% cfg = [];
% cfg.method        = 'surface';
% cfg.funparameter  = 'pow';
% cfg.maskparameter = cfg.funparameter;
% cfg.funcolorlim   = [0.0 1.2];
% cfg.threshold    = [0.0 40];
% cfg.latency         = [.30];
% cfg.opacitymap    = 'rampup';
% ft_sourceplot(cfg, c2)
% 
