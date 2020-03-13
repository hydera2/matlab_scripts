function data = removeArtifactsBESA(besa_channels)
srate = besa_channels.samplingrate;
strt = 1;
stp = srate*3;


%clean the first three seconds
data.amplitudes = besa_channels.amplitudes;
besa_channels.amplitudes(1:3*srate,:)=nan;

fac = besa_channels.latencies(2) -  besa_channels.latencies(1);
flag=1;
for i=1:length(besa_channels.events)
    stp = size(besa_channels.amplitudes,1);
    if (strcmp(besa_channels.events(i).type,'ArtifactOn') && flag == 1)
        ind =  floor(besa_channels.events(i).latency/fac)-10;
        strt = ind(1);
        flag =2;
    end
    
    if (strcmp(besa_channels.events(i).type,'ArtifactOff') && flag==2)
%         ind =  find(besa_channels.latencies >= besa_channels.events(i).latency);
        ind =  ceil(besa_channels.events(i).latency/fac)+10;
        stp = ind(1);
        if(stp > size(besa_channels.amplitudes,1))
            stp = size(besa_channels.amplitudes,1);
        end
        flag =1;
        [strt stp]
        
        besa_channels.amplitudes(strt:stp,:)=nan;
    end
end
[strt stp]
besa_channels.amplitudes(strt:stp,:)=nan;
data.amplitudes = besa_channels.amplitudes;
data.amplitudes( any(isnan(besa_channels.amplitudes),2),:) = [];