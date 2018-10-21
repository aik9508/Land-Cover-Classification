function k=decay(X,folder)
nd=numel(X);
[m,n]=size(X(1).phase);
y=zeros(m*n,nd+1);
y(:,1)=1;
windowsize=10;
h=ones(windowsize)/(windowsize^2);
for i=1:nd
    y(:,i+1)=reshape(conv2(single(X(i).phase),h,'same'),[m*n,1]);
end
t=gettime(folder);
t=[1,t];
x=log(t);
y=log(y);
xm=mean(x);
den=mean(x.^2)-xm^2;
k=(mean(y.*x,2)-xm*mean(y,2))/den;
k=reshape(k,[m,n]);
k=(k+0.35)/0.3;
k=max(0,min(1,k));