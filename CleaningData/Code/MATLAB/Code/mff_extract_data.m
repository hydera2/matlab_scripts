function mff_extract_data(filepath)
mff_setup
%file= 'C:\Users\sgarg\Desktop\eeg data\RFC01B0001_20160910_095450.mff';
hdr = read_mff_header(filepath);

chan = []; % all channelswhich javaclasspath
numOfsamples_from = 1;
numOfsamples_to = hdr.nSamples;
data = read_mff_data(filepath,'sample', numOfsamples_from,numOfsamples_to, [], hdr );

[pathstr,name,ext] = fileparts(filepath);

newSubFolder = strcat(pwd, '\mat_data');

if ~exist(newSubFolder, 'dir')
	mkdir(newSubFolder);
end

savefile = strcat(pwd, '\mat_data\', name, '.mat');

if ~exist(savefile, 'file')
    save(savefile, 'data');
    display('Data saved to .mat file in the "data" subfolder.');
else
    prompt = 'File already exists. Would you like to overwrite? (y/n)\n';
    choice = input(prompt, 's');
        
    if strcmpi(choice, 'y')
        save(savefile, 'data');
        display('Data saved to .mat file in the "data" subfolder.');
    else
        display('File not saved.');
    end
end

end