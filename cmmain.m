[X,Y,amp,corr,drate] = avgprepare('LaMarque', 4720, 4);
greylevel = 8;
g = 20*log10(1e-15+amp);
g = greyscale(g,39,57,greylevel);
directions = [1,0; 0,1; 1,1; 1,-1];
ndirections = size(directions,1);
h = zeros(size(g));
e = zeros(size(g));
c = zeros(size(g));
for i = 1:ndirections
    cm = coocurrenceMatrix(directions(1),directions(2),g,greylevel,5);
    h = h + double(homogenity(cm));
    e = e + double(energy(cm));
    c = c + double(contrast(cm));
end
save('tfts','h','e','c');