function [m,latmin,latmax,lonmin,lonmax]=...
    fitkml3(x,nr,folder,varargin)
%% read parameters
grayindex=find(strncmpi(varargin,'gray',4), 1);
latindex=find(strcmpi(varargin,'lat'), 1);
if ~isempty(latindex)
    lats=varargin{latindex+1};
    assert(numel(lats)==2 && lats(2)>lats(1),...
           'Input your latitude range as [lat_min,lat_max]');
end
lonindex=find(strcmpi(varargin,'lon'),1);
if ~isempty(lonindex)
    lons=varargin{lonindex+1};
    assert(numel(lons)==2 && lons(2)>lons(1),...
           'Input your longitude range as [lon_min, lon_max]');
end
saveindex=find(strncmpi(varargin,'savefilename',4),1);
if ~isempty(saveindex)
    savefilename=varargin{saveindex+1};
end
markindex=find(strncmpi(varargin,'marks',4),1);
if ~isempty(markindex)
    marks=varargin{markindex+1};
end
cbindex=find(strncmpi(varargin,'colorbar',5),1);
if ~isempty(cbindex)
    cb=varargin{cbindex+1};
end
rangeindex=find(strncmpi(varargin,'range',5),1);
if ~isempty(rangeindex)
    range=varargin{rangeindex+1};
    assert(numel(range)==2 && range(2)>range(1),...
           'Input the range of your data as [v_min, v_max]');
end
cutedgeindex=find(strncmpi(varargin,'cutedge',3),1);
if ~isempty(cutedgeindex)
    offsets=varargin{cutedgeindex+1};
    assert(numel(offsets)==2 || numel(offsets)==4);
end


%% read lat & lon
% get the latitude and longitude coordinates for target region, which 
% should be a oblique rectangle
fid=fopen(strcat(folder,'/lat'));
lat=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);
fid=fopen(strcat(folder,'/lon'));
lon=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);
if ~isempty(cutedgeindex)
    if numel(offsets)==2
        lat=lat(offsets(1)+1:end-offsets(2),:);
        lon=lon(offsets(1)+1:end-offsets(2),:);
        x=x(offsets(1)+1:end-offsets(2),:);
    else
        lat=lat(offsets(1)+1:end-offsets(2),offsets(3)+1:end-offsets(4));
        lon=lon(offsets(1)+1:end-offsets(2),offsets(3)+1:end-offsets(4));
        x=x(offsets(1)+1:end-offsets(2),offsets(3)+1:end-offsets(4));
    end
end

% resample data to make it have the same size as lat/lon
if ~isequal(size(x),size(lat))
    x=imresize(x,size(lat));
end

% number of points in range and azimuth direction
[nr,na]=size(lat);
latmax=max(lat(:));
latmin=min(lat(:));
lonmax=max(lon(:));
lonmin=min(lon(:));
fprintf('Lat/lon information for the entire area:\n');
fprintf('lat_min=%7.4f,lat_max=%7.4f\n',latmin,latmax);
fprintf('lon_min=%7.4f,lon_max=%7.4f\n',lonmin,lonmax);
if ~isempty(latindex)
    lats(1)=max(latmin,lats(1));
    lats(2)=min(latmax,lats(2));
end
if ~isempty(lonindex)
    lons(1)=max(lonmin,lons(1));
    lons(2)=min(lonmax,lons(2));
end
if ~isempty(latindex) || ~isempty(lonindex)
    fprintf('Lat/lon information for the cropped area:\n');
    fprintf('lat_min=%7.4f,lat_max=%7.4f\n',lats(1),lats(2));
    fprintf('lon_min=%7.4f,lon_max=%7.4f\n',lons(1),lons(2));
end

dlat=lat(1,2)-lat(1,1);
dlon=lon(2,1)-lon(1,1);
fprintf('Geo projection:\n');
fprintf('dlat=%5.4E,dlon=%5.4E\n',dlat,dlon);

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
%count=max(1,count);
m=m./max(1,count);

%% interpolation
cc=bwconncomp(count==0);
if ~isempty(markindex)
	sz=size(m);
	npts=sz(1)*sz(2);
	for i = 1:cc.NumObjects
		if length(cc.PixelIdxList{i})<=100
			idx=cc.PixelIdxList{i}(1);
			%if length(cc.PixelIdxList)==1
			%	idx=cc.PixelIdxList{i};
			%	neighbourmask=[idx+1,idx-1,idx-nresamplon,idx+nresamplon];
			%	neighbourmask=max(1,min(neighbourmask,npts));
			%else	
			%	[ki,kj] = ind2sub(sz,cc.PixelIdxList{i});
			%	neighbourmask=[];
			%	neighbourmask(sub2ind(sz,max(1,ki-1),kj))=1;
			%	neighbourmask(sub2ind(sz,min(sz(1),ki+1),kj))=1;
			%	neighbourmask(sub2ind(sz,ki,max(1,kj-1)))=1;
			%	neighbourmask(sub2ind(sz,ki,min(sz(2),kj+1)))=1;
			%	neighbourmarks=round(m(find(neighbourmask>0)));
			%end
			%fprintf('Size of the hole:%d ',length(cc.PixelIdxList{i}));
			%fprintf('Size of it neighbour:%d ',length(neighbourmarks));
			%mmark=majoritymark(neighbourmarks,length(marks));	
			%fprintf('majority mark: %d \n', mmark);
			m(cc.PixelIdxList{i})=m(idx-1);
			if mod(i,100000)==0
				fprintf('Filling the %d th holes, total number of holes: %d\n',i,cc.NumObjects);
			end
		end
	end
    m=round(m);
else
	gap=zeros(nresamplat,nresamplon);
	for i = 1:length(cc.PixelIdxList)
		if length(cc.PixelIdxList{i})<=100
			gap(cc.PixelIdxList{i})=1;
		end
	end
	[xx,yy]=meshgrid([1:nresamplat,1:nresamplon]);
	m=fillgap(xx,yy,m,gap);
end

%% trucate the image if necessary
if ~isempty(latindex)
    indlatmax=max(round((latmax-lats(1))/dlat),1);
    indlatmin=max(round((latmax-lats(2))/dlat),1);
else
    indlatmax=nresamplat;
    indlatmin=1;
end
if ~isempty(lonindex)
    indlonmin=max(round((lons(1)-lonmin)/dlon),1);
    indlonmax=max(round((lons(2)-lonmin)/dlon),1);
else
    indlonmax=nresamplon;
    indlonmin=1;
end
if indlatmin~=1 || indlatmax~=nresamplat ||...
   indlonmin~=1 || indlonmax~=nresamplon
    m=m(indlatmin:indlatmax,indlonmin:indlonmax);
    gap=gap(indlatmin:indlatmax,indlonmin:indlonmax);
    [nresamplat,nresamplon]=size(m);
end

%% plot
if ~isempty(saveindex)
    mask=zeros(nresamplat,nresamplon);
    m(isinf(m))=0;
    m(isnan(m))=0;
    mask(m~=0)=1;
    if isempty(rangeindex)
        minm = min(m(:));
        maxm = max(m(:));
    else
        minm=range(1);
        maxm=range(2);
    end

    if ~isempty(grayindex)
        dout=(m-minm)/(maxm-minm);
        imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
    elseif ~isempty(markindex)
        dout=zeros(nresamplat,nresamplon,3);
        for k=1:length(marks)
            switch marks{k}
                case 'cyan'
                    color=[0,255,255]/255;
                case 'darkgreen'
                    color=[0,100,0]/255;
                case 'lightgreen'
                    color=[204,255,204]/255;
                case 'brown'
                    color=[139,69,19]/255;
                case 'red'
                    color=[255,0,0]/255;
                case 'blue'
                    color=[30,144,255]/255;
                case 'orange'
                    color=[255,128,0]/255;
                case 'violet'
                    color=[114,58,147]/255;
                case 'yellow'
                    color=[255,255,0]/255;
                otherwise
                    color=[255,255,255]/255;
            end
            tmp=zeros(nresamplat,nresamplon);
            tmp(m==k)=1;
            dout=dout+reshape(repmat(tmp(:),[1,3]).*color,nresamplat,nresamplon,3);
        end
        imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
    else
        % Scale to Color Map
        if ~isempty(cbindex)
            cmap=cb;
        else
            cmap=jet();
        end
        % cmap=sub(); % as defined in sub.m 
        nmap=size(cmap,1);
        dout=m-minm;
        dout=dout/(maxm-minm);
        dout=round((nmap-1)*dout);
        dout=min(nmap,max(1,dout));
        % index into the color map, creating an NxMx3 truecolor image
        dout=reshape(cmap(dout(:),:),nresamplat,nresamplon,3);
        imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);
    end
end

re=6370000;
lon_spacing=re*sin((90-abs(latmax+latmin)/2)/180*pi)*(lonmax-lonmin)/180*pi/nresamplon;
lat_spacing=re*(latmax-latmin)/180*pi/nresamplat;
fprintf('lon pixel spacing:%f m, lat pixel spaceing:%f m\n',lon_spacing,lat_spacing);

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

function mark=majoritymark(marks,markmax)
mark=1;
maxcount=sum(marks==mark);
for i=2:markmax
	count=sum(marks==i);
	if count>maxcount
		maxcount=count;
		mark=i;
	end
end

