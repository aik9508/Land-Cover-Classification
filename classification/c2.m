x=aa;
% divide a large image into small parts
[m,n]=size(x);
l=300;
xstart=1:l:m;
xend=min(xstart+l-1,m);
ystart=1:l:n;
yend=min(ystart+l-1,n);
y=zeros(m,n);
for i=1:length(xstart)
    for j=1:length(ystart)
        b=x(xstart(i):xend(i),ystart(j):yend(j));
        [lbs,centers]=...
            adaptcluster_kmeans(b);
        for k=1:max(lbs(:))
            ind=find(lbs==k);
            [subx,suby]=ind2sub(size(lbs),ind);
            subx=subx+xstart(i)-1;
            suby=suby+ystart(j)-1;
%             if centers(k)<=60
                y(sub2ind([m,n],subx,suby))=centers(k);
%             else
%                 y(sub2ind([m,n],subx,suby))=0; 
%             end
        end
    end
end