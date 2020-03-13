function [features, count, age, files] = feature_extraction(listdir, parts)
% This function takes input as list of directories and calculate features
% of the subjects in it
% Input:
%      dir : list of directories (should be in cell format)

E= ['E01'; 'E02'; 'E03'; 'E04'; 'E05'; 'E06'; 'E07'; 'E08'; 'E09'; 'E10'; 'E11'; 'E12'; 'E13'; 'E14'; 'E15'; 'E16'; 'E17'; 'E18'; 'E19'; 'E20';
    'E21'; 'E22'; 'E23'; 'E24'; 'E25'; 'E26'; 'E27'; 'E28'; 'E29'; 'E30'; 'E31'; 'E32'; 'E33'; 'E34'; 'E35'; 'E36'; 'E37'; 'E38'; 'E39'; 'E40';
    'E41'; 'E42'; 'E43'; 'E44'; 'E45'; 'E46'; 'E47'; 'E48'; 'E49'; 'E50';'E51'; 'E52'; 'E53'; 'E54'; 'E55'; 'E56'; 'E57'; 'E58'; 'E59'; 'E60';
    'E61'; 'E62'; 'E63'; 'E64'];

if(~exist('parts'))
    parts = 1;
end
waveletFunction = 'db8'; % waveletFunction = 'db8'  'sym8' ;
waveFeats=[];
powerSpecFeats=[];
subject_order = [];

addpath('/home/eeglewave/Documents/MATLAB/eeglab13_6_5b');
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
subj_num=1;
count=[];
age_count=0;
age=[];
files=[];

close all;

for i=1:length(listdir)
    directory = char(listdir(i));
    count(i)=0;

    [list_dir]=dir(directory);
    
    % For each subject
    for file = list_dir'
        if(strcmp(file.name, '.') == 0 && strcmp(file.name,'..') == 0 && strcmp(file.name, 'desktop.ini') == 0 && strcmp(file.name, '$Recycle.Bin') == 0 && strcmp(file.name, 'Config.Msi') == 0 && strcmp(file.name, 'ScalpPlotData') == 0)

            %Get the age of the subject
            age_count= age_count+1;
            file_addr = strcat(directory, '/', file.name, '/*.txt')
            txt_age = dir(file_addr);
            % Assume that the age text file is the first text file found
            if(~isempty(txt_age))
            [pathStr,fname,ext] = fileparts(txt_age(1).name);
            if(~isempty(txt_age))
                age(age_count) = (str2num( fname ));
            end
             
            %get the features
            files{age_count} = file.name;
            fprintf('Now on: %s...\n', file.name);
            %reading filename from the besa saved output
            file_addr = strcat(directory, '/', file.name, '/matlab.mat');
            S2=load(file_addr);
            if (isfield(S2,'besa_channels_all'))
                besa_output = S2.besa_channels_all.amplitudes;
                save(file_addr, 'besa_output');
            else
                besa_output=eval(strcat('S2.',char(fieldnames(S2))));
            end
            %% This is only for test
%             besa_output = besa_output';
            input = besa_output;
            diff = size(besa_output,1)/parts;
            for p=1:parts               
                count(i)= count(i)+1;
                besa_output = input(1+(p-1)*diff:p*diff,:);
                %test ends
                [rows, NumOfElectrodes]=size(besa_output);
                colstart=0;
                
                for j = 1:NumOfElectrodes
                    %Feature computation
                    feature = extract_features(besa_output,j, waveletFunction);
                    [rows, cols] = size(feature);
                    waveFeats(subj_num,colstart+1:colstart+cols)=feature;
                    %features(subj_num).E(j,:) = feature;
                    colstart = colstart+cols;
                end
                EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',file_addr,'srate',250,'pnts',0,'xmin',0);
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',file.name,'gui','off');
                
                fprintf('buildPowerSpecFeats...\n');
                feature = buildPowerSpecFeats_spectrumonly(EEG);
                [rows, cols] = size(feature);
                powerSpecFeats=[powerSpecFeats; feature];
                fprintf('Moving on...\n');
                subj_num=subj_num+1;
            end
            end % end of parts loop
        end
    end
end

powerSpecFeats_ordered = electrode_first_order(powerSpecFeats,27);
new_powerSpecFeats = add_ratios(powerSpecFeats_ordered,5);

features= [new_powerSpecFeats, waveFeats];

%Noramalize each feauture vector

% [rows, cols]=size(features);
% for i=1:cols
%     mn=mean(features(:,i));
%     sd=std(features(:,i));
%     features(:,i)=(features(:,i)-mn)/sd;
% end

end
