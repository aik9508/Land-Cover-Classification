function [X,Y,amp,corr,drate]=prepare(nr,folder,beammode,ind)
if nargin<4
    ind=1;
end
X=readslcs(nr,folder,beammode);
amp=X(ind).amp;
Y=readcs2(nr/4,folder);
[drate,~,index,t]=fitcurve(Y,X(ind).id,folder,3);
[~,loc]=min(t);
corr=Y(index(loc)).phase;
corr=imresize(corr,size(amp));
drate=imresize(-drate,size(amp));