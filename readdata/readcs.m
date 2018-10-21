%08900 2007-09-26
%10242 2007-12-27
%22991 2010-05-19
%23662 2010-07-04
%25675 2010-11-19
function [X,cc]=readcs(lats,lons)
nr=1180;
% looks=4;
% lats=[29.35,29.45];
% lons=[-95,-94.9];
filelist=dir('*.c');
X=repmat(struct('amp',[],'phase',[]),[1,length(filelist)]);
for i=1:length(filelist)
    if nargin > 0
        [X(i).amp,X(i).phase]=readc(filelist(i).name,nr,'crop',lats,lons,4);
    else
        [X(i).amp,X(i).phase]=readc(filelist(i).name,nr);
    end
    X(i).phase=max(0,min(1,X(i).phase));
end
% for i=1:length(X)
%     figure(i), imagesc(rot90(X(i).phase).^2);
% end
fid=fopen('sbas_list','r');
telapsed=zeros(1,length(X));
for i=1:length(X)
    tline=fgetl(fid);
    words=split(tline);
    telapsed(i)=str2double(words(3));
end
fclose(fid);
telapsed=telapsed/telapsed(1)-1;
wdecay=0;
telapsed=exp(wdecay*telapsed);
cc=X(1).phase;
for i=2:length(X)
    cc=cc+X(i).phase*telapsed(i);
end
% cc=10*log10(cc);
% cc=max(-120,cc);
cc=cc/length(X);
figure,imagesc(rot90(cc))
title(sprintf('decay rate: %f',wdecay));

