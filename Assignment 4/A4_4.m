image_eval = rgb2xyz(image__, 'ColorSpace', 'srgb');
y_ = zeros(6, 1);

for f = 1:6
    for i = fp(f, 1) - 3 : fp(f, 1) + 3
        for j = fp(f, 2) - 3 : fp(f, 2) + 3
            y_(f) = y_(f) + image_eval(j, i, 2);
        end
    end
    y_(f) = log(y_(f) / 49);
end

err = 0;

for f = 2:5
    err = err + ((y_(1) + (y_(6) - y_(1)) * (f-1) / 5) - y_(f)) ^ 2;
end