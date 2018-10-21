function y=rmlowval(x,m,vtruncate,ntruncate)
y=x;
cc=bwconncomp(x);
for i = 1:length(cc.PixelIdxList)
    if length(m(cc.PixelIdxList{i}))>ntruncate && ...
            mean(m(cc.PixelIdxList{i}))<vtruncate
        y(cc.PixelIdxList{i})=0;
    end
end
 
% for i = 1:length(cc.PixelIdxList)
%     if length(dx(cc.PixelIdxList{i}))>10000
%         dx(cc.PixelIdxList{i})=0;
%     end
% end