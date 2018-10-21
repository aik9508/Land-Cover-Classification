function [amp, phase]=readflat(filename,nr,varargin)
% filename='10242_23662.flat';
% Nrange=4720;
% lats=[29.35,29.45];
% lons=[-95,-94.9];
fid=fopen(filename);
dat=fread(fid, [2*nr,inf],'float','ieee-le');
fclose(fid);
image= dat(1:2:end,:)+1j*dat(2:2:end,:);
amp = abs(image);
phase = angle(image);
if any(strcmpi(varargin,'crop'))
    lats=varargin{2};
    lons=varargin{3};
    if length(varargin)>3 
        looks=varargin{4};
    else
        looks=1;
    end
    [subr,subc,ind]=ll2ind(lats,lons,nr*looks,looks);
    invind=setdiff(1:numel(dat)/2,ind);
    amp(invind)=1;
    phase(invind)=0;
    amp=amp(subr,subc);
    phase=phase(subr,subc);
end