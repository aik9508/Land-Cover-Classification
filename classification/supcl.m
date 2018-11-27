function [c,min_distance]=supcl(centers,scales,varargin)
[nlbs,dim]=size(centers);
fprintf('Land classification, number of categories: %d\n',nlbs);
fprintf('Dimension of data: %d\n',dim);
npts=numel(varargin{1});
data=zeros(dim,npts);
fprintf('flatten data...\n');
if isempty(scales)
    scales=zeros(1,dim);
    for i=1:dim
        scales(i)=sqrt(var(varargin{i}(:)));
    end
end
for i=1:dim
    data(i,:)=varargin{i}(:)/scales(i);
    fprintf('Normalize paramter %d by its standard deviation %6.3f\n',i,scales(i));
end
distance=zeros(nlbs,npts);
for i=1:nlbs
    fprintf('Processing, iteration %d, total %d\n',i,nlbs);
    center=centers(i,:)./scales;
    dup_center=repmat(center',[1,npts]);
    distance(i,:)=sum((data-dup_center).^2,1);
end
min_distance=min(distance,[],1);
c=zeros(size(varargin{1}));
for i=1:nlbs
    k=min_distance==distance(i,:);
    c(k)=i;
end
min_distance=reshape(sqrt(min_distance),size(c));
