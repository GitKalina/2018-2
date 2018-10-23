function ret = Doubling(Layer, Layer_)
    [height, width, NULL, frame_number] = size(Layer_);
    temp = zeros(height, width, 3, frame_number);
    temp= impyramid(Layer, 'expand');
    [height_tmp, width_tmp, NULL, NULL] = size(temp);
    
    if height > height_tmp && width > width_tmp
        for i = 1:frame_number
            for c = 1:3
                for row = 1:height-1
                    temp(row, width, c, i) = temp(row, width-1, c, i);
                end
                for col = 1:width
                    temp(height, col, c, i) = temp(height-1, col, c, i);
                end
            end
        end
    end
    
    ret = temp;
end