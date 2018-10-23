freq_s = 30; % Sampling frequency
freq_l = 0.83; % Lowest frequency
freq_h = 1; % Highest freqeuncy
Hd = butterworthBandpassFilter(freq_s, frame_number-1, freq_l, freq_h);
fftHd = freqz(Hd, frame_number-1);

filtered_LP = getFilteredLaplacianPyramid(LP, fftHd);

%for i = 1:6
%    [height_lp, width_lp, NULL, frame_number_lp] = size(LP{i});        
%    LP_layer = zeros(height_lp, width_lp, 3, frame_number_lp);
%    for col = 1:width_lp
%        for row = 1:height_lp
%            temp(1:frame_number_lp) = LP{i}(row, col, 2, 1:frame_number_lp);
%            LP_layer(row, col, 2, 1:frame_number_lp) = ifft((fft(temp) .* fftHd'));
%        end
%    end            
%    LP{i} = LP_layer;
%end

LP_fft = FourierTransform(filtered_LP);