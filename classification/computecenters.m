function [centers,centervars]=computecenters(coords,varargin)
[n,~]=size(coords);
centers=zeros(n,length(varargin));
centervars=zeros(n,length(varargin));
for i=1:n
    [centers(i,:),centervars(i,:)]=computecenter(coords(i,:),false,varargin{:});
end
