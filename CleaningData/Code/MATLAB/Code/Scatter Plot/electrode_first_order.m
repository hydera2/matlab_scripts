function [powerSpecFeats_ordered] = electrode_first_order(powerSpecFeats, num_elec)

%   This function changes the powerSpecFeats from being ordered firstly
%   with features to being order firstly with electrodes
%
%   Change the number of containers to num_elec manually.
%
%   E.g. From [E1F1 E2F1 E3F1...] -> [E1F1 E1F2 E1F3...]

count = 1;

for col = 1:num_elec:length(powerSpecFeats)
    container1(:, count) = powerSpecFeats(:, col);
    container2(:, count) = powerSpecFeats(:, col+1);
    container3(:, count) = powerSpecFeats(:, col+2);
    container4(:, count) = powerSpecFeats(:, col+3);
    container5(:, count) = powerSpecFeats(:, col+4);
    container6(:, count) = powerSpecFeats(:, col+5);
    container7(:, count) = powerSpecFeats(:, col+6);
    container8(:, count) = powerSpecFeats(:, col+7);
    container9(:, count) = powerSpecFeats(:, col+8);
    container10(:, count) = powerSpecFeats(:, col+9);
    container11(:, count) = powerSpecFeats(:, col+10);
    container12(:, count) = powerSpecFeats(:, col+11);
    container13(:, count) = powerSpecFeats(:, col+12);
    container14(:, count) = powerSpecFeats(:, col+13);
    container15(:, count) = powerSpecFeats(:, col+14);
    container16(:, count) = powerSpecFeats(:, col+15);
    container17(:, count) = powerSpecFeats(:, col+16);
    container18(:, count) = powerSpecFeats(:, col+17);
    container19(:, count) = powerSpecFeats(:, col+18);
    container20(:, count) = powerSpecFeats(:, col+19);
    container21(:, count) = powerSpecFeats(:, col+20);
    container22(:, count) = powerSpecFeats(:, col+21);
    container23(:, count) = powerSpecFeats(:, col+22);
    container24(:, count) = powerSpecFeats(:, col+23);
    container25(:, count) = powerSpecFeats(:, col+24);
    container26(:, count) = powerSpecFeats(:, col+25);
    container27(:, count) = powerSpecFeats(:, col+26);
    %{
    container28(:, count) = powerSpecFeats(:, col+27);
    container29(:, count) = powerSpecFeats(:, col+28);
    container30(:, count) = powerSpecFeats(:, col+29);
    container31(:, count) = powerSpecFeats(:, col+30);
    container32(:, count) = powerSpecFeats(:, col+31);
    container33(:, count) = powerSpecFeats(:, col+32);
    container34(:, count) = powerSpecFeats(:, col+33);
    container35(:, count) = powerSpecFeats(:, col+34);
    container36(:, count) = powerSpecFeats(:, col+35);
    container37(:, count) = powerSpecFeats(:, col+36);
    container38(:, count) = powerSpecFeats(:, col+37);
    container39(:, count) = powerSpecFeats(:, col+38);
    container40(:, count) = powerSpecFeats(:, col+39);
    container41(:, count) = powerSpecFeats(:, col+40);
    container42(:, count) = powerSpecFeats(:, col+41);
    container43(:, count) = powerSpecFeats(:, col+42);
    container44(:, count) = powerSpecFeats(:, col+43);
    container45(:, count) = powerSpecFeats(:, col+44);
    container46(:, count) = powerSpecFeats(:, col+45);
    container47(:, count) = powerSpecFeats(:, col+46);
    container48(:, count) = powerSpecFeats(:, col+47);
    container49(:, count) = powerSpecFeats(:, col+48);
    container50(:, count) = powerSpecFeats(:, col+49);
    container51(:, count) = powerSpecFeats(:, col+50);
    container52(:, count) = powerSpecFeats(:, col+51);
    container53(:, count) = powerSpecFeats(:, col+52);
    container54(:, count) = powerSpecFeats(:, col+53);
    container55(:, count) = powerSpecFeats(:, col+54);
    container56(:, count) = powerSpecFeats(:, col+55);
    container57(:, count) = powerSpecFeats(:, col+56);
    container58(:, count) = powerSpecFeats(:, col+57);
    container59(:, count) = powerSpecFeats(:, col+58);
    container60(:, count) = powerSpecFeats(:, col+59);
    container61(:, count) = powerSpecFeats(:, col+60);
    container62(:, count) = powerSpecFeats(:, col+61);
    container63(:, count) = powerSpecFeats(:, col+62);
    container64(:, count) = powerSpecFeats(:, col+63);
    %}
    count = count + 1;
end



powerSpecFeats_ordered = [container1 container2 container3 container4 container5 container6 container7 container8 container9 container10...
    container11 container12 container13 container14 container15 container16 container17 container18 container19 container20...
    container21 container22 container23 container24 container25 container26 container27...
    %{
    container28 container29 container30...
    container31 container32 container33 container34 container35 container36 container37 container38 container39 container40...
    container41 container42 container43 container44 container45 container46 container47 container48 container49 container50...
    container51 container52 container53 container54 container55 container56 container57 container58 container59 container60...
    container61 container62 container63 container64
    %}
    ];