function y=connect(x,ws,m,vtruncate,ntruncate)
nold=0;
% [m,n]=size(x);
% v1=zeros(m,2);
% v2=zeros(2,n);
n=sum(x(:));
se=strel('arbitrary',eye(2));
while abs(n-nold)>1000
    nold=n;
    x=1-bwareaopen(1-x,200);
%     x=imdilate(x,se);
    xl=zeros(size(x));
    xr=zeros(size(x));
    xu=zeros(size(x));
    xd=zeros(size(x));
    for k=1:ws
        xl(:,k+1:end) = xl(:,k+1:end) | x(:,1:end-k);
        xr(:,1:end-k) = xr(:,1:end-k) | x(:,k+1:end);
        xu(k+1:end,:) = xu(k+1:end,:) | x(1:end-k,:);
        xd(1:end-k,:) = xd(1:end-k,:) | x(k+1:end,:);
    end
%     xr=[v1,x(:,1:end-2)];
%     xu=[x(3:end,:);v2];
%     xd=[v2;x(1:end-2,:)];
    x=(xl & xr)|(xu & xd)|x;
%     x=rmlowval(x,m,vtruncate,ntruncate);
%     x=imerode(x,se);
    n=sum(x(:));
    fprintf('nold=%d, n=%d, n-nold=%d\n',nold,n,n-nold);
end
y=x;
