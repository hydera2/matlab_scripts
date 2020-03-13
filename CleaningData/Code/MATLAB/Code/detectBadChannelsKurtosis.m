function [kurto, rej] = detectBadChannelsKurtosis( signal, threshold, oldkurtosis, normalize)
	
if nargin < 2
	threshold = 0;
end;	
if nargin < 4
	normalize = 0;
end;	
if nargin < 3
	oldkurtosis = [];
end;	

if size(signal,2) == 1 % transpose if necessary
	signal = signal';
end;

nbchan = size(signal,1);
pnts = size(signal,2);
sweeps = size(signal,3);
kurto = zeros(nbchan,sweeps);

if ~isempty( oldkurtosis ) % speed up the computation
	kurto = oldkurtosis;
else
	for rc = 1:nbchan
		% compute all kurtosis
		% --------------------
		for index=1:sweeps
			try 
			    kurto(rc, index) = kurtosis(signal(rc,:,index));
			catch
				kurto(rc, index) = kurt(signal(rc,:,index));
			end;	
		end;
	end;

	% normalize the last dimension
	% ----------------------------	
	if normalize
        tmpkurt = kurto;
        if normalize == 2,
            tmpkurt = sort(tmpkurt);
            minind  = max(round(length(tmpkurt)*0.1),1);
            maxind  = round(length(tmpkurt)-round(length(tmpkurt)*0.1));
            if size(tmpkurt,2) == 1
                 tmpkurt = tmpkurt(minind:maxind);
            else tmpkurt = tmpkurt(:,minind:maxind);
            end;
        end;
	    switch ndims( signal )
	    	case 2,	kurto = (kurto-mean(tmpkurt)) / std(tmpkurt);
	    	case 3,	kurto = (kurto-mean(tmpkurt,2)*ones(1,size(kurto,2)))./ ...
				        (std(tmpkurt,0,2)*ones(1,size(kurto,2)));
		end;
	end;
end;

% reject
% ------	
if threshold(1) ~= 0 
    if length(threshold) > 1
    	rej = (threshold(1) > kurto) | (kurto > threshold(2));
    else
    	rej = abs(kurto) > threshold;
    end;
else
	rej = zeros(size(kurto));
end;	

return;
