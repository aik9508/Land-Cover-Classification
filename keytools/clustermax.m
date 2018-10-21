function y=clustermax(x,X,ntruncate)
y=zeros(size(x));
cc=bwconncomp(x);
nd=length(X);
for i = 1:length(cc.PixelIdxList)
    if length(cc.PixelIdxList{i})>ntruncate
        means=zeros(1,nd);
        for k=1:nd
            means(k)=mean(X(k).amp(cc.PixelIdxList{i}));
        end
%         variance = mean((means-means(1)).^2);
%         y(cc.PixelIdxList{i}) = variance;
        y(cc.PixelIdxList{i}) = max(means);
    end
end

