function [X,Y,amp,corr,drate]=prepare(nr,folder,beammode,ind)
if nargin<4
    ind=1;
end
X=readslcs(nr,folder,beammode);
amp=X(ind).amp;
Y=readcs2(nr/4,folder);
drate=-fitcurve(Y,X(ind).id,folder,3);
for i=1:length(Y)
    if isequal(char(Y(i).data1),char(X(ind).id))
        corr=Y(i).phase;
        break;
    end
end
corr=imresize(corr,size(amp));
drate=imresize(drate,size(amp));