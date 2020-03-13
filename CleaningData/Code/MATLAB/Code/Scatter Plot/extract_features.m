function feature=extract_features(besa_output, elect_num,waveletFunction)
            [C,L] = wavedec(besa_output(:,elect_num),8,waveletFunction);
            % Calculation The Coificients Vectors
            cD1 = detcoef(C,L,1);                   %NOISY
            cD2 = detcoef(C,L,2);                   %NOISY
            cD3 = detcoef(C,L,3);                   %NOISY
            cD4 = detcoef(C,L,4);                   %NOISY
            cD5 = detcoef(C,L,5);                   %GAMA
            cD6 = detcoef(C,L,6);                   %BETA
            cD7 = detcoef(C,L,7);                   %ALPHA
            cD8 = detcoef(C,L,8);                   %THETA
            cA8 = appcoef(C,L,waveletFunction,8);   %DELTA
            %%%% Calculation the Details Vectors and Approximate vectors
            D1 = wrcoef('d',C,L,waveletFunction,1); %NOISY
            D2 = wrcoef('d',C,L,waveletFunction,2); %NOISY
            D3 = wrcoef('d',C,L,waveletFunction,3); %NOISY
            D4 = wrcoef('d',C,L,waveletFunction,4); %NOISY
            D5 = wrcoef('d',C,L,waveletFunction,5); %GAMMA
            D6 = wrcoef('d',C,L,waveletFunction,6); %BETA
            D7 = wrcoef('d',C,L,waveletFunction,7); %ALPHA
            D8 = wrcoef('d',C,L,waveletFunction,8); %THETA
            A8 = wrcoef('a',C,L,waveletFunction,8); %DELTA
            count=1;
            % TODO: Normalize features
            %mean
%             feature(1,count)=mean(D1);count=count+1;
%             feature(1,count)=mean(D2);count=count+1;
%             feature(1,count)=mean(D3);count=count+1;
%             feature(1,count)=mean(D4);count=count+1;
            feature(1,count)=mean(D5);count=count+1;
            feature(1,count)=mean(D6);count=count+1;
            feature(1,count)=mean(D7);count=count+1;
            feature(1,count)=mean(D8);count=count+1;
            feature(1,count)=mean(A8);count=count+1;
            %std
%             feature(1,count)=std(D1);count=count+1;
%             feature(1,count)=std(D2);count=count+1;
%             feature(1,count)=std(D3);count=count+1;
%             feature(1,count)=std(D4);count=count+1;
            feature(1,count)=std(D5);count=count+1;
            feature(1,count)=std(D6);count=count+1;
            feature(1,count)=std(D7);count=count+1;
            feature(1,count)=std(D8);count=count+1;
            feature(1,count)=std(A8);count=count+1;
            %Energy/Power
%             feature(1,count)=sum(D1.^2);count=count+1;
%             feature(1,count)=sum(D2.^2);count=count+1;
%             feature(1,count)=sum(D3.^2);count=count+1;
%             feature(1,count)=sum(D4.^2);count=count+1;
            feature(1,count)=sum(D5.^2);count=count+1;
            feature(1,count)=sum(D6.^2);count=count+1;
            feature(1,count)=sum(D7.^2);count=count+1;
            feature(1,count)=sum(D8.^2);count=count+1;
            feature(1,count)=sum(A8.^2);count=count+1;
            %Num of zero crossings
            hzcd = dsp.ZeroCrossingDetector;
%             feature(1,count)=step(hzcd,D1);count=count+1;
%             feature(1,count)=step(hzcd,D2);count=count+1;
%             feature(1,count)=step(hzcd,D3);count=count+1;
%             feature(1,count)=step(hzcd,D4);count=count+1;
            feature(1,count)=step(hzcd,D5);count=count+1;
            feature(1,count)=step(hzcd,D6);count=count+1;
            feature(1,count)=step(hzcd,D7);count=count+1;
            feature(1,count)=step(hzcd,D8);count=count+1;
            feature(1,count)=step(hzcd,A8);count=count+1;
            
            %Shannon Entropy
            data = besa_output(:,elect_num);
            feature(1,count)=entropy(data);count=count+1;
end