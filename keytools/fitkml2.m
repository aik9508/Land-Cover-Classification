function [latmin,latmax,lonmin,lonmax]=...
    fitkml2(x,nr,savefilename,lats,lons)

% get the latitude and longitude coordinates for target region, which
% should be a oblique rectangle
% x=lmark;
% nr=4720;
% savefilename='landmark';
fid=fopen('lat');
lat=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);
fid=fopen('lon');
lon=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);

if nargin>=5
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
    lat=imresize(lat,size(x));
    lon=imresize(lon,size(x));
end

% number of range and azimuth points
[nr,na]=size(lat);
latmax=max(lat(:));
latmin=min(lat(:));
lonmax=max(lon(:));
lonmin=min(lon(:));

e1=[lat(1,2)-lat(1,1),lon(1,2)-lon(1,1)];
e2=[lat(2,1)-lat(1,1),lon(2,1)-lon(1,1)];
% Assume we have a vector v that we want to express in v = x e1 + y e2
% Then we need to solve the equation:
% (v,e1) = x(e1,e1) + y(e2,e1)
% (v,e2) = x(e1,e2) + y(e2,e2)
% let a11=(e1,e1), a22=(e2,e2), a12=a21=(e1,e2)
% x = (a22(v,e1)-a12(v,e2))/(a11*a22-a12^2)
% y = (-a12(v,e1)+a22(v,e2))/(a11*a22-a12^2)
a11=e1*e1';
a12=e1*e2';
a22=e2*e2';
det=a11*a22-a12^2;

dlat=lat(1,2)-lat(1,1);
dlon=lon(2,1)-lon(1,1);
nresamplat=ceil((latmax-latmin)/dlat);
nresamplon=ceil((lonmax-lonmin)/dlon);
m=zeros(nresamplat,nresamplon);

for i=1:nresamplat
    for j=1:nresamplon
        v = [latmax-(i-1)*dlat-lat(1,1);lonmin+(j-1)*dlon-lon(1,1)];
        indlat = (a22*e1*v-a12*e2*v)/det;
        indlon = (-a12*e1*v+a11*e2*v)/det;
        indlat = max(round(indlat),1);
        indlon = max(round(indlon),1);
        if indlon<=nr && indlat <=na
            m(i,j)=x(indlon,indlat);
        end
    end
end
% for i=1:nr
%     for j=1:na
%         indlat=max(round((latmax-lat(i,j))/dlat),1);
%         indlon=max(round((lon(i,j)-lonmin)/dlon),1);
%         count(indlat,indlon)=count(indlat,indlon)+1;
%         m(indlat,indlon)=m(indlat,indlon)+x(i,j);
%     end
% end
% count=max(1,count);
% m=m./count;
% nodata=find((m==0));
% for i=2:length(nodata)-1
%     if m(nodata(i)-1)~=0 && m(nodata(i)+1)~=0
%         m(nodata(i))=(m(nodata(i)-1)+m(nodata(i)+1))/2;
%     end
% end
mask=zeros(nresamplat,nresamplon);
m(isinf(m))=0;
m(isnan(m))=0;
mask(m>0)=1;

% Scale to Color Map
cmap=jet();
% cmap=sub(); % as defined in sub.m 
nmap = size(cmap,1);
minm = min(m(:));
maxm = max(m(:));

dout=m-minm;
dout=dout/(maxm-minm);
dout=round((nmap-1)*dout);
dout=dout+1;

% index into the color map, creating an NxMx3 truecolor image
dout=reshape(cmap(dout(:),:),nresamplat,nresamplon,3);
imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);

