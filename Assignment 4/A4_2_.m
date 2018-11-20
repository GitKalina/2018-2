% Load image as reduced size for reduce memory usage.

image_origin = {};

for i = 1:16

    image_origin{end+1} = imread(strcat('exposure_stack\\exposure',int2str(i),'.tiff'));

    image_origin{end} = im2uint8(imresize(image_origin{end}, 0.125));

end

 

for chan = 1:3

    % sample 2000 pointe

    samples = zeros(32000, 1, 'uint8');

    for i = 0:1999

        x = randi(750);

        y = randi(500);

        for f = 1:16

            samples(i * 16 + f) = image_jpg{f}(y, x, chan);

        end

    end

    lambda = 1.0;

    % construct G matrix and the differance value b

    getg = zeros(32256, 256);

    b = zeros(30255, 1);

    for i = 0:1999

        for j = 1:15

            getg((i * 16 + j), samples((i * 16 + j)) + 1) = 1;

            b(i * 15 + j) = 0.693147180 * getw(samples(i * 16 + j + 1));

        end

        getg((i * 16 + 16), samples((i * 16 + 16)) + 1) = 1;

    end

 

    % append original g for create laplacian

    for i = 1:256

        getg(32000 + i, i) = 1;

    end

 

    % set constant (for preserve 255)

    b(30255) = log(255);

 

 

    % set first derivative matrix

    diff = zeros(30255, 32256);

    for i = 0:1999

        for j = 1:15

            diff(i * 15 + j, i * 16 + j) = -b(i * 15 + j);

            diff(i * 15 + j, i * 16 + j + 1) = b(i * 15 + j);

        end

    end

    % set second derivative (laplacian) matrix

    for i = 1:254

        diff(30000 + i, 32000 + i) =  1 * lambda;

        diff(30000 + i, 32000 + i + 1) = -2 * 1 * lambda;

        diff(30000 + i, 32000 + i + 2) = 1 * lambda;

    end

    % set constant (for preserve 255)

    diff(30255, 32256) = 1;

 

 

    A = diff * getg;

    g(chan, :) = A \ b;

end