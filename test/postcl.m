function [lbs,centers,mindis]=postcl(folder,savefolder,centers,kmax,amp,corr,drate)
colormarks={'blue','brown','violet','yellow','cyan','lightgreen','orange','darkgreen','red','beige'};
sigma_corr = sqrt(var(corr(:)));
sigma_drate = sqrt(var(drate(:)));
scales = [102,sigma_corr,sigma_drate];
[lbs,centers,mindis]=unsupcl(kmax,centers,scales,amp,corr,drate);
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
