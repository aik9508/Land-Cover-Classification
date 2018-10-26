nr=4720;
folder='Houston3';
beam='fbd';
X=readslcs(nr,folder,beam);
ind=2;
% read FBS data
% we use a high truncate value to avoid the situation where all blocks are
% connected
slc=X(ind).amp;
% [avg,mval]=slcmeanmin(X);
[Y,cavg]=readcs2(nr/4,folder);
% [Y,cavg]=readcs2('Houston');
drate=-fitcurve(Y,X(ind).id,folder,3);
% [dcenters,dlbs]=adaptcluster_kmeans(drate);
for i=1:length(Y)
    if isequal(char(Y(i).data1),char(X(ind).id))
        c1=Y(i).phase;
        break;
    end
end
% [ccenters,clbs]=adaptcluster_kmeans(c1);
c1=imresize(c1,size(slc));
drate=imresize(drate,size(slc));
dcut=0.1;
ccut=0.4;
x0=slc>220;

% cmean=clustermean(x0,c1);
x1=rmlowval(x0,c1,ccut,0);
% remove all clusters with high coherence decreasing rate
% dmean=clustermean(x0,decreaserate);
% x2=x1 & dmean<0.02;
x2=rmhighval(x1,drate,dcut,0);
% enlarge the remaining area so that isolated points can be connected to
% form large blocks
ws=10;
kernel=ones(ws)/ws^2;
x3=conv2(single(x2),kernel,'same');
% remove areas with low density
x3=x3>0.05;
% use a lower value to increase connectivity
x4=(slc>200).*x3; % 200 fbd
% continue to increase connectivity
x5=bwmorph(x4,'bridge');
cmean=clustermean(x5,c1);
dmean=clustermean(x5,drate);
% remove all clusters with high coherence decreasing rate
x6=x5 & cmean>ccut & dmean<dcut*0.9;
% continue to increase connectivity
x7=not(bwareaopen(not(x6),30));
x7=clean(x7);
