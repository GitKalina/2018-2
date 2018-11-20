% Linearize Rendered images
image = {};
dir = 'exposure_stack\\exposure';
for i = 1:16
    image{end+1} = imread(strcat(dir, int2str(i), '.tiff'));
    image{end} = im2uint8(imresize(image{end}, 0.125));
end
image_jpg = {};
for i = 1:16
    image_jpg{end+1} = imread(strcat(dir, int2str(i), '.jpg'));
    image_jpg{end} = im2uint8(imresize(image_jpg{end}, 0.125));
end

for c = 1:3
    sample = zeros(32000, 1, 'uint8');
    for i = 0:3999
        x = randi(500); y = randi(750);
        for j = 1:8
            sample(i*8 + j) = image_jpg{j}(x, y, c);
        end
    end
    
    image_g = zeros(32256, 256);
    b = zeros(30255, 1);
    for i = 0:3999
        for j = 1:7
            image_g((i*8 + j), sample((i*8 + j)) + 1) = 1;
            b(i*7 + j) = log(2) * image_g(sample(i*8 + j + 1));
        end
        image_g((i*8 + 8), sample((i*8 + 8)) + 1) = 1;
    end
    
    for i = i:256
        image_g(32000+i, i) = 1;
    end
    b(30255) = log(255);
    
    diff = zeros(30255, 32256);
    for i = 0:3999
        for j = 1:7
            diff(i*7 + j, i*8 + j) = -b(i*7 + j);
            diff(i*7 + j, i*8 + j+1) = b(i*7 + j);
        end
    end
    for i = 1:254
        diff(30000+i, 32000+i) = 1;
        diff(30000+i, 32000+i+1) = -2
        diff(30000+i, 32000+i+2) = 1;
    end
    diff(30255, 32256) = 1;
    
    A = diff*image_g;
    g(c, :) = A \ b;
end