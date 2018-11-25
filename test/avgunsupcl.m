function [amp,corr,drate,lbs]=avgunsupcl(folder,nr,looks,savefolder,kmax)
X1=readslcs(folder,nr,'fbs');
% X2=readslcs(folder,nr,'fbd');
Y=readcs(folder,nr,looks);
%if isequal(folder,'Houston3')
%	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','darkgreen'};
%elseif isequal(folder,'LaMarque')
%	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','brown','brown'};
%elseif isequal(folder,'Houston')
%	colormarks={'blue','brown','brown','lightgreen','lightgreen','red','darkgreen'};
%end
colormarks={'blue','brown','violet','yellow','cyan','lightgreen','orange','darkgreen','red','beige'};
corr=Y(1).phase;
for i=2:length(Y)
    corr=corr+Y(i).phase;
end
amp=X1(1).amp;
sz=size(amp);
for i=2:length(X1)
    amp=amp+X1(i).amp(1:sz(1),1:sz(2));
end
k = fitcurve2(Y,folder,nr,looks,20,1,[3,5]);
drate = imresize(-k,size(amp));
%drate=zeros(size(corr));
%count=0;
%for i=1:length(X1)
%    t=gettime(X1(i).id,folder);
%    if numel(t)>5
%        count=count+1;
%        k=fitcurve(Y,X1(i).id,folder,7);
%        drate=drate+k;
%    end
%end
%for i=1:length(X2)
%    t=gettime(X2(i).id,folder);
%    if numel(t)>5
%        count=count+1;
%        k=fitcurve(Y,X2(i).id,folder,7);
%        drate=drate+k;
%    end
%end
%drate = -drate/count;
%drate = imresize(drate,size(amp));
corr = imresize(corr,size(amp));
[lbs,centers]=unsupcl(kmax,amp,corr,drate);
lbs=sortlbs(lbs,centers);
savefilename=sprintf('%s/avgunsupcl%d',char(savefolder),kmax);
fitkml3(lbs,4720,folder,'savefilename',savefilename ...
        ,'marks',colormarks(1:kmax),'cutedge',[150,150,100,100]);

function [newlbs]=sortlbs(lbs,centers)
[~,P]=sort(centers(:,1));
newlbs=zeros(size(lbs));
for i=1:length(P)
	newlbs(lbs==P(i))=i;	
end
