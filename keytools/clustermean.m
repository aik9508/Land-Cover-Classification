function y=clustermean(x,v)
y=zeros(size(x));
cc=bwconncomp(x);
for i = 1:length(cc.PixelIdxList)
    y(cc.PixelIdxList{i}) = mean(v(cc.PixelIdxList{i}));
end