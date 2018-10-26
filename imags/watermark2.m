folder='Houston';
beam='fbs';
nr=4720;
isfbs=isequal(beam,'fbs');
load(strcat(folder,'/dem.mat'));
lake=islake(dem);
ocean=bwareaopen(lake,5000);

X=readslcs(nr,folder,beam);
ind=1;
slc=X(ind).amp;
[Y,cavg]=readcs2(nr/4,folder);
drate=-fitcurve(Y,X(ind).id,folder,3);
for i=1:length(Y)
    if isequal(char(Y(i).data1),char(X(ind).id))
        c1=Y(i).phase;
        break;
    end
end
c1=imresize(c1,size(slc));
drate=imresize(drate,size(slc));
[avg,mval]=slcmeanmax(X);

crop
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
water=water & cmean<0.20;
water=water & dmean<0.15;

if isfbs
    island=ocean & mval>170;
else
    island=ocean & mval>115;
end
island=bwareaopen(island,2000);
water=water | (ocean & not(island));