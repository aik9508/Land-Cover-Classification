% X=readslcs(4720,'LaMarque','fbs');
X=readslcs(4720,'LaMarque','fbs');
% read FBS data
% we use a high truncate value to avoid the situation where all blocks are
% connected
slc=X(1).amp;
[avg,mval]=slcmeanmin(X);
[Y,cavg]=readcs2('LaMarque');
% [Y,cavg]=readcs2('Houston');
decreaserate=-fitcurve(Y,[1,length(Y)],'LaMarque');
decreaserate=imresize(decreaserate,size(slc));
x0=slc>300; % 400 for Houston
c1=imresize(Y(1).phase,size(slc));
% cmean=clustermean(x0,c1);
x1=rmlowval(x0,c1,0.4,0);
% remove all clusters with high coherence decreasing rate
% dmean=clustermean(x0,decreaserate);
% x2=x1 & dmean<0.02;
x2=rmhighval(x1,decreaserate,0.02,0);
% enlarge the remaining area so that isolated points can be connected to
% form large blocks
ws=10;
kernel=ones(ws)/ws^2;
x3=conv2(single(x2),kernel,'same');
% remove areas with low density
x3=x3>0.05;
% use a lower value to increase connectivity
x4=(slc>220).*x3; % 200 fbd
% continue to increase connectivity
x5=bwmorph(x4,'bridge');
cmean=clustermean(x5,c1);
dmean=clustermean(x5,decreaserate);
% remove all clusters with high coherence decreasing rate
x6=x5 & cmean>0.4 & dmean<0.02;
% continue to increase connectivity
x7=not(bwareaopen(not(x6),30));
% smooth boundary
x8=bwmorph(x7,'majority');
% % compute variance for each cluster
% cmean=clustermean(x8,slc);
% % remove clusters with high variance
% c=x8 & cmean>200;
