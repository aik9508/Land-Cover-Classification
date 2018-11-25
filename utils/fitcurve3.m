function [k,b,uniquet,Z]=fitcurve3(Y,folder,ndata,windowsize,removal)
%FITCURVE3 decorrelation rate.
% A power function of the form c=exp(b)*t^k is used to fit the coherence
% history.

% Input:
% Y: all correlation matrices
% folder: where to find 'sbas_list' file
% ndata: number of points used to fit decorrelation
% windowsize: size of the kernel used to smooth correlation data
% If not specified, its default value is 1
% removal: the correlation data that should be removed before fitting
% If not specified, its default value is []

% Output:
% k: decorrelation rate fitted by a power function:
% correlation(t) = exp(b)*t^{k}, where the unit of t is year
% b: see the definition of k
% uniquet: temporal baselines in increasing order
% Z: new correlation matrices. Note that if two or more correlation data
% have the same temporal baseline, their mean value will be stored in Z
if nargin<5
    removal=[];
end
if nargin<4
    windowsize=1;
end
t=gettime('_',folder)/12;
[ts,perm]=sort(t);
uniquet=unique(t);
nc=length(uniquet);
ny=length(t);
ind=1;
%Y=readcs(folder,nr,looks);
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
ndata=min(ndata,nc);
removal(removal>ndata)=[];
y=zeros(m*n,ndata);
for i=1:ndata
    y(:,i)=reshape(conv2(Z(i).phase,kernel,'same'),[m*n,1]);
end
% y=y+0.5;
y(:,removal)=[];
uniquet(removal)=[];
ndata=ndata-length(removal);
lowcorr=y(:,1)<0.2; 
% If the correlation with the least temporal baseline is less than 0.2, it
% will be reasonable to assume that the decorrelation rate is zero.
x=log(uniquet(1:ndata)/30);
% x=uniquet(1:ndata)/30;
w=y.^2;
y=log(y);
A=sum(w.*x.^2,2);
B=sum(w.*x,2);
C=sum(w.*y.*x,2);
D=sum(w.*y,2);
E=sum(w,2);
k=(E.*C-B.*D)./(A.*E-B.^2);
b=(A.*D-C.*B)./(A.*E-B.^2);
k(lowcorr)=0;
k(isnan(k))=0;
k=min(0,k);
k=reshape(k,[m,n]);
b=reshape(b,[m,n]);
