function [amp,phase]=readc(filename,nr,varargin)
fid=fopen(filename);
dat=fread(fid,[2*nr,inf],'float','ieee-le');
fclose(fid);
amp=dat(1:nr,:);
%phase just means the actual value, whether it is the unwrapped phase or correlation
phase=dat((nr+1):end,:);
if any(strcmpi(varargin,'crop'))
    lats=varargin{2};
    lons=varargin{3};
    if length(varargin)>3 
        looks=varargin{4};
    else
        looks=[];
    end
    [subr,subc]=ll2ind(lats,lons,nr*looks,looks);
%     invind=setdiff(1:numel(dat)/2,ind);
%     amp(invind)=1;
%     phase(invind)=0;
    amp=amp(subr,subc);
    phase=phase(subr,subc);
end