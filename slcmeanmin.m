function [avg,mval]=slcmeanmin(X)
nd=length(X);
[m,n]=size(X(1).amp);
y=zeros(m*n,nd);
for i=1:nd
    y(:,i)=reshape(X(i).amp(1:m,1:n),[m*n,1]);
end
avg=reshape(mean(y,2),[m,n]);
mval=reshape(min(y,[],2),[m,n]);