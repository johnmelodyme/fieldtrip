function test_tutorial_multivariateanalysis(datadir, dmltdir)

% TEST test_tutorial_multivariateanalysis
% TEST ft_timelockstatistics ft_topoplotER ft_freqstatistics ft_topoplotTFR

% this is a test script that I made following the report of Matt on
% http://bugzilla.fcdonders.nl/show_bug.cgi?id=1585 and realizing that the
% wiki page http://fieldtrip.fcdonders.nl/tutorial/multivariateanalysis was
% not included in a test script.

% This test script corresponds to the documentation on the wiki from 3 July 2012

if nargin==0
  datadir = '/home/common/matlab/fieldtrip/data/ftp/tutorial/classification';
<<<<<<< HEAD
<<<<<<< HEAD
  dmltdir = '/home/common/matlab/fieldtrip/external/dmlt';
=======
  dmltdir = '/home/commont/matlab/fieldtrip/external/dmlt';
>>>>>>> enhancement - tested tutorials under Windows for Nijmegen toolkit, made some updates to allow for non-default file locations
=======
  dmltdir = '/home/common/matlab/fieldtrip/external/dmlt';
>>>>>>> bugfix - fixed typo in default path assignment
end

addpath(genpath(dmltdir));

filename = dccnfilename(fullfile(datadir, 'covatt'));
load(filename);

cfg             = [];
cfg.parameter   = 'trial';
cfg.keeptrials  = 'yes'; % classifiers operate on individual trials
cfg.channel     = {'MLO' 'MRO'}; % occipital channels only

tleft   = ft_timelockanalysis(cfg,left);
tright  = ft_timelockanalysis(cfg,right);

cfg         = [];
cfg.layout  = 'CTF275.lay';
cfg.method  = 'crossvalidate';

cfg.design  = [ones(size(tleft.trial,1),1); 2*ones(size(tright.trial,1),1)]';
cfg.latency = [2.0 2.5]; % final bit of the attention period
stat = ft_timelockstatistics(cfg,tleft,tright);

disp(stat.statistic)

% this is the part that Matt mentioned in bug 1585
cfg.statistic = {'accuracy' 'binomial' 'contingency'};

stat = ft_timelockstatistics(cfg,tleft,tright);

disp(stat.statistic.contingency)

stat.mymodel = stat.model{1}.primal;

cfg              = [];
cfg.parameter    = 'mymodel';
cfg.layout       = 'CTF275.lay';
cfg.xlim         = [2.0 2.5];
cfg.comments     = '';
cfg.colorbar     = 'yes';
cfg.interplimits = 'electrodes';
ft_topoplotER(cfg,stat);

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 8:2:14;
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;
cfg.channel      = {'MLO' 'MRO'};
cfg.toi          = 2.0:0.1:2.5;
cfg.keeptrials   = 'yes'; % classifiers operate on individual trials

tfrleft          = ft_freqanalysis(cfg, left);
tfrright         = ft_freqanalysis(cfg, right);

cfg         = [];
cfg.layout  = 'CTF275.lay';
cfg.method  = 'crossvalidate';
cfg.design  = [ones(size(tfrleft.powspctrm,1),1); 2*ones(size(tfrright.powspctrm,1),1)]';
stat        = ft_freqstatistics(cfg,tfrleft,tfrright);

disp(stat.statistic)

stat.mymodel = stat.model{1}.primal;

cfg              = [];
cfg.layout       = 'CTF275.lay';
cfg.parameter    = 'mymodel';
cfg.comment      = '';
cfg.colorbar     = 'yes';
cfg.interplimits = 'electrodes';
ft_topoplotTFR(cfg,stat);

cfg         = [];
cfg.layout  = 'CTF275.lay';
cfg.method  = 'crossvalidate';
cfg.design  = [ones(size(tfrleft.powspctrm,1),1); 2*ones(size(tfrright.powspctrm,1),1)]';
cfg.mva     = {dml.standardizer dml.enet('family','binomial','alpha',0.2)};

stat = ft_freqstatistics(cfg,tfrleft,tfrright);

disp(stat.statistic)

stat.mymodel     = stat.model{1}.weights;

cfg              = [];
cfg.layout       = 'CTF275.lay';
cfg.parameter    = 'mymodel';
cfg.comment      = '';
cfg.colorbar     = 'yes';
cfg.interplimits = 'electrodes';
ft_topoplotTFR(cfg,stat);
