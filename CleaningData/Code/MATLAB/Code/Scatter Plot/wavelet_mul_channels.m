clear; clc
% WAVELET FUNCTIONS + order of wavelet
%  Daubechies: 'db1' or 'haar', 'db2', ... ,'db45'
%     Coiflets  : 'coif1', ... ,  'coif5'
%     Symlets   : 'sym2' , ... ,  'sym8', ... ,'sym45'
%     Discrete Meyer wavelet: 'dmey'
%     Biorthogonal:
%         'bior1.1', 'bior1.3' , 'bior1.5'
%         'bior2.2', 'bior2.4' , 'bior2.6', 'bior2.8'
%         'bior3.1', 'bior3.3' , 'bior3.5', 'bior3.7'
%         'bior3.9', 'bior4.4' , 'bior5.5', 'bior6.8'.
%     Reverse Biorthogonal: 
%         'rbio1.1', 'rbio1.3' , 'rbio1.5'
%         'rbio2.2', 'rbio2.4' , 'rbio2.6', 'rbio2.8'
%         'rbio3.1', 'rbio3.3' , 'rbio3.5', 'rbio3.7'
%         'rbio3.9', 'rbio4.4' , 'rbio5.5', 'rbio6.8'.



E= ['E01'; 'E02'; 'E03'; 'E04'; 'E05'; 'E06'; 'E07'; 'E08'; 'E09'; 'E10'; 'E11'; 'E12'; 'E13'; 'E14'; 'E15'; 'E16'; 'E17'; 'E18'; 'E19'; 'E20';
    'E21'; 'E22'; 'E23'; 'E24'; 'E25'; 'E26'; 'E27'; 'E28'; 'E29'; 'E30'; 'E31'; 'E32'; 'E33'; 'E34'; 'E35'; 'E36'; 'E37'; 'E38'; 'E39'; 'E40'; 
    'E41'; 'E42'; 'E43'; 'E44'; 'E45'; 'E46'; 'E47'; 'E48'; 'E49'; 'E50';'E51'; 'E52'; 'E53'; 'E54'; 'E55'; 'E56'; 'E57'; 'E58'; 'E59'; 'E60'; 
    'E61'; 'E62'; 'E63'; 'E64'];
waveletFunction = 'db8' ; % waveletFunction = 'db8'  'sym8' ;
kfold=5;
testeval=[];
features=[];
waveFea=[];

fprintf('\n Starting Controls...\n');

subj_num=1;

control_directory = 'C:\Users\ayeung\Documents\EEG\EEG Data\New Data\Controls';
[controls_dir]=dir(control_directory);
% For each subject
for file = controls_dir'
    if(strcmp(file.name, '.') == 0 && strcmp(file.name,'..') == 0 && strcmp(file.name, 'desktop.ini') == 0)
        
        fprintf('Now on: %s...\n', file.name);
        %reading filename from the besa saved output
        S2=load(strcat(control_directory, '\', file.name, '\matlab.mat'));
        besa_output=eval(strcat(strcat('S2.control_',file.name),'_x'));
        [rows, NumOfElectrodes]=size(besa_output);
        colstart=0;
        for j = 1:NumOfElectrodes
            %Feature computation
            feature = extract_features_ratios(besa_output,j, waveletFunction);
            [rows, cols] = size(feature);
            features(subj_num,colstart+1:colstart+cols)=feature;
            waveFea(subj_num).E(j,:) = feature;
            colstart = colstart+cols;
        end
        labels(subj_num,:)=1;
        subj_num=subj_num+1;
    end
end

fprintf('\n Starting Concussed...\n');

concuss_directory = 'C:\Users\ayeung\Documents\EEG\EEG Data\New Data\Concussion';
[concussion_dir]=dir(concuss_directory);
for file = concussion_dir'
    % waveletFunction = 'db8'  'sym8'
    if(strcmp(file.name, '.') == 0 && strcmp(file.name,'..') == 0 && strcmp(file.name, 'desktop.ini') == 0)
        
        fprintf('Now on: %s...\n', file.name);
        %reading filename from the besa saved output
        S1=load(strcat(concuss_directory, '\', file.name, '\matlab.mat'));
        besa_output=eval(strcat(strcat('S1.concussed_',file.name),'_x'));
        [rows, NumOfElectrodes]=size(besa_output);
        colstart=0;
        for j = 1:NumOfElectrodes
            %Feature computation
            feature = extract_features_ratios(besa_output,j, waveletFunction);
            [rows, cols] = size(feature);
            features(subj_num,colstart+1:colstart+cols)=feature;
            colstart = colstart+cols;
            waveFea(subj_num).E(j,:) = feature;
        end
        labels(subj_num,:)=2;
        subj_num=subj_num+1;
    end
end


fprintf('\n Starting Shaun...\n');

shaun_directory = 'C:\Users\ayeung\Documents\EEG\EEG Data\New Shaun Data';
[shaun_dir]=dir(shaun_directory);
for file = shaun_dir'
    % waveletFunction = 'db8'  'sym8'
    if(strcmp(file.name, '.') == 0 && strcmp(file.name,'..') == 0 && strcmp(file.name, 'desktop.ini') == 0)
        
        fprintf('Now on: %s...\n', file.name);
        %reading filename from the besa saved output
         S3=load(strcat(shaun_directory, '\', file.name, '\matlab.mat'));
        besa_output=eval(strcat(strcat('S3.concussed_',file.name),'_x'));
        [rows, NumOfElectrodes]=size(besa_output);
        colstart=0;
        for j = 1:NumOfElectrodes
            %Feature computation
            feature = extract_features_ratios(besa_output,j, waveletFunction);
            [rows, cols] = size(feature);
            features(subj_num,colstart+1:colstart+cols)=feature;
            colstart = colstart+cols;
            waveFea(subj_num).E(j,:) = feature;
        end
        labels(subj_num,:)=2;
        subj_num=subj_num+1;
    end
end
%}

%Noramalize each feauture vector
[rows, cols]=size(features);
for i=1:cols
    mn=mean(features(:,i));
    sd=std(features(:,i));
    features(:,i)=(features(:,i)-mn)/sd;
end

fprintf('\nData normalized...\n');

%{
%k fold cross-validation
indices = crossvalind('Kfold',labels,kfold);
for i = 1:kfold
    test = (indices == i); train = ~test;
    SVMStruct  = svmtrain (features(train,:), labels(train,:));
    out_labels  = svmclassify(SVMStruct, features(test,:));
    true_labels=labels(test,:);
    testeval = [testeval sum(abs(true_labels-out_labels))];
end
%}
fprintf('K fold cross-validation completed...\n');