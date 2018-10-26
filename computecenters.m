function centers=computecenters(coords,amp,corr,drate)
[n,~]=size(coords);
centers=zeros(n,3);
for i=1:n
    centers(i,:)=computecenter(coords(i,:),false,amp,corr,drate);
end