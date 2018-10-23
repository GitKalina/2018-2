% 3-1-1. TOY PROBLEM (20 POINTS)

toy_problem = imread('./data/toy_problem.png');

toy_problem = im2double(toy_problem);

[height, width] = size(toy_problem); % 119 * 110

im2var = zeros(height, width);
im2var(1:height*width) = 1:height*width;

e = 0;
A = sparse(((height*(width-1))+(height-1)*width)+1, height*width); % sparse(number of rows, number of columns)
%{
https://kr.mathworks.com/help/matlab/ref/sparse.html?searchHighlight=sparse&s_tid=doc_srchtitle
%}

% create rows of matrix A
for y = 1:height
    for x = 1:width-1
        e = e+1; % e is an equation(matrix row) counter
        A(e, im2var(y, x+1)) = 1; % (y, x) order is a convention in Matlab
        A(e, im2var(y, x)) = -1;
        b(e) = toy_problem(y, x+1) - toy_problem(y, x);
    end
end

for y = 1:height-1
    for x = 1:width
        e = e+1;
        A(e, im2var(y+1, x)) = 1;
        A(e, im2var(y, x)) = -1;
        b(e) = toy_problem(y+1, x) - toy_problem(y, x);
    end
end

e = e+1;
A(e, im2var(1, 1)) = 1;
b(e) = toy_problem(1, 1);

v = A\b';
%{
https://kr.mathworks.com/help/matlab/ref/mldivide.html?searchHighlight=mldivide&s_tid=doc_srchtitle
https://kr.mathworks.com/help/matlab/ref/ctranspose.html
%}

result = reshape(v, height, width);

imshow(result);
imwrite(result, 'toy_problem_result.png');