function [lbs,centers,mindis]=postcl2(folder,savefolder,centers,kmax,rigidity,amp,corr,drate)
colormarks={'blue','brown','violet','yellow','cyan','darkgreen','orange','red','lightgreen','beige'};
sigma_corr = sqrt(var(corr(:)));
sigma_drate = sqrt(var(drate(:)));
scales = load('scales.mat');
scales = scales.scales;
[lbs,centers,mindis]=unsupcl2(kmax,centers,scales,rigidity,amp,corr,drate);
[lbs,centers]=sortlbs(lbs,centers);
savefilename=sprintf('%s/avgunsupcl%d',char(savefolder),kmax);
fitkml3(lbs,4720,folder,'savefilename',savefilename ...
                                ,'marks',colormarks(1:kmax),'cutedge',[150,150,100,100]);

function [newlbs,newcenters]=sortlbs(lbs,centers)
[~,P]=sort(centers(:,1));
newlbs=zeros(size(lbs));
newcenters=zeros(size(centers));
for i=1:length(P)
	newlbs(lbs==P(i))=i;
	newcenters(i,:)=centers(P(i),:);
end
