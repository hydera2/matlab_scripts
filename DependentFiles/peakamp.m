


%ALLERP = pop_geterpvalues( ERP, [ 90 200],  1:4,  1:256 , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', 'n100.txt',...
 %'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peaklatbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'positive', 'Peakreplace',...
 %'absolute', 'Resolution',  3 );

%n100
T= readtable('n100.txt','ReadVariableNames',false);
A = table2array(T);
for n = 1:1024
    name = A(1,n);
    electrode = (extractAfter(extractAfter(name, '_'),'_E'));
    binname = (extractBefore(extractAfter(name, '_'),'_'));
    A(3,n) = electrode;
    A(4,n) = binname;
end


for n = 1:256
    averageval=(str2double(A(2, n))+ str2double(A(2, n+256))+ str2double(A(2, n+512))+ str2double(A(2, n+768)))/4;
    averages(1,n)=n;
    averages(2,n)= averageval;
end
n100 = averages;
save('n100avglatencies','n100');

%p200

T= readtable('p200.txt','ReadVariableNames',false);
A = table2array(T);
for n = 1:1024
    name = A(1,n);
    electrode = (extractAfter(extractAfter(name, '_'),'_E'));
    binname = (extractBefore(extractAfter(name, '_'),'_'));
    A(3,n) = electrode;
    A(4,n) = binname;
end


for n = 1:256
    averageval=(str2double(A(2, n))+ str2double(A(2, n+256))+ str2double(A(2, n+512))+ str2double(A(2, n+768)))/4;
    averages(1,n)=n;
    averages(2,n)= averageval;
end
p200 = averages;
save('p200avglatencies','p200');


%p300

T= readtable('p300.txt','ReadVariableNames',false);
A = table2array(T);
for n = 1:1024
    name = A(1,n);
    electrode = (extractAfter(extractAfter(name, '_'),'_E'));
    binname = (extractBefore(extractAfter(name, '_'),'_'));
    A(3,n) = electrode;
    A(4,n) = binname;
end


for n = 1:256
    averageval=(str2double(A(2, n))+ str2double(A(2, n+256))+ str2double(A(2, n+512))+ str2double(A(2, n+768)))/4;
    averages(1,n)=n;
    averages(2,n)= averageval;
end
p300 = averages;
save('p300avglatencies','p300');

%p400

T= readtable('p400.txt','ReadVariableNames',false);
A = table2array(T);
for n = 1:1024
    name = A(1,n);
    electrode = (extractAfter(extractAfter(name, '_'),'_E'));
    binname = (extractBefore(extractAfter(name, '_'),'_'));
    A(3,n) = electrode;
    A(4,n) = binname;
end


for n = 1:256
    averageval=(str2double(A(2, n))+ str2double(A(2, n+256))+ str2double(A(2, n+512))+ str2double(A(2, n+768)))/4;
    averages(1,n)=n;
    averages(2,n)= averageval;
end
p400 = averages;
save('p400avglatencies','p400');

AllLatencies=[];
for n= 1:256
    a=n100(2,n);
    b=p200(2,n);
    c=p300(2,n);
    d=p400(2,n);
    AllLatencies(1,n)=n;
    AllLatencies(2,n)=a;
    AllLatencies(3,n)=b;
    AllLatencies(4,n)=c;
    AllLatencies(5,n)=d;
end


%ERP = pop_loaderp( 'filename', 's40loc.erp', 'filepath', '/Users/amnahyder/Research/AmnaLocalizerERP/' );
ERPlist = '/Users/amnahyder/Research/AmnaLocalizerERP/ERPBinEdited/allerplist.txt';
for el = 1:256
    electrodenum = AllLatencies(1,el);
% n100
    ERPtimepointn100 = AllLatencies(2,el);
    savepathn100 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(electrodenum) 'n100.txt'];
    ALLERP = pop_geterpvalues(ERPlist,  ERPtimepointn100,  1:4,  electrodenum, 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathn100, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'instabl', 'PeakOnset',  1, 'Resolution',  3 );
% p200
    ERPtimepointp200 = AllLatencies(3,el);
    savepathp200 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(electrodenum) 'p200.txt'];
    ALLERP = pop_geterpvalues(ERPlist,  ERPtimepointp200,  1:4,  electrodenum, 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp200, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'instabl', 'PeakOnset',  1, 'Resolution',  3 );
% p300
    ERPtimepointp300 = AllLatencies(4,el);
    savepathp300 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(electrodenum) 'p300.txt'];
    ALLERP = pop_geterpvalues(ERPlist,  ERPtimepointp300,  1:4,  electrodenum, 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp300, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'instabl', 'PeakOnset',  1, 'Resolution',  3 );
% p400
    ERPtimepointp400 = AllLatencies(5,el);
    savepathp400 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(electrodenum) 'p400.txt'];
    ALLERP = pop_geterpvalues(ERPlist,  ERPtimepointp400,  1:4,  electrodenum, 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp400, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'instabl', 'PeakOnset',  1, 'Resolution',  3 );
end
 % pop_geterpvalues('s17loc.erp', 250, 1:4, 1);

  