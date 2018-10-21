folder='Houston';
beam='fbd';
isfbs=isequal(beam,'fbs');
load(strcat(folder,'/dem.mat'));
lake=islake(dem);
ocean=bwareaopen(lake,2000);

X=readslcs(4720,folder,beam); %fbd
slc=X(1).amp();
[Y,cavg]=readcs2(folder);
drate=-fitcurve(Y,[1,length(Y)]);
drate=imresize(drate,size(slc));
c1=imresize(Y(1).phase,size(slc));
[avg,mval]=slcmeanmax(X);

% crop
slc=slc(1:4600,:);
c1=c1(1:4600,:);
drate=drate(1:4600,:);
ocean=ocean(1:4600,:);
lake=lake(1:4600,:);
mval=mval(1:4600,:);

if isfbs
    water=mval<130; %90
else
    water=mval<90;
end
water=bwmorph(water,'clean');
water=bwmorph(water,'spur');
water=bwmorph(water,'hbreak');
water=bwareaopen(water,50);
water=bwmorph(water,'bridge');
water=bwmorph(water,'fill');
water=not(bwareaopen(not(water),30));
smean=clustermean(water,slc);
cmean=clustermean(water,c1);
dmean=clustermean(water,drate);
if isfbs
    water=water & smean<103; %60
else
    water=water & smean<60;
end
water=water & cmean<0.3;
water=water & dmean<0.012;

if isfbs
    island=ocean & mval>170;
else
    island=ocean & mval>115;
end
island=bwareaopen(island,2000);
water=water | (ocean & not(island));