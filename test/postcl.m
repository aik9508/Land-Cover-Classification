function lbs=postcl(folder,savefolder,kmax,amp,corr,drate)
colormarks={'blue','brown','violet','yellow','cyan','lightgreen','orange','darkgreen','red','beige'};
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
