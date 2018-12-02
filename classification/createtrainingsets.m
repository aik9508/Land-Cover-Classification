function [trainingsets,labels]=createtrainingsets(coords,scales,varargin)
[n,~]=size(coords);
trainingsets=[];
labels=[];
for i=1:n
    trainingset=createtrainingset(coords(i,:),false,varargin{:});
    [npts,~]=size(trainingset);
    trainingsets=[trainingsets;trainingset];
    labels=[labels;i*ones(npts,1)];
end
trainingsets=trainingsets./scales;