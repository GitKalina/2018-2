LP{1} = L0; LP{2} = L1; LP{3} = L2;
LP{4} = L3; LP{5} = L4; %LP{6} = L5;

freq_s = 30; % Sampling Frequency
freq_l = 0.83; % Lowest Frequency
freq_h = 1; % Highest Frequency
Hd = butterworthBandpassFilter(freq_s, frame_number, freq_l, freq_h);
fftHd = freqz(Hd, frame_number);
        
filtered_LP = Filtering(LP, fftHd);

clear Hd;
clear fftHd;
clear L0;
clear L1;
clear L2;
clear L3;
clear L4;
%clear L5;