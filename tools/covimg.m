function meanImage=covimg(grayImage,windowsize)
% Make an image of 1's so we can count how many 
% neighbors there are at each pixel location.
binaryImage = ones(size(grayImage));
% Define a kernel to do the summing of the images at each location.
kernel = ones(windowsize);
edgecut = round(windowsize/2-1);
% Get sum of gray levels at each window location.
% Use 'full' option so we can let the window slide out and count neighbors of edge pixels.
sumImage = conv2(double(grayImage), kernel, 'full');
% Count the pixels at each window location.
countImage = conv2(double(binaryImage), kernel, 'full');
% Get the mean by dividing the sum by the pixel count.
% but ignore the outer 1-pixel-wide layer.
meanImage = sumImage(1+edgecut:end-edgecut, 1+edgecut:end-edgecut) ./ ...
            countImage(1+edgecut:end-edgecut, 1+edgecut:end-edgecut);