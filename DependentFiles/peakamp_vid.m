

%ERP = pop_loaderp( 'filename', 's40loc.erp', 'filepath', '/Users/amnahyder/Research/AmnaLocalizerERP/' );
ERPlist = '/Users/amnahyder/Research/AmnaVideoERP/ERPBinUPDATE/ERPsetvideo.txt';
for el = 1:256
% n100
    savepathn600 =  ['/Users/amnahyder/Research/AmnaVideoERP/ERPBinUPDATE/amplitudes/' 'elec' num2str(el) 'a600.txt'];
    ALLERP = pop_geterpvalues( ERPlist, [500 700],  8:13,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathn600, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'ninteg', 'PeakOnset',  1, 'Resolution',  3 );
% p800
    savepathp800 =  ['/Users/amnahyder/Research/AmnaVideoERP/ERPBinUPDATE/amplitudes/' 'elec' num2str(el) 'a800.txt'];
    ALLERP = pop_geterpvalues(ERPlist, [700 900],  8:13,  el , 'Baseline', 'pre', 'Binlabel', 'on', 'FileFormat', 'wide', 'Filename', savepathp800, 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'ninteg', 'PeakOnset',  1, 'Resolution',  3 );
end
 % pop_geterpvalues('s17loc.erp', 250, 1:4, 1);