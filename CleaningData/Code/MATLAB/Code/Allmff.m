function all_mff = Allmff(databaseName, fulldatapath, directorywithmat)
cd '/home/eeglewave/Documents/Report Generation/Code/MATLAB/Code'
%datapath: 'home/eeglewave/Documents/Report Generation/Data/database_name'
cd '/home/eeglewave/Documents/Report Generation/Code/MATLAB/Code';
dbName = databaseName;
username = 'root';
password = 'Cerebellum!';
dataPath = fulldatapath;
interpolationWeightsFile = '/home/eeglewave/Documents/Report Generation/Data/Interpolation/65Ch210-10Avg.mat';
initializeDataMySQL(dbName, username, password, dataPath, interpolationWeightsFile)
cd 'Scatter Plot';
directory = directorywithmat;
testing_new_data(directory)
return
