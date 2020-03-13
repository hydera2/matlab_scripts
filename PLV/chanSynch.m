

function [channels, symmetric_PLV]=chanSynch(PhaseLockingObjCont, numchannel)
[symmetric_PLV]=symPLV(PhaseLockingObjCont, numchannel);
channels=zeros(1,numchannel);
    for c=1:numchannel
        channels(1,c)=sum(symmetric_PLV(c,:))/(numchannel-1);
    end
end
