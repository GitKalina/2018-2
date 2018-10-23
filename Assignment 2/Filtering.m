function ret = Filtering(LP_, fftHd)
    for i = 1:5
        [height, width, NULL, frame_number] = size(LP_{i});        
        LP_filter = zeros(height, width, 3, frame_number);
        for c = 2:2
            for col = 1:width
                for row = 1:height
                    temp(1:frame_number) = LP_{i}(row, col, c, 1:frame_number);
                    LP_filter(row, col, c, 1:frame_number) = ifft((fft(temp) .* fftHd'));
                end
            end            
        end
        ret{i} = LP_filter;
    end
end