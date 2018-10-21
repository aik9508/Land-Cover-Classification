function [latmin,latmax,lonmin,lonmax]=...
    fitkml(x,nr,folder,savefilename,markflag,grayflag,lats,lons)
% filename='22991_26346.flat';
% % nr=4720;
% [amp,~]=readflat(filename,nr);
% amp=10*log10(amp);
% x=amp;

% get the latitude and longitude coordinates for target region, which
% should be a oblique rectangle
fid=fopen(strcat(folder,'/lat'));
lat=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);
fid=fopen(strcat(folder,'/lon'));
lon=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);

if nargin>=7
    latcuts=and(lat>=lats(1),lat<=lats(2));
    loncuts=and(lon>lons(1),lon<=lons(2));
    ind=find(and(latcuts,loncuts));
    [subr,subc]=ind2sub(size(lat),ind);
    subr=min(subr):max(subr);
    subc=min(subc):max(subc);
    lat=lat(subr,subc);
    lon=lon(subr,subc);
end
if ~isequal(size(x),size(lat))
    [sx1,sx2]=size(x);
    lat=lat(1:sx1,1:sx2);
    lon=lon(1:sx1,1:sx2);
end

% number of range and azimuth points
[nr,na]=size(lat);
latmax=max(lat(:));
latmin=min(lat(:));
lonmax=max(lon(:));
lonmin=min(lon(:));

dlat=lat(1,2)-lat(1,1);
dlon=lon(2,1)-lon(1,1);
nresamplat=round((latmax-latmin)/dlat);
nresamplon=round((lonmax-lonmin)/dlon);
m=zeros(nresamplat,nresamplon);
count=zeros(nresamplat,nresamplon);
for i=1:nr
    for j=1:na
        indlat=max(round((latmax-lat(i,j))/dlat),1);
        indlon=max(round((lon(i,j)-lonmin)/dlon),1);
        count(indlat,indlon)=count(indlat,indlon)+1;
        m(indlat,indlon)=m(indlat,indlon)+x(i,j);
    end
end
count=max(1,count);
m=m./count;
nodata=find((m==0));
for i=2:length(nodata)-1
    if m(nodata(i)-1)~=0 && m(nodata(i)+1)~=0
        m(nodata(i))=(m(nodata(i)-1)+m(nodata(i)+1))/2;
    end
end
if nargin>4 && markflag
    m=round(m);
    m=rmsmallobjects(m,10,2);
end
    
mask=zeros(nresamplat,nresamplon);
m(isinf(m))=0;
m(isnan(m))=0;
mask(m>0)=1;
minm = min(m(:));
maxm = max(m(:));
    
if grayflag
    dout=(m-minm)/(maxm-minm);
    imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
else
    % Scale to Color Map
    cmap=jet();
    % cmap=sub(); % as defined in sub.m 
    nmap = size(cmap,1);
    

    dout=m-minm;
    dout=dout/(maxm-minm);
    dout=round((nmap-1)*dout);
    dout=dout+1;

    % index into the color map, creating an NxMx3 truecolor image
    dout=reshape(cmap(dout(:),:),nresamplat,nresamplon,3);
    imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
end

