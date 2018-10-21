% change RADAR coordinate to lat-lon coordinate
% use file 'lat' and 'lon'

clear all
close all

fidlat = fopen('lat');
lat = fread(fidlat,'float');
fclose(fidlat);
fidlon = fopen('lon');
lon = fread(fidlon,'float');
fclose(fidlon);

Nrange = 1085;
nr = Nrange;
naz = 843;
adlook = 4;

period = nr*adlook;
lat = lat(1:(Nrange*naz*adlook^2),:);
lon = lon(1:(Nrange*naz*adlook^2),:);

nump = size(lat); nump = nump(1);
for k = 1:nump
    j = rem(k,period);
    if j == 0
        j = period;
    end
    i = (k-j)/period+1;
    latref(j,i) = lat(k);
    lonref(j,i) = lon(k);
end
blk = [adlook adlook];
sz = size(latref);
latref = reshape(sum(reshape(sum(reshape(latref,sz(1),blk(2),[]),2),blk(1),[]),1),sz./blk);
lonref = reshape(sum(reshape(sum(reshape(lonref,sz(1),blk(2),[]),2),blk(1),[]),1),sz./blk);
latref = latref/(adlook^2);
lonref = lonref/(adlook^2);

flatFiles = dir('*.c');
numfiles = length(flatFiles);
mydata = cell(1, numfiles);
% 
% for k = 1:numfiles 
%  
% fid=fopen(flatFiles(k).name);
% dat{k}=fread(fid,[2*Nrange,inf],'float','ieee-le');
% fclose(fid);
% 
% end

k = 2;
fid=fopen(flatFiles(k).name);
dat{k}=fread(fid,[2*Nrange,inf],'float','ieee-le');
fclose(fid);
amp{k}=dat{k}(1:nr,:);
phase{k}=dat{k}((nr+1):end,:);

% Define GeoGrid
max_lat = 69; min_lat = 68.46;
min_lon = -151; max_lon = -149.1;
dlat = -0.000277778; dlon = 0.000277778;
dlat = 3*dlat; dlon = 3*dlon;
length = round((min_lat-max_lat)/dlat)+1;
width = round((max_lon-min_lon)/dlon)+1;
geox = zeros(length,width);
amp1 = zeros(length,width);
mask1 = zeros(length,width);
for jj = 1: width
    disp(jj);
  for ii = 1:length
      latout= max_lat + dlat*(ii-1); 
      lonout = min_lon + dlon*(jj-1);
      distance = sqrt((latref-latout).^2 + (lonref-lonout).^2);
      [minimum,indexinput] = min(distance(:));
      thresh = 2*sqrt(dlat^2 +dlon^2);
      if minimum<thresh && indexinput>0 % set a threshold
          geox(ii,jj) = phase{k}(indexinput);
          amp1(ii,jj) = amp{k}(indexinput);
          mask1(ii,jj)=1;
      else
          geox(ii,jj) = 0;
          amp1(ii,jj) = 0;
      end
%       ylatout = find(abs(latref-latout)<0.001); % change this value to control number of points
%       xlonout = find(abs(lonref-lonout)<0.001); % change this value to control number of points
%       if size(ylatout,1)>=1 && size(xlonout,1)>=1
%         mm = 0;
%         for kk = 1:size(xlonout,1)
%             ztemp = find(abs(ylatout-xlonout(kk))<0.1); % change value to control precision
%             if ztemp>=1
%                 mm = mm+1;
%                 z(mm) = ylatout(ztemp);
%             end
%         end
%         if mm<1
%             geox(ii,jj) = 0;
%         else
%             distance = sqrt((latref(z)-latout).^2+(lonref(z)-lonout).^2);
%             [minimum,indexinput] = min(distance);
%             indexinput = z(indexinput);
%             geox(ii,jj) = phase{k}(indexinput);
%         end
%       else
%           geox(ii,jj) = 0;
%       end
  end
end
% write output file
save('ll')
fid=fopen('test.un','w'); %
fwrite(fid,[amp1'; geox'],'float');
fclose(fid);

% % Scale to Color Map
% cmap=jet();
% Nmap = size(cmap,1);
% % scale to 1:Nmap, with 0 always in the middle
% mingeox = min(min(geox(:)),-max(geox(:)));
% maxgeox = max(-min(geox(:)),max(geox(:)));
% geoxout=geox-mingeox;
% geoxout=geoxout/(maxgeox-mingeox);
% geoxout=round((Nmap-1)*geoxout);
% geoxout=geoxout+1;
% % index into the color map, creating an NxMx3 truecolor image
% geoxout=reshape(cmap(geoxout(:),:),length,width,3);
% imwrite(geoxout,'Toolik-q.png','Alpha',mask1);