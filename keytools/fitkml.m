function [m,latmin,latmax,lonmin,lonmax]=...
    fitkml(x,nr,folder,savefilename,markflag,grayflag,lats,lons,cb)
% get the latitude and longitude coordinates for target region, which 
% should be a oblique rectangle
fid=fopen(strcat(folder,'/lat'));
lat=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);
fid=fopen(strcat(folder,'/lon'));
lon=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);

if ~isequal(size(x),size(lat))
    [sx1,sx2]=size(x);
    lat=lat(1:sx1,1:sx2);
    lon=lon(1:sx1,1:sx2);
end

% number of points in range and azimuth direction
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

%% interpolation
cc=bwconncomp(m==0);
gap=zeros(nresamplat,nresamplon);
for i = 1:length(cc.PixelIdxList)
    if length(m(cc.PixelIdxList{i}))<=20
        gap(cc.PixelIdxList{i})=1;
    end
end
[xx,yy]=meshgrid([1:nresamplat,1:nresamplon]);
m=fillgap(xx,yy,m,gap);
if nargin>4 && ~isempty(markflag)
    m=round(m);
end

if nargin>=7 && ~isempty(lats) && ~isempty(lons)
    indlatmax=max(round((latmax-lats(1))/dlat),1);
    indlatmin=max(round((latmax-lats(2))/dlat),1);
    indlonmin=max(round((lons(1)-lonmin)/dlon),1);
    indlonmax=max(round((lons(2)-lonmin)/dlon),1);
    m=m(indlatmin:indlatmax,indlonmin:indlonmax);
    [nresamplat,nresamplon]=size(m);
end

%% plot
mask=zeros(nresamplat,nresamplon);
m(isinf(m))=0;
m(isnan(m))=0;
mask(m>0)=1;
minm = min(m(:));
maxm = max(m(:));
    
if grayflag
    dout=(m-minm)/(maxm-minm);
    imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
elseif ~isempty(markflag)
    dout=zeros(nresamplat,nresamplon,3);
    for k=1:length(markflag)
        switch markflag(k)
            case 'c'
                color=[0,255,255]/255;
            case 'g'
                color=[0,255,128]/255;
            case 'h'
                color=[0,204,0]/255;
            case 'i'
                color=[0,153,0]/255;
            case 'j'
                color=[0,100,0]/255;
            case 'm'
                color=[139,69,19]/255;
            case 'r'
                color=[255,0,0]/255;
            case 'b'
                color=[30,144,255]/255;
            case 'o'
                color=[255,128,0]/255;
            case 'v'
                color=[114,58,147]/255;
            case 'y'
                color=[255,255,0]/255;
            otherwise
                color=[255,255,255]/255;
        end
        tmp=zeros(nresamplat,nresamplon);
        tmp(m==k)=1;
        sum(tmp(:))
        dout=dout+reshape(repmat(tmp(:),[1,3]).*color,nresamplat,nresamplon,3);
    end
    imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
else
    % Scale to Color Map
    if nargin>8
        cmap=cb;
        maxm=0.198;
    else
        cmap=jet();
    end
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

function A=fillgap(xx,yy,A,gap)
% fill the data at the points where the data is not available
sz = size(A);
mask = zeros(sz,'int8');
k = find(gap);
k(k==1|k==numel(A)) = [];
if ~isempty(k)
    [ki,kj] = ind2sub(sz,k);
    % sets to 1 every previous and next index, both in column and row order
    mask(sub2ind(sz,max(1,ki-1),kj))=1;
    mask(sub2ind(sz,min(sz(1),ki+1),kj))=1;
    mask(sub2ind(sz,ki,max(1,kj-1)))=1;
    mask(sub2ind(sz,ki,min(sz(2),kj+1)))=1;
    % removes the novalue index
    mask(k)=0;
    % keeps only border values
    kb=find(mask);
    A(k)=griddata(xx(kb),yy(kb),double(A(kb)),xx(k),yy(k));
end

