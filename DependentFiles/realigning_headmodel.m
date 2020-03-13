% fit electrode coordinates to an individual MRI according to the same
% fiducials (nasion, left & right preauricular points) in both systems
% http://www.fieldtriptoolbox.org/tutorial/headmodel_eeg_fem/
addpath('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/');
ft_defaults
load('/Users/amnahyder/Downloads/vol.mat')
mri = ft_read_mri('/Users/amnahyder/Research/MATLAB/Subject01.mri')
%mri = ft_read_mri('/Users/amnahyder/Downloads/Subject01/Subject01.mri')

elec = ft_read_sens('/Users/amnahyder/Research/MATLAB/fieldtrip-20191028/template/electrode/GSN-HydroCel-256.sfp')
% ensure that the electrode coordinates are in mm
elec = ft_convert_units(elec,'mm'); % should be the same unit as MRI
elec.label{1,1}='nasion';
elec.label{2,1}='lpa';
elec.label{3,1}='rpa';
% these are expressed in the coordinate system of the electrode position capture device
Nas = elec.chanpos(strcmp(elec.label, 'nasion'),:);
Lpa = elec.chanpos(strcmp(elec.label, 'lpa'),:);
Rpa = elec.chanpos(strcmp(elec.label, 'rpa'),:);
% %% try out new method %%
% cfg = [];
% cfg.method = 'spm';
% cfg.spmversion = 'spm12';
% cfg.coordys =
% cfg.viewresult = 'yes'
% cfg_comb = ft_volumerealign(cfg, eeg, fmri);
% %% end of new method 
mri.nasion = [90 61 105]
mri.lpa = [30 148 151]
mri.rpa = [143 148 151]
% determine the same marker locations in voxel coordinates, e.g. [57,127,15])
% find fiducials e.g. by using ft_sourceplot(cfg, mri) which plots a figure in which
% you can interactively select slices of the mri
% You can also use ft_volumerealign with cfg.interactive='yes' and obtain the fiducials from the output.cfg.fiducial

vox_Nas = mri.nasion;  % fiducials saved in mri structure
vox_Lpa = mri.lpa;
vox_Rpa = mri.rpa;

vox2head = mri.transform; % transformation matrix of individual MRI

% transform voxel indices to MRI head coordinates
head_Nas          = ft_warp_apply(vox2head, vox_Nas, 'homogenous'); % nasion
head_Lpa          = ft_warp_apply(vox2head, vox_Lpa, 'homogenous'); % Left preauricular
head_Rpa          = ft_warp_apply(vox2head, vox_Rpa, 'homogenous'); % Right preauricular

elec_mri.chanpos = [
  head_Nas
  head_Lpa
  head_Rpa
  ];
elec_mri.label = {'nasion', 'lpa', 'rpa'};
elec_mri.unit  = 'mm';

% coregister the electrodes to the MRI using fiducials
cfg = [];
cfg.method   = 'fiducial';
cfg.template = elec_mri;
cfg.elec     = elec;
cfg.warp = 'rigidbody';
cfg.target.pos(1,:) = head_Nas    % location of the nose
cfg.target.pos(2,:) = head_Lpa     % location of the left ear
cfg.target.pos(3,:) = head_Rpa     % location of the right ear
cfg.target.label    = {'nasion', 'lpa', 'rpa'}

cfg.fiducial = {'nasion', 'lpa', 'rpa'};
elec_new = ft_electroderealign(cfg);




%% OPTION 2 %% 
% interactively coregister the electrodes to the BEM head model
% this is a visual check and refinement step
load('elect_new.mat')
cfg = [];
cfg.method    = 'interactive';
cfg.elec      = elec_new;
cfg.headshape = vol.bnd(1);
elec_new = ft_electroderealign(cfg);
save('elec_new', 'elec_new')