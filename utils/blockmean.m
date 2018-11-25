function y = blockmean(x,blocks)
y = zeros(size(x));
cc = bwconncomp(blocks);
for i=1:cc.NumObjects
    y(cc.PixelIdxList{i}) = mean(x(cc.PixelIdxList{i}));
end