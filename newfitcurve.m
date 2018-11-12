a=1083;
b=262;
n=length(Z)-2;
y=zeros(n,1);
for i=1:n
    y(i)=Z(i).phase(a,b);
end