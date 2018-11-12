function [X,Y,amp,corr,drate]=prepare(nr,looks,folder,beammode,ind)
if nargin<4
    ind=1;
end
X=readslcs(folder,nr,beammode);
amp=X(ind).amp;
Y=readcs(folder,nr,looks);
[drate,~,index,t]=fitcurve(Y,X(ind).id,folder,3);
[~,loc]=min(t);
corr=Y(index(loc)).phase;
corr=imresize(corr,size(amp));
drate=imresize(-drate,size(amp));