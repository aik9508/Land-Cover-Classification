function [lbs,centers,mindis]=unsupcl(k,varargin)
dim=length(varargin);
fprintf('Land classification, number of categories: %d\n',k);
fprintf('Dimension of data: %d\n',dim);
npts=numel(varargin{1});
data=zeros(dim,npts);
fprintf('flatten data...\n');
sigmas=zeros(1,dim);
for i=1:dim
    sigmas(i)=sqrt(var(varargin{i}(:)));
    data(i,:)=varargin{i}(:)/sigmas(i);
end
data=data';
[lbs,centers,mindis]=km(data,k);
lbs=reshape(lbs,size(varargin{1}));
mindis=reshape(mindis,size(varargin{1}));