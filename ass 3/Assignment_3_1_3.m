% 3-1-3. BLENDING WITH MIXED GRADIENTS (10 POINTS)

source_image = imread('./data/penguin-chick.jpeg');
target_image = imread('./data/hiking.jpg');

source_image = im2double(source_image);
target_image = im2double(target_image);

source_image = imresize(source_image, 0.5, 'bilinear');
target_image = imresize(target_image, 0.5, 'bilinear');

source_mask = getMask(source_image);
[aligned_source_image, aligned_source_mask] = alignSource(source_image, source_mask, target_image);

[height, width, channel] = size(aligned_source_image);
im2var = zeros(height, width);
im2var(1:height*width) = 1:height*width;

e = 0;
A = sparse(height*width, height*width);
b = zeros(height*width, channel);

for y = 1:height
    for x = 1:width
        e = e+1;
        if aligned_source_mask(y, x)
            A(e, im2var(y, x)) = 4;
            A(e, im2var(y, x-1)) = -1;
            A(e, im2var(y, x+1)) = -1;
            A(e, im2var(y-1, x)) = -1;
            A(e, im2var(y+1, x)) = -1;
            source_gradient = 4 * aligned_source_image(y, x, :) - aligned_source_image(y, x-1, :) - aligned_source_image(y, x+1, :) - aligned_source_image(y-1, x, :) - aligned_source_image(y+1, x, :);
            target_gradient = 4 * target_image(y, x, :) - target_image(y, x-1, :) - target_image(y, x+1, :) - target_image(y-1, x, :) - target_image(y+1, x, :);
            if abs(source_gradient) > abs(target_gradient)
                b(e, :) = source_gradient;
            else
                b(e, :) = target_gradient;
            end
        else
            A(e, im2var(y, x)) = 1;
            b(e, :) = target_image(y, x, :);
        end
    end
end

v = A\b;

result = reshape(v, height, width, channel);

imshow(result);
imwrite(result, 'penguin-chick_and_hiking_mixed_result.png');