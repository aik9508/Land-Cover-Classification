function y=clustermin(x,X,ntruncate)
y=zeros(size(x));
cc=bwconncomp(x);
nd=length(X);
for i = 1:length(cc.PixelIdxList)
    l=length(cc.PixelIdxList{i});
    if l>ntruncate
        means=zeros(nd,l);
        for k=1:nd
            means(k,:)=X(k).amp(cc.PixelIdxList{i});
        end
%         variance = mean((means-means(1)).^2);
%         y(cc.PixelIdxList{i}) = variance;
        y(cc.PixelIdxList{i}) = mean(min(means,[],2));
    end
end

