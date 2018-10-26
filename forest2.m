nr=4720;
folder='Houston3';
beam='fbd';
ind=1;
X=readslcs(nr,folder,beam);
% read FBS data
% we use a high truncate value to avoid the situation where all blocks are
% connected
slc=X(ind).amp;
% [avg,mval]=slcmeanmin(X);
[Y,cavg]=readcs2(nr/4,folder);
% [Y,cavg]=readcs2('Houston');
drate=-fitcurve(Y,X(ind).id,folder,3);
drate=imresize(drate,size(slc));
highamp=slc>250;
c1=imresize(Y(1).phase,size(slc));
dmean=clustermean(highamp,drate);
cmean=clustermean(highamp,c1);
t=gettime(X(ind).id,folder);
ccut=0.25;
hahcld=highamp & dmean<0.2 & cmean>ccut;
hahcld=bwareaopen(hahcld,20);
forest_=highamp & not(hahcld);

%% increase connectivity
ws=10;
kernel=ones(ws)/ws^2;
forest_interp=conv2(single(forest_),kernel,'same');
forest_=forest_interp>0.05;
forest_=forest_ & slc>150;
forest_=bwareaopen(forest_,1000);