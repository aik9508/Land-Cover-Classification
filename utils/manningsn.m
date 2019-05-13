function m=manningsn(x,v)
m=zeros(size(x));
for i=1:length(v)
    m(x==i)=v(i);
end
% ws=5;
% kernel=ones(ws)/ws^2;
% m=conv2(m,kernel,'same');
m = imgaussfilt(m,0.5);
