function [amp,phase]=readc(filename,nr,looks)
n=nr/looks;
fid=fopen(filename);
dat=fread(fid,[2*n,inf],'float','ieee-le');
fclose(fid);
amp=dat(1:n,:);
phase=dat((n+1):end,:);