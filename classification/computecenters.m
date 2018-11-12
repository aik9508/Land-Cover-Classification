function centers=computecenters(coords,varargin)
[n,~]=size(coords);
centers=zeros(n,length(varargin));
for i=1:n
    centers(i,:)=computecenter(coords(i,:),false,varargin{:});
end