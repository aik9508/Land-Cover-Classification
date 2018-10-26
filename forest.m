nr=4720;
folder='Houston';
beam='fbs';
% X=readslcs(nr,folder,beam);
ind=1;
% read FBS data
% we use a high truncate value to avoid the situation where all blocks are
% connected
% slc=X(ind).amp;
% [avg,mval]=slcmeanmin(X);
% [Y,cavg]=readcs2(nr/4,folder);
% [Y,cavg]=readcs2('Houston');
% drate=-fitcurve(Y,X(ind).id,folder,3);
% drate=imresize(drate,size(slc));
% for i=1:length(Y)
%     if isequal(char(Y(i).data1),char(X(ind).id))
%         c1=Y(i).phase;
%         break;
%     end
% end
% c1=imresize(c1,size(slc));

highamp=slc>350;
dmean=clustermean(highamp,drate);
cmean=clustermean(highamp,c1);
hahcld=dmean<0.2 & cmean>0.4;
forest_=highamp & not(hahcld);

%% increase connectivity
forest_=clean(forest_,0.1);
ws=10;
kernel=ones(ws)/ws^2;
forest_interp=conv2(single(forest_),kernel,'same');
forest_=forest_interp>0.1;
% forest_=forest_ & slc>150;