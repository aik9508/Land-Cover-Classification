function [lbs,centers,mindis]=unsupcl(k,centers,scales,rigidity,varargin)
% New cluster centers are forced to stay in a close
% neighbourhood of given prefixed centers. The radius
% of the so called neighbourhood is controlled by
% rigidity. If rigidity = 0, we have 100% unsupervised
% classification algorithm. If rigidity = 1, we centers
% are not allowed to move.
dim=length(varargin);
fprintf('Land classification, number of categories: %d\n',k);
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
end
data=data';
[lbs,centers,mindis]=km2(data,k,100,centers./scales,rigidity);
lbs=reshape(lbs,size(varargin{1}));
mindis=reshape(mindis,size(varargin{1}));
