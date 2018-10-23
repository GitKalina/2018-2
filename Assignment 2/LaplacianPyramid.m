function ret = LaplacianPyramid(layer, layer_)
    [lap_height, lap_width, NULL, lap_frame_number] = size(layer);
    us_layer_ = zeros(lap_height, lap_width, 3, lap_frame_number);
    us_layer_ = impyramid(layer_, 'expand');
    [us_height, us_width, NULL, NULL] = size(us_layer_);
    
    if lap_height > us_height && lap_width > us_width
       for frame = 1:lap_frame_number
           for color = 1:3
               for row = 1:lap_height-1
                   us_layer_(row, lap_width, color, frame) = us_layer_(row, lap_width-1, color, frame);
               end
               for col = 1:lap_width
                   us_layer_(lap_height, col, color, frame) = us_layer_(lap_height-1, col, color, frame);
               end
           end
       end
    end
    
    ret = layer - us_layer_;
end
