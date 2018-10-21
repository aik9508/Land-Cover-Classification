%08900 2007-09-26
%10242 2007-12-27
%22991 2010-05-19
%23662 2010-07-04
%25675 2010-11-19
function [X,cavg]=readcs2(folder,lats,lons)
nr=1180;
% looks=4;
% lats=[29.35,29.45];
% lons=[-95,-94.9];
if nargin == 0
    folder='.';
end
filelist=dir(strcat(folder,'/*.c'));
X=repmat(struct('amp',[],'phase',[]),[1,length(filelist)]);
for i=1:length(filelist)
    if nargin > 1
        [X(i).amp,X(i).phase]=...
            readc(strcat(filelist(i).folder,'/',filelist(i).name), ...
                  nr,'crop',lats,lons,4);
    else
        [X(i).amp,X(i).phase]=...
            readc(strcat(filelist(i).folder,'/',filelist(i).name),nr);
    end
    X(i).phase=max(0,min(1,X(i).phase));
end
% for i=1:length(X)
%     figure(i), imagesc(rot90(X(i).phase).^2);
% end
fid=fopen(strcat(folder,'/sbas_list'),'r');
t=zeros(1,length(X));
for i=1:length(X)
    tline=fgetl(fid);
    words=split(tline);
    t(i)=str2double(words(3));
end
fclose(fid);
[m,n]=size(X(1).phase);
cavg=zeros(size(X(i).phase));
for i=1:m
    for j=1:n
        for k=1:length(X)-1
            cavg(i,j)=(X(k).phase(i,j) + X(k+1).phase(i,j))/2 * ...
                      (t(k+1)-t(k));
        end
        cavg(i,j)=(cavg(i,j)+(1+X(1).phase(i,j))/2*t(1))/t(end);
    end
end
figure,imagesc(rot90(cavg))

