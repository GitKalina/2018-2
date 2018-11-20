image_hdr = hdrread('tonemapping_.hdr');

S=0.3;  W=1.;   sig=[5.,1.0];   image_tone = zeros(500, 750, 3);

for c = 1:3
    image_L = log(image_hdr(:, :, c));
    image_B = bfilter2(image_L, W, sig);
    image_D = image_L-image_B;
    image_B = (image_B-max(image_B(:))) .* S;
    image_DB = exp(image_D+image_B);
    image_tone(:, :, c) = image_DB(:, :);
end

imwrite(image_tone, strcat('RGB_',int2str(S),'_',int2str(W),'_',int2str(sig),'.png'));

image_hdr_ = rgb2xyz(image_hdr, 'ColorSpace', 'srgb');
hdr = zeros(500, 750, 3);
hdr(:, :, 1) = image_hdr_(:, : ,1) ./ (image_hdr_(:, : ,1) + image_hdr_(:, : ,2) + image_hdr_(:, : ,3));
hdr(:, :, 2) = image_hdr_(:, : ,2) ./ (image_hdr_(:, : ,1) + image_hdr_(:, : ,2) + image_hdr_(:, : ,3));
hdr(:, :, 3) = image_hdr_(:, : ,2);

image_L = log(hdr(:, :, 3));
image_B = bfilter2(image_L, W, sig);
image_D = image_L-image_B;
image_B = (image_B - max(image_B(:))) .* S;
image_DB = exp(image_D + image_B);
image_tone(:, :, 1) = image_DB(:, :) .* hdr(:, :, 1) ./ hdr(:, :, 2);
image_tone(:, :, 2) = image_DB(:, :);
image_tone(:, :, 3) = image_DB(:, :) .* (1 - hdr(:, :, 1) - hdr(:, :, 2)) ./ hdr(:, :, 2);

image_tone = xyz2rgb(image_tone);
imwrite(image_tone, strcat('Luminance_',int2str(S),'_',int2str(W),'_',int2str(sig),'.png'));