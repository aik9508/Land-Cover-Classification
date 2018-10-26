function [X,cavg]=readcs2(nr,folder,lats,lons)
% looks=4;
% lats=[29.35,29.45];
% lons=[-95,-94.9];
if nargin < 2
    folder='.';
end
filelist=dir(strcat(folder,'/*.c'));
X=repmat(struct('phase',[],'data1',[],'data2',[]),[1,length(filelist)]);
for i=1:length(filelist)
    data=split(filelist(i).name,[string('_'),string('.')]);
    X(i).data1=data(1);
    X(i).data2=data(2);
    if nargin > 2
        [~,X(i).phase]=...
            readc(strcat(filelist(i).folder,'/',filelist(i).name), ...
                  nr,'crop',lats,lons,4);
    else
        [~,X(i).phase]=...
            readc(strcat(filelist(i).folder,'/',filelist(i).name),nr);
    end
    X(i).phase=max(0,min(1,X(i).phase));
end
cavg=[];
% t=gettime([],folder);
% [m,n]=size(X(1).phase);
% cavg=zeros(size(X(i).phase));
% for i=1:m
%     for j=1:n
%         for k=1:length(X)-1
%             cavg(i,j)=(X(k).phase(i,j) + X(k+1).phase(i,j))/2 * ...
%                       (t(k+1)-t(k));
%         end
%         cavg(i,j)=(cavg(i,j)+(1+X(1).phase(i,j))/2*t(1))/t(end);
%     end
% end
% figure,imagesc(rot90(cavg))

