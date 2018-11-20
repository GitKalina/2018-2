for c = 1:3
    merge = 0;
    for i = 1:500
        for j = 1:750
            weight = 0;
            v = 0;
            for f = 1:16
                v = v+getw(image{f}(i, j, c))*double(image{f}(i, j, c))*2^(-f);
                %if ( image{f}(i, j, c) > 0 )
                %    v = v+getw(image{f}(i, j, c))*(log(double(image{f}(i, j, c)))-log(2)*f);
                %end
                %v = v+getw(image_jpg{f}(i, j, c))*exp(g(c, image_jpg{f}(i, j, c)+1));
                %v = v+getw(image_jpg{f}(i, j, c))* (g(c, image_jpg{f}(i, j, c)+1)-log(2)*f);
                weight = weight+getw(image_jpg{f}(i, j, c));
            end
            if weight ~= 0
                v = v/weight;
            end
            
            %v = exp(v);
            
            image__(i, j, c) = v;
            if ( merge < v )
                merge = v;
            end
        end
    end
    image__(:, :, c) = image__(:, :, c) ./ m;
end