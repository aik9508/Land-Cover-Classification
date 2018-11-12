function makeDEM()
nn=3601;
dempath='../DEM/';
fid=fopen(strcat(dempath,'N29W096.hgt'),'r','ieee-be');
B1=fread(fid,[nn inf],'int16');
fclose(fid);
fid=fopen(strcat(dempath,'N29W095.hgt'),'r','ieee-be');
B2=fread(fid,[nn inf],'int16');
fclose(fid);

fid=fopen(strcat(dempath,'N28W096.hgt'),'r','ieee-be');
B3=fread(fid,[nn inf],'int16');
fclose(fid);

B4=zeros(nn,nn);
%fid=fopen('N30W095.hgt','r','ieee-be');
%B4=fread(fid,[nn inf],'int16');
%fclose(fid);

B=[B1', B2'; B3', B4'];
B(:,nn)=[];
B(nn,:)=[];

indx=B<0;
B(indx)=0;

figure;
imagesc(B);
axis equal;

fid=fopen('ss.dem','w');
fwrite(fid,B','int16');
fclose(fid);


