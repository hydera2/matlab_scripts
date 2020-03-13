

%ERP = pop_loaderp( 'filename', 's40loc.erp', 'filepath', '/Users/amnahyder/Research/AmnaLocalizerERP/' );
ERPlist = '/Users/amnahyder/Research/AmnaLocalizerERP/ERPBinEdited/allerplist.txt';
for el = 1:256
% n100
    savepathn100 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'n100.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [90 200],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathn100, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'negative', 'Peakreplace', 'absolute', 'Resolution',  3 );
% p200
    savepathp200 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'p200.txt'];
    ALLERP = pop_geterpvalues(ERPlist, [100 250],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp200, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'positive', 'Peakreplace', 'absolute', 'Resolution',  3 );
% n200
    savepathn200 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'n200.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [250 350],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathn200, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'negative', 'Peakreplace', 'absolute', 'Resolution',  3 );
% p3a (peaks around 300-350 ms frontal lobe response)
    savepathp3a =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'p3a.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [250 350],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp3a, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'positive', 'Peakreplace', 'absolute', 'Resolution',  3 );
% p3b (350-450 ms in the centro-parietal area)
    savepathp3b =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'p3b.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [350 450],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp3b, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'positive', 'Peakreplace', 'absolute', 'Resolution',  3 );
% N300 (250-350)
    savepathn300 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'n300.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [250 350],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathn300, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'negative', 'Peakreplace', 'absolute', 'Resolution',  3 );
% p400
    savepathp400 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'p400.txt'];
    ALLERP = pop_geterpvalues(ERPlist, [350 600],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp400, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'positive', 'Peakreplace', 'absolute', 'Resolution',  3 );
%n400 350 and 550 ms
    savepathn400 =  ['/Users/amnahyder/Research/AmnaLocalizerERP/amplitudes/' 'elec' num2str(el) 'n400.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [350 550],  1:4,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathn400, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peakampbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity', 'negative', 'Peakreplace', 'absolute', 'Resolution',  3 );
end
 % pop_geterpvalues('s17loc.erp', 250, 1:4, 1);

  