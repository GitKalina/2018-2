im = imread('banana_slug.tiff');
[height,width] = size(im);
im_class = class(im);
im_ = double(im);

im_class = sprintf('Bits per integer : %s', im_class);
im_size = sprintf('Height & Width: %d , %d', height, width);
disp(im_class); disp(im_size);
% <Initials>

im_ = max(im_, 2047);
im_ = min(im_, 15000);
im_ = im_ - 2047;
im_ = im_ / (15000-2047);
%figure; imshow(im_);
%imwrite(im_, 'im_linear.png');
% <Linearization>

im_bayer_1_1 = im_(1:2:end, 1:2:end); %red
im_bayer_1_2 = im_(1:2:end, 2:2:end); %green
im_bayer_2_1 = im_(2:2:end, 1:2:end); %green
im_bayer_2_2 = im_(2:2:end, 2:2:end); %blue

im_test = cat(3, im_bayer_1_1, im_bayer_1_1, im_bayer_2_2); % #1
%figure; imshow(min(1, im_test*5));
%imwrite(min(1, im_test*5), 'im_test_1.png');
im_test = cat(3, im_bayer_1_2, im_bayer_1_2, im_bayer_2_1); % #2
%figure; imshow(min(1, im_test*5));
%imwrite(min(1, im_test*5), 'im_test_2.png');
% Test 01 : Findout green channels
% The second image #2 is grayscale, so the positions of green channels
% are (1,2) and (2,1), which means Bayer pattern is BGGR or RGGB

im_test = cat(3, im_bayer_1_1, im_bayer_1_2, im_bayer_2_2); % #3
%figure; imshow(min(1, im_test*5));
imwrite(min(1, im_test*5), 'im_test_3.png');
%im_test = cat(3, im_bayer_2_2, im_bayer_1_2, im_bayer_1_1); % #4
%figure; imshow(min(1, im_test*5));
%imwrite(min(1, im_test*5), 'im_test_4.png');
% Test 02 : Findout red and blue channels
% The color of the shirts in third image #3 is blue, 
% so the Bayer pattern is RGGB
% <Identifying the correct Bayer pattern>

% White balancing : removing color costs so that colors that we would
% perceive as white are rendered as white in final image
% gray world assumption : force average color of scene to be gray
% White world assumption : force brightest object in scene to be white

im_red = im_bayer_1_1;
im_green = (im_bayer_1_2+im_bayer_2_1)/2;
im_blue = im_bayer_2_2;
im_rgb = cat(3, im_red, im_green, im_blue);

im_whiteworld = zeros(height/2, width/2, 3);
im_max_red = max(max(im_red));
im_max_green = max(max(im_green));
im_max_blue = max(max(im_blue));
for i = 1:height/2
    for j = 1:width/2
        im_whiteworld(i, j, 1) = im_rgb(i, j, 1) * (im_max_green / im_max_red);
        im_whiteworld(i, j, 2) = im_rgb(i, j, 2);
        im_whiteworld(i, j, 3) = im_rgb(i, j, 3) * (im_max_green / im_max_blue);
    end
end
%figure; imshow(min(1, im_whiteworld*5));
%imwrite(im_whiteworld, 'im_whiteworld.png');
%imwrite(min(1, im_whiteworld*5), 'im_whiteworld_x5.png');

im_grayworld = zeros(height/2, width/2, 3);
im_mean_red = mean(mean(im_red));
im_mean_green = mean(mean(im_green));
im_mean_blue = mean(mean(im_blue));
for i = 1:height/2
    for j = 1:width/2
        im_grayworld(i, j, 1) = im_rgb(i, j, 1) * (im_mean_green / im_mean_red);
        im_grayworld(i, j, 2) = im_rgb(i, j, 2);
        im_grayworld(i, j, 3) = im_rgb(i, j, 3) * (im_mean_green / im_mean_blue);
    end
end
%figure; imshow(min(1, im_grayworld*5));
%imwrite(im_grayworld, 'im_grayworld.png');
%imwrite(min(1, im_grayworld*5), 'im_grayworld_x5.png');
% <White balancing>

% [X, Y] = meshgrid(-3:3);
% [Xq, Yq] = meshgrid(-3:0.25:3);
% Vq = interp2(X, Y, V, Xq, Yq);
[X, Y] = meshgrid(1:width/2, 1:height/2);
[Xq, Yq] = meshgrid(1:0.5:width/2, 1:0.5:height/2);
im_demo_red = interp2(X, Y, im_grayworld(:,:,1), Xq, Yq);
im_demo_green = interp2(X, Y, im_grayworld(:,:,2), Xq, Yq);
im_demo_blue = interp2(X, Y, im_grayworld(:,:,3), Xq, Yq);
im_demo_grayworld = cat(3, im_demo_red, im_demo_green, im_demo_blue);
%figure; imshow(min(1, im_demo_grayworld*5));
%imwrite(im_demo_grayworld, 'im_demo_grayworld.png');
%imwrite(min(1, im_demo_grayworld*5), 'im_demo_grayworld_x5.png');
% <Demosaicing>

%im_gray = zeros(height-1, width-1);
im_gray = rgb2gray(im_demo_grayworld);
gray_max_1 = max(max(im_gray)*3);
gray_max_2 = max(max(im_gray)*4);
gray_max_3 = max(max(im_gray)*5);
gray_max_4 = max(max(im_gray)*6);
im_bright_1 = min(1, im_gray*gray_max_1);
im_bright_2 = min(1, im_gray*gray_max_2);
im_bright_3 = min(1, im_gray*gray_max_3); %4~5°¡ Àû´ç
im_bright_4 = min(1, im_gray*gray_max_4);
%figure; imshow(im_bright_1);
%figure; imshow(im_bright_2);
%figure; imshow(im_bright_3);
%figure; imshow(im_bright_4);
imwrite(im_bright_1, 'im_bright_1.png');
imwrite(im_bright_2, 'im_bright_2.png');
imwrite(im_bright_3, 'im_bright_3.png');
imwrite(im_bright_4, 'im_bright_4.png');

im_gamma = zeros(height-1, width-1, 3);
for i = 1:height-1
    for j = 1:width-1
        for k = 1:3
            if im_bright_3(i, j, k) <= 0.0031308
                im_gamma(i, j, k) = 12.92 * im_bright_3(i, j, k);
            else
                im_gamma(i, j, k) = 1.055 * (im_bright_3(i, j, k)^(1/2.4)) - 0.055;
            end
        end
    end
end
%figure; imshow(im_gamma);
% Brightness Adjustment and Gamma Correction

imwrite(im_gamma, 'im_gamma.png');
imwrite(im_gamma, 'im_gamma_95.jpeg', 'Quality', 95);
imwrite(im_gamma, 'im_gamma_50.jpeg', 'Quality', 50);
imwrite(im_gamma, 'im_gamma_30.jpeg', 'Quality', 30);
imwrite(im_gamma, 'im_gamma_25.jpeg', 'Quality', 25);
imwrite(im_gamma, 'im_gamma_20.jpeg', 'Quality', 20);