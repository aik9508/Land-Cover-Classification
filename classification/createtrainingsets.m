function [trainingsets,labels]=createtrainingsets(samples,scales,varargin)
[n,~]=size(samples);
trainingsets=[];
labels=[];
for i=1:n
    trainingset=createtrainingset(samples(i,1:4),false,varargin{:});
    [npts,~]=size(trainingset);
    trainingsets=[trainingsets;trainingset];
    labels=[labels;samples(i,5)*ones(npts,1)];
end
trainingsets=trainingsets./scales;