EEG = eeg_checkset( EEG );
EEG = pop_resample( EEG, 250);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = pop_eegfiltnew(EEG, 4,40,414,0,[],1);
EEG = eeg_checkset( EEG );
pop_writeeeg(EEG, '/Users/amnahyder/Desktop/17EEG64-08/17EEG64- 08 INTERVENTION/Week 11 Session 1/NI1?', 'TYPE','BDF');
