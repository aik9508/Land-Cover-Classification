function map=getcolormap(cbarfile,n)
if nargin < 2
    n=64;
end
X=imread(cbarfile);
% [~,map]=rgb2ind(X,n);
line=size(X,1);
column=size(X,2);
midcolumn=round(column/2);
samplelines=linspace(1,line,min(line,n));
samplelines=floor(samplelines);
map=X(samplelines,midcolumn,1:3);
map=double(reshape(map,[size(map,1),3]))/256;
map=flipud(map);