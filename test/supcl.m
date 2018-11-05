function supcl(nr,folder,savefolder)
X1=readslcs(nr,folder,'fbs');
X2=readslcs(nr,folder,'fbd');
L1=repmat(struct('c',[],'mindis',[]),[1,length(X1)]);
L2=repmat(struct('c',[],'mindis',[]),[1,length(X2)]);
Y=readcs2(nr/4,folder);
sz=size(X1(1).amp);
coords=load(strcat(folder,'/coords.mat'));
coords=coords.coords;
colormarks=[];
if isequal(folder,'Houston3')
	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','darkgreen'};
elseif isequal(folder,'LaMarque')
	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','brown','brown'};
elseif isequal(folder,'Houston')
	colormarks={'blue','brown','brown','lightgreen','lightgreen','red','darkgreen'};
end
for ind=1:length(X1)
	fprintf('processing data:%s\n',X1(ind).id);
	amp=X1(ind).amp;
	if ~isequal(size(amp),sz)
		amp=amp(1:sz(1),1:sz(2));
	end
	[k,~,index,~]=fitcurve(Y,X1(ind).id,folder,6);	
    corr=imresize(Y(index(1)).phase,sz);
	drate=-imresize(k,sz);
	centers=computecenters(coords,amp,corr,drate);
	[c,min_dis]=classification(centers,amp,corr,drate);
	L1(ind).c=c;
	L1(ind).mindis=min_dis;
	[~,latmin,latmax,lonmin,lonmax]=fitkml3(L1(ind).c,nr,folder,'savefilename',strcat(char(savefolder),'/',char(X1(ind).id)),'marks',colormarks,'cutedge',[150,150]);
end

for ind=1:length(X2)
	amp=X2(ind).amp;
	fprintf('processing data:%s\n',X2(ind).id);
	if ~isequal(size(amp),sz)
		amp=amp(1:sz(1),1:sz(2));
	end
	[k,~,index,~]=fitcurve(Y,X2(ind).id,folder,6);	
    corr=imresize(Y(index(1)).phase,sz);
	drate=-imresize(k,sz);
	centers=computecenters(coords,amp,corr,drate);
	[c,min_dis]=classification(centers,amp,corr,drate);
	L2(ind).c=c;
	L2(ind).mindis=min_dis;
	[~,latmin,latmax,lonmin,lonmax]=fitkml3(L1(ind).c,nr,folder,'savefilename',strcat(char(savefolder),'/',char(X1(ind).id)),'marks',colormarks,'cutedge',[150,150]);
end
