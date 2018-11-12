function [c,min_distance]=supcl(centers,varargin)
[nlbs,dim]=size(centers);
fprintf('Land classification, number of categories: %d\n',nlbs);
fprintf('Dimension of data: %d\n',dim);
npts=numel(varargin{1});
data=zeros(dim,npts);
fprintf('flatten data...\n');
sigmas=zeros(1,dim);
% sigmas=max(centers,[],1)-min(centers,[],1);
for i=1:dim
    sigmas(i)=sqrt(var(varargin{i}(:)));
    data(i,:)=varargin{i}(:)/sigmas(i);
    fprintf('Normalize paramter %d by its standard deviation %6.3f\n',i,sigmas(i));
end
distance=zeros(nlbs,npts);
for i=1:nlbs
    fprintf('Processing, iteration %d, total %d\n',i,nlbs);
    center=centers(i,:)./sigmas;
    dup_center=repmat(center',[1,npts]);
    distance(i,:)=sum((data-dup_center).^2,1);
end
min_distance=min(distance,[],1);
c=zeros(size(varargin{1}));
for i=1:nlbs
    k=min_distance==distance(i,:);
    c(k)=i;
end
min_distance=reshape(min_distance,size(c));
