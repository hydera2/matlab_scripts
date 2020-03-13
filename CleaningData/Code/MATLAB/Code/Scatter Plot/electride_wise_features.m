
[nsubj, nfeatures] = size(features)
feat=[];
nFeatperElec = 30;
j=1;
for j=1:nsubj
    for i=0:nfeatures-1
        elec = floor(i/nFeatperElec)+1;
        nfeat = rem(i+1,nFeatperElec);
        if(nfeat ==0)
            nfeat = nFeatperElec;
        end
        feat{j}(elec,nfeat) = features(j,i+1);
    end
end