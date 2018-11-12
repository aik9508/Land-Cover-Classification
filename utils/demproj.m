function dem=demproj()
% project radar corrdinates to latlon coordinates
% parameters for latlon coordinates
demfile='Houston3/ss.dem';
nlon=7201;
nlat=7201;
lon_first=-96;
lat_first=31;
lonstep=1/3600;
latstep=-1/3600;

fid=fopen(demfile);
dem0=fread(fid,[nlon,nlat],'int16','ieee-le');
fclose(fid);

%parameters for radar coordinates
nr=4720;

fid=fopen('Houston3/lat');
lat=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);
fid=fopen('Houston3/lon');
lon=fread(fid,[nr,inf],'float','ieee-le');
fclose(fid);

[nr,na]=size(lat);
sublon=(lon-lon_first)/lonstep+1;
sublat=(lat-lat_first)/latstep+1;
sublon=min(nlon,sublon);
sublat=min(nlat,sublat);
sublonl=floor(sublon);
sublatl=floor(sublat);
sublonh=ceil(sublon);
sublath=ceil(sublat);
indbl=sub2ind([nlon,nlat],sublonl,sublatl);
indbr=sub2ind([nlon,nlat],sublonh,sublatl);
indul=sub2ind([nlon,nlat],sublonl,sublath);
indur=sub2ind([nlon,nlat],sublonh,sublath);
dembl=dem0(indbl);
dembr=dem0(indbr);
demul=dem0(indul);
demur=dem0(indur);
kequal=(dembl==dembr & dembr==demul & demul==demur);
kinequal=not(kequal);
dem=zeros([nr,na]);
dem(kequal)=dembl(kequal);
dem(kinequal)=(dembl(kinequal)+dembr(kinequal)+demul(kinequal)+demur(kinequal))/4;
% demp=reshape(demp,[nr,na]);


