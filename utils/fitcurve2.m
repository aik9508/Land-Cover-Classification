function [k,b,index,uniquet,Z,x,y]=fitcurve2(folder,nr,looks,ndata,windowsize,removal)
t=gettime('_',folder)/12;
[ts,perm]=sort(t);
uniquet=unique(t);
nc=length(uniquet);
ny=length(t);
ind=1;
Y=readcs(folder,nr,looks);
Z=repmat(struct('phase',[]),[1,nc]);
for i=1:length(uniquet)
    count=0;
    phase=zeros(size(Y(1)));
    while ind<=ny && ts(ind)==uniquet(i)
        phase=phase+Y(perm(ind)).phase;
        count=count+1;
        ind=ind+1;
    end
    Z(i).phase=phase/count;
end

kernel=ones(windowsize)/(windowsize^2);
[m,n]=size(Z(1).phase);
y=zeros(m*n,ndata);
for i=1:ndata
    y(:,i)=reshape(conv2(Z(i).phase,kernel,'same'),[m*n,1]);
end
y(:,removal)=[];
uniquet(removal)=[];
ndata=nc-length(removal);
x=log(uniquet(1:ndata)/30);
y=log(y+0.5);
A=sum(x.^2);
B=sum(x);
C=sum(y.*x,2);
D=sum(y,2);
k=(ndata*C-B*D)/(A*ndata-B^2);
b=(A*D-C*B)/(A*ndata-B^2);
k=reshape(k,[m,n]);
b=reshape(b,[m,n]);
k(isnan(k))=0;
index=1:nc-length(removal);
x=uniquet(1:ndata)/30;