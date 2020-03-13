
function [symPLV] = symPLV(PhaseLockingObjCont, numchannel)
    symPLV=zeros(numchannel,numchannel);
    for i=1:numchannel
        for j=1:numchannel
            if j==i
                symPLV(i,j)=0;
            elseif ~isnan(PhaseLockingObjCont.PLV(i,j)) 
                symPLV(i,j)=PhaseLockingObjCont.PLV(i,j);
            elseif isnan(PhaseLockingObjCont.PLV(i,j)) && ~isnan(PhaseLockingObjCont.PLV(j,i))
                symPLV(i,j)=PhaseLockingObjCont.PLV(j,i);
            end
        end
    end
end
