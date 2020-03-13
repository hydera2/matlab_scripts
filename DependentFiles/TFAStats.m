%statistics on time frequency
avgTFRList = []; 
parentfolder = '/Volumes/Amnas Data/socialBrainBackup/socialBrainEEG/socialBrainData_adults/timeFreqAnalysis/videoOutput';
fileList = dir(fullfile(parentfolder, 's*'));
for s = 1:length(fileList)
    subject = fileList(s).name;
    subjname = char(extractAfter(subject, '_'));
    if startsWith(subjname,'T')
        avgTFRList{1, end+1} = subject;
    end
end


cfg = [];
cfg.channel          = {'E40'}; %put in different channels here
cfg.latency          = [0 1.8];
cfg.frequency        = 20;
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 500;
% specifies with which sensors other sensors can form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, GA_TFRFC);

subj = 10;
design = zeros(2,2*subj);
for i = 1:subj
design(1,i) = i;
end
for i = 1:subj
design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design   = design;
cfg.uvar     = 1;
cfg.ivar     = 2;

[stat] = ft_freqstatistics(cfg, GA_TFRFIC, GA_TFRFC)