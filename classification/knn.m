function [label,score,cost]=knn(trainingsets,labels,k,varargin)
tic,
fprintf('K nearest neighbors classification with k=%d\n',k);
dim=length(varargin);
fprintf('Dimension of data:%d\n',dim);
fprintf('Creating training sets...\n');
mdl=fitcknn(trainingsets,labels,'NumNeighbors',k);
fprintf('Flattening data, number of data:%d\n',numel(varargin{1}));
data=zeros(dim,npts);
for i=1:dim
    data(i,:)=varargin{i}(:);
end
[label,score,cost]=predict(mdl,trainingset);
toc
