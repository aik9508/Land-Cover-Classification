ba = amp>450;
ba = bwareaopen(ba,50);
cc = bwconncomp(ba);
sz = size(amp);
for i=1:cc.NumObjects
    block = cc.PixelIdxList(i);
    block = block{1};
    [subx,suby] = ind2sub(sz,block);
    length = sqrt((max(subx)-min(subx))^2+(max(suby)-min(suby))^2);
    if length<50 || numel(block)/length > 5
        ba(block) = 0;
    end
end