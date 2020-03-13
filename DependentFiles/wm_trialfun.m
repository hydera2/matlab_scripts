function [trl, event] = wm_trialfun(cfg);

hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset);

indx=[];
if cfg.binNumber
    for i = 1:size(event,2)
    if ismember(cfg.binNumber,event(i).bini)
    indx=[indx;1];
    else indx=[indx;0];
    end
    end
    ind = find(indx);
    sample = [event(ind).sample]';
else
    sample = [event(find(strcmp(cfg.codeLabel, {event.codelabel}))).sample]';
end

epochBaseSamples = -1*cfg.epochBaseInt*hdr.Fs;
epochSamples = cfg.epochInt*hdr.Fs;
epochTotal = epochBaseSamples + epochSamples;
epochStarts = [1:epochTotal:sample(end)];
eventStarts = epochStarts + epochBaseSamples;

sampleGood = intersect(sample,eventStarts);

pretrig  = -round(cfg.trialdef.prestim  * hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * hdr.Fs);

% define the trials
trl = [];
trl(:,1) = sampleGood - pretrig;  % start of segment
trl(:,2) = sampleGood + posttrig; % end of segment
trl(:,3) = -pretrig; % offset of trigger
%trl(:,3) = pretrig; % how many samples prestimulus