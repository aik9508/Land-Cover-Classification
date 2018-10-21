function [subr,subc,ind]=ll2ind(lats,lons,Nrange,varargin)
% ind = ll2ind(lats,lons,Nrange) computes the relative
% position of a target region in a large region. 
% lats contains the range of the latitude of the target region
% lons contains the range of the longitude of the target region
% Nrange is the number of range samples for the entire large region.
fid=fopen('lat');
lat=fread(fid,[Nrange,inf],'float','ieee-le');
if ~isempty(varargin)
    looks=varargin{1};
else
    looks=1;
end
if looks>1
    lat=lat(1:looks:end,1:looks:end);
    lat=(lat(1:end-1,1:end-1)+lat(2:end,1:end-1)+...
        lat(1:end-1,2:end)+lat(2:end,2:end))/4;
end
fclose(fid);
latind=and(lat>=lats(1),lat<=lats(2));

fid=fopen('lon');
lon=fread(fid,[Nrange,inf],'float','ieee-le');
if looks>1
    lon=lon(1:looks:end,1:looks:end);
    lon=(lon(1:end-1,1:end-1)+lon(2:end,1:end-1)+...
        lon(1:end-1,2:end)+lon(2:end,2:end))/4;
end
fclose(fid);
lonind=and(lon>lons(1),lon<=lons(2));
ind=find(and(latind,lonind));
[subr,subc]=ind2sub(size(lat),ind);
subr=min(subr):max(subr);
subc=min(subc):max(subc);







