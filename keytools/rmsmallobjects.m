function y=rmsmallobjects(x,nc,order)
if nargin==2 || order == 1
    bw1=bwareaopen(x,nc);
    y=1-bwareaopen(1-bw1,nc);
else
    bw1=1-bwareaopen(1-x,nc);
    y=bwareaopen(bw1,nc);
end
% bw1=bwareaopen(x,nc);
% y=1-bwareaopen(1-bw1,nc);