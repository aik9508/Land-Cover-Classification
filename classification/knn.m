function [label,score,cost]=knn(trainingsets,labels,k,varargin)
tic,
fprintf('K nearest neighbors classification with k=%d\n',k);
dim=length(varargin);
fprintf('Dimension of data:%d\n',dim);
fprintf('Creating training sets...\n');
mdl=fitcknn(trainingsets,labels,'NumNeighbors',k);
npts=numel(varargin{1});
fprintf('Flattening data, number of data:%d\n',npts);
data=zeros(dim,npts);
for i=1:dim
    data(i,:)=varargin{i}(:);
end
data=data';
scales=load('scales.mat');
scales=scales.scales;
data=data./scales;
[label,score,cost]=predict(mdl,data);
toc
