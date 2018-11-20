image_hdr = hdrread('tonemapping.hdr');

K = 0.5;    B = 0.95;   image_tone = zeros(500, 750, 3);

for c = 1:3
    var = exp(1/(500*750) * sum(log(image_hdr(:, :, c) + 1e-15)));
    var2 = image_hdr(:, :, c) * K / var;
    var_white = B * max(var2(:));
    tone = var2 .* (var2./(var_white^2) + 1) ./ (var2+1);
    image_tone(:, :, c) = tone(:, :);
end

imwrite(image_tone, strcat('RGB_',int2str(K),'_',int2str(B),'.png'));

image_hdr_ = rgb2xyz(image_hdr, 'ColorSpace', 'srgb');
hdr = zeros(500, 750, 3);
hdr(:, :, 1) = image_hdr_(:, : ,1) ./ (image_hdr_(:, : ,1) + image_hdr_(:, : ,2) + image_hdr_(:, : ,3));
hdr(:, :, 2) = image_hdr_(:, : ,2) ./ (image_hdr_(:, : ,1) + image_hdr_(:, : ,2) + image_hdr_(:, : ,3));
hdr(:, :, 3) = image_hdr_(:, : ,2);

var = exp(1/(500*750) * sum(log(image_hdr(:, :, c) + 1e-15)));
var2 = image_hdr(:, :, c) * K / var;
var_white = B * max(var2(:));
tone = var2 .* (var2./(var_white^2) + 1) ./ (var2+1);

image_tone(:, :, 1) = tone(:, :).*hdr(:, :, 1)./hdr(:, :, 2);
image_tone(:, :, 2) = tone(:, :);
image_tone(:, :, 3) = tone(:, :).*(1-hdr(:, :, 1)-hdr(:, :, 2))./hdr(:, :, 2);

image_tone = xyz2rgb(image_tone);
imwrite(image_tone, strcat('Luminance_',int2str(K),'_',int2str(B),'.png'));