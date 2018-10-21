% x=y>0;
function y=c5(x)
nold=0;
[m,n]=size(x);
v1=zeros(m,1);
v2=zeros(1,n);
n=sum(x(:));
se=strel('diamond',1);
while n-nold>100
    nold=n;
    x=1-bwareaopen(1-x,10000);
    x=imdilate(x,se);
    xl=[x(:,2:end),v1];
    xr=[v1,x(:,1:end-1)];
    xu=[x(2:end,:);v2];
    xd=[v2;x(1:end-1,:)];
    x=(xl & xr)|(xu & xd)|x;
    x=imerode(x,se);
    n=sum(x(:));
    fprintf('nold=%d, n=%d, n-nold=%d\n',nold,n,n-nold);
end
y=x;
