function [y,lb,center]=classification(x)
[lb,center]=adaptcluster_kmeans(x);

sz=size(x);
maxlb=max(lb(:));
minlb=min(lb(:));
markedpts=zeros(sz);
y=ones(sz);
for i=maxlb:-1:minlb
    fprintf('iteration %d\n',i);
    mark=(lb==i);
    mark=imdilate(mark,strel('diamond',4));
    mark=imerode(mark,strel('diamond',4));
    mark=bwareaopen(mark,200);
    mark=mark & not(markedpts);
    markedpts=mark | markedpts;
    y(mark)=i;
end