function [lbs,centers]=recl(c,lb,k,varargin)
idx=find(c==lb);
dim=length(varargin);
npts=numel(varargin{1});
sz=size(varargin{1});
fprintf('reclassification...\n');
fprintf('Dimension of data:%d\n',dim);
fprintf('Number of points:%d',npts);
data=zeros(length(idx),dim);
sd=zeros(1,dim);
for i=1:dim
    croppeddata=varargin{i}(idx);
    sd(i)=sqrt(var(croppeddata));
    fprintf('Normalize data %d by its standard deviation %f\n',i,sd(i));
    data(:,i)=croppeddata/sd(i);
end
[tmplbs,centers]=km(data,k,30);
for i=1:k
    centers(i,:)=centers(i,:).*sd;
end
lbs=zeros(sz);
for i=1:k
%     [subx,suby]=ind2sub(sz,idx(tmplbs==i));
    lbs(idx(tmplbs==i))=i;
end