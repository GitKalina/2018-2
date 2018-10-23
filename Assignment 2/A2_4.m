freq_band = [];
for i = 1:frame_number
    mag = 0;
    for j = 1:5
        LP_freq = LP_{j}(:,:,:,i);
        mag = mag + mean(abs(LP_freq(:)));
    end
    freq_band = [freq_band; mag];
end
plot(freq_band);
xlim([0,300])
