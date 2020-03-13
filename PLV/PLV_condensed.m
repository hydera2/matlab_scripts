%we will be using the NBT toolbox so run the following code to make sure
%that it is installed make sure that you are in the correct folder when you
%call installNBT- you will need to swtich folders after;
installNBT
NBT

%This section of the code renames the files so that they are in the format
%that NBT needs for the phase locking value code. Start by importing all
%the names of the files that you have. This code will add PLV.S to the
%start and then end with the date 20170101 (you can change this) followed
%by .conc.mat. The conc specifies which group the data will be in;

nameconc = dir('*.mat');

%{ 
copy and paste the list of names in your folder - you can get them in the
 correct format on excel
%}

%make sure that the date is correct and that the your categorization is
%correct (ie concussed). This puts the filename in the appropriate NBT
%naming convention so it is ready in the next step


% ********** BLOCK 1 START **********%
startname='PLV.S';
endname='.20170101.conc.mat';
endInfoName='.20170101.conc_info.mat';
signal_namescont = cell(length(allfiles), 1);
signal_info_namescont = cell(length(allfiles), 1);
for i=1:length(allfiles) 
    all_files_char = char(allfiles{i,2});
    split_name = strsplit(all_files_char, '\');
        
    local_name = strsplit(split_name{end}, '.');
    newFileName = horzcat(startname, local_name{1},endname);
    newInfoFileName = horzcat(startname, local_name{1},endInfoName);
    
    signal_namescont{i,1} = newFileName;
    signal_info_namescont{i,1} = newInfoFileName;

    data_to_save = pythagorize(allfiles{i,1});
    [numtime, numchannel] = size(data_to_save);
    save(newFileName,  'data_to_save');
end
signal_namescont = char(signal_namescont);
signal_info_namescont = char(signal_info_namescont);

% ********** BLOCK 1 END **********%


% ********** BLOCK 2 START **********%
num_signals = size(signal_namescont,1);

%number of participants
ALLINFO_Conc=cell(num_signals,1);
ALLSIGNAL_Conc=cell(num_signals,1);


for i=1:num_signals
    filesignalconc=strcat(pwd, '/', signal_namescont(i,:));
    fileinfoconc=strcat(pwd, '/', signal_info_namescont(i,:));
    Signal=nbt_load_file(filesignalconc);
    load(fileinfoconc);
    ALLSIGNAL_Conc{i}=Signal;
    ALLINFO_Conc{i}=RawSignalInfo;
end

save('ALLSIGNAL_Conc','ALLSIGNAL_Conc');
save('ALLINFO_Conc','ALLINFO_Conc');

% ********** BLOCK 2 END **********%


% ********** BLOCK 3 START **********%

%need to load info files seperately; 
for i=1:num_signals
    % i=1:number of participants;
    infoname=strcat(signal_namescont(i,:));
    Signal=strcat(signal_namescont(i,:));
    
    load(infoname,'RawSignalInfo');
    ALLINFO_Conc{i}=RawSignalInfo;
    
    load(Signal,'RawSignal');
    ALLSIGNAL_Conc{i}=RawSignal;
end
save('ALLINFO_Conc','ALLINFO_Conc');
save('ALLSIGNAL_Conc','ALLSIGNAL_Conc');

% ********** BLOCK 3 END **********%

% ********** BLOCK 4 START **********%
num_frequency_bands = 8;
frequency_bands = [2 4 7 10 13 20 30 2; 4 7 10 13 20 30 45 40];

nbt_output = cell(numchannel, num_frequency_bands);
chan_sync_output = cell(numchannel, num_frequency_bands);
mean_concussed_output = cell(num_frequency_bands, 1);
for i=1:num_frequency_bands
    start_band = frequency_bands(1,i);
    end_band = frequency_bands(2,i);
    mean_concussed_m = cell(num_signals, numchannel);
    for j=1:num_signals
        nbt_result = nbt_doPhaseLocking(transpose(ALLSIGNAL_Conc{j}),RawSignalInfo,[start_band end_band],[0 length(ALLSIGNAL_Conc{j}(1,:))/250],4,[],[],[1 1]);
        nbt_output{j,i} = nbt_result;
        [channels, symPLV] = chanSynch(nbt_result, numchannel);
        chan_sync_output{j,i} = symPLV;
        for m=1:numchannel
            mean_concussed_m{j,m} = mean(symPLV(:,m));
        end
    end
    mean_concussed_output{i,1} = mean_concussed_m;
end

save('nbt_output', 'nbt_output')
save('chan_sync_output', 'chan_sync_output')
save('mean_concussed_output','mean_concussed_output')

% ********** BLOCK 4 END **********%