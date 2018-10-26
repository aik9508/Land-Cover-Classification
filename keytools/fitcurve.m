function k=fitcurve(X,data1,folder,ndata)
%% find all 'data1_*.c' files
count=0;
index=zeros(1,length(X));
for i=1:length(X)
    if isequal(char(X(i).data1),char(data1))
        count=count+1;
        index(count)=i;
    end
end
count=min(ndata,count);
index=index(1:count);

[m,n]=size(X(1).phase);
y=zeros(m*n,count);
windowsize=5;
kernel=ones(windowsize)/(windowsize^2);
for i=1:count
    y(:,i)=reshape(conv2(single(X(index(i)).phase),kernel,'same'),[m*n,1]);
end
t=gettime(data1,folder);
t=t(1:count);
x=t/30;
y=log(y);
xm=mean(x);
den=mean(x.^2)-xm^2;
k=(mean(y.*x,2)-xm*mean(y,2))/den;
k=reshape(k,[m,n]);
k=min(0,k);