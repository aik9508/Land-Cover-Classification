function test4(nr,folder,savefolder)
L=repmat(struct('lbs',[],'centers',[]),[1,4]);
for ind=1:3
	[X,Y,amp,corr,drate]=prepare(nr,folder,'fbs',ind);
	amp=amp/sqrt(var(amp(:)));
	corr=corr/sqrt(var(corr(:)));
	drate=drate/sqrt(var(drate(:)));
	data=[reshape(amp,[1,numel(amp)]);reshape(corr,[1,numel(amp)]);reshape(drate,[1,numel(amp)])];
	data=data';
    [tmp,L(ind).centers]=kmeans(data,9);
	L(ind).lbs=sortlbs(tmp,L(ind).centers);
	L(ind).lbs=reshape(L(ind).lbs,size(amp));
	fitkml(L(ind).lbs,nr,folder,strcat(char(savefolder),'/',char(X(ind).id)),['b','m','c','r','v','y','i','h','o'],false);
end
for ind=1:3
	[X,Y,amp,corr,drate]=prepare(nr,folder,'fbd',ind);
	amp=amp/sqrt(var(amp(:)));
	corr=corr/sqrt(var(corr(:)));
	drate=drate/sqrt(var(drate(:)));
	data=[reshape(amp,[1,numel(amp)]);reshape(corr,[1,numel(amp)]);reshape(drate,[1,numel(amp)])];
	data=data';
	[tmp,L(ind+3).centers]=kmeans(data,9);
	L(ind+3).lbs=sortlbs(tmp,L(ind+3).centers);
	L(ind+3).lbs=reshape(L(ind+3).lbs,size(amp));
	fitkml(L(ind+3).lbs,nr,folder,strcat(char(savefolder),'/',char(X(ind).id)),['b','m','c','r','v','y','i','h','o'],false);
end
save(strcat(char(savefolder),'/',char(folder),'.mat'),'L');

function [newlbs]=sortlbs(lbs,centers)
[~,P]=sort(centers(:,1));
newlbs=zeros(size(lbs));
for i=1:length(P)
	newlbs(lbs==P(i))=i;	
end
