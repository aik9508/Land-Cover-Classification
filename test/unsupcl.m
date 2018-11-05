function unsupcl(nr,folder,savefolder)
L=repmat(struct('lbs',[],'centers',[]),[1,6]);
X=readslcs(nr,folder,'fbs');
Y=readcs2(nr/4,folder);
for ind=1:3
	amp=X(ind).amp;
	[k,~,index,~]=fitcurve(Y,X(ind).id,folder,4);	
    corr1=imresize(Y(index(1)).phase,size(amp));
    corr2=imresize(Y(index(2)).phase,size(amp));
    corr3=imresize(Y(index(3)).phase,size(amp));
    corr4=imresize(Y(index(4)).phase,size(amp));
	amp=amp/sqrt(var(amp(:)));
	corr1=corr1/sqrt(var(corr1(:)));
	corr2=corr2/sqrt(var(corr2(:)));
	corr3=corr3/sqrt(var(corr3(:)));
	corr4=corr4/sqrt(var(corr4(:)));
	data=[reshape(amp,[1,numel(amp)]); ...
	      reshape(corr1,[1,numel(amp)]); ...
	      reshape(corr2,[1,numel(amp)]); ...
	      reshape(corr3,[1,numel(amp)]); ...
	      reshape(corr4,[1,numel(amp)])];
	data=data';
    [tmp,L(ind).centers]=kmeans(data,9);
	L(ind).lbs=sortlbs(tmp,L(ind).centers);
	L(ind).lbs=reshape(L(ind).lbs,size(amp));
	fitkml(L(ind).lbs,nr,folder,strcat(char(savefolder),'/',char(X(ind).id)),['b','m','c','r','v','y','i','h','o'],false);
end

X=readslcs(nr,folder,'fbd');
for ind=1:3
	amp=X(ind).amp;
	[k,~,index,~]=fitcurve(Y,X(ind).id,folder,4);	
    corr1=imresize(Y(index(1)).phase,size(amp));
    corr2=imresize(Y(index(2)).phase,size(amp));
    corr3=imresize(Y(index(3)).phase,size(amp));
    corr4=imresize(Y(index(4)).phase,size(amp));
	amp=amp/sqrt(var(amp(:)));
	corr1=corr1/sqrt(var(corr1(:)));
	corr2=corr2/sqrt(var(corr2(:)));
	corr3=corr3/sqrt(var(corr3(:)));
	corr4=corr4/sqrt(var(corr4(:)));
	data=[reshape(amp,[1,numel(amp)]); ...
	      reshape(corr1,[1,numel(amp)]); ...
	      reshape(corr2,[1,numel(amp)]); ...
	      reshape(corr3,[1,numel(amp)]); ...
	      reshape(corr4,[1,numel(amp)])];
	data=data';
    [tmp,L(ind+3).centers]=kmeans(data,9);
	L(ind+3).lbs=sortlbs(tmp,L(ind+3).centers);
	L(ind+3).lbs=reshape(L(ind+3).lbs,size(amp));
	fitkml(L(ind+3).lbs,nr,folder,strcat(char(savefolder),'/',char(X(ind).id)),['b','m','c','r','v','y','i','h','o'],false);
	save(strcat(char(savefolder),'/',char(folder),'.mat'),'L');
end

function [newlbs]=sortlbs(lbs,centers)
[~,P]=sort(centers(:,1));
newlbs=zeros(size(lbs));
for i=1:length(P)
	newlbs(lbs==P(i))=i;	
end
