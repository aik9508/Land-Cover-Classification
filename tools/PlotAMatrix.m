clc;clear all;
%% Load DEM data
width = 7345;
length = 2269;
lat = 72.16;
lon = -53.5;
dlat = -0.000277778;
dlon = 0.000277778;

dempath ='/Users/chen-admin/Desktop/GreenlandProject/ArcticDemUmi/gldem.dem';
fid=fopen(dempath,'r','ieee-le');
B=fread(fid,[width inf],'int16');
fclose(fid);

% Transparent Mask
mask = zeros(size(B));
mask(B > 0) = 1;

% view result
figure;
imagesc(mask');
axis equal;
colorbar;

% Scale to Color Map
cmap=jet();
% cmap=sub(); % as defined in sub.m 
Nmap = size(cmap,1);
minDEM = min(B(:));
maxDEM = max(B(:));

dout=B-minDEM;
dout=dout/(maxDEM-minDEM);
dout=round((Nmap-1)*dout);
dout=dout+1;

% index into the color map, creating an NxMx3 truecolor image
dout=reshape(cmap(dout(:),:),width,length,3);
imwrite(dout,sprintf('%s.png','umiDEM'),'Alpha',mask);
