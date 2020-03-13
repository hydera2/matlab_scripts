%% SFH
userName='root'
password='Cerebellum!'
dbName='SFH'
dataPath = '/home/eeglewave/Documents/Report Generation/Data/SFH'
interpolationWeightsFile='/home/eeglewave/Documents/Report Generation/Data/Interpolation/65Ch210-10Avg.mat';
initializeDataMySQL(dbName, userName, password, dataPath, interpolationWeightsFile)
directory = [dataPath, '/MAT'];
testing_new_data(directory)
%%RFC
userName='root'
password='Cerebellum!'
dbName='RFC'
dataPath = '/home/eeglewave/Documents/Report Generation/Data/RFC'
interpolationWeightsFile='/home/eeglewave/Documents/Report Generation/Data/Interpolation/65Ch210-10Avg.mat';
directory = [dataPath, '/MAT'];