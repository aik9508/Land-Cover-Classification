function k=fitcurve(X,interval,folder)
[m,n]=size(X(1).phase);
y=zeros(m*n,interval(2)-interval(1)+1);
windowsize=5;
h=ones(windowsize)/(windowsize^2);
for i=1:interval(2)-interval(1)+1
    y(:,i)=reshape(conv2(single(X(i).phase),h,'same'),[m*n,1]);
end
t=gettime(folder);
t=t(interval(1):interval(2));
x=t/30;
y=log(y);
xm=mean(x);
den=mean(x.^2)-xm^2;
k=(mean(y.*x,2)-xm*mean(y,2))/den;
k=reshape(k,[m,n]);
k=min(0,k);
% k=(k+0.35)/0.3;
% k=max(0,min(1,k));