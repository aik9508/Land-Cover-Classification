% x=y>0;
function y=c6(x)
nold=0;
[m,n]=size(x);
v1=zeros(m,2);
v2=zeros(2,n);
n=sum(x(:));
se=strel('diamond',1);
while n-nold>100
    nold=n;
    x=1-bwareaopen(1-x,10000);
    x=imdilate(x,se);
    xl=[x(:,3:end),v1];
    xr=[v1,x(:,1:end-2)];
    xu=[x(3:end,:);v2];
    xd=[v2;x(1:end-2,:)];
    x=(xl & xr)|(xu & xd)|x;
    x=imerode(x,se);
    n=sum(x(:));
    fprintf('nold=%d, n=%d, n-nold=%d\n',nold,n,n-nold);
end
y=x;
