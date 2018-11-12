function k=fitcurve3(folder,nr,looks,ndata,windowsize)
t=gettime('_',folder);
[ts,perm]=sort(t);
uniquet=unique(t);
nc=length(uniquet);
if nargin<3
	ndata=nc-3;
end
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
k=y(:,2:end)-y(:,1:end-1);
k=min(k,0);
k=sum(k,2);
k=reshape(k,m,n);