function [amp,corr,drate,c]=avgsupcl(nr,looks,folder,savefolder)
X1=readslcs(folder,nr,'fbs');
Y=readcs(folder,nr,looks);
colormarks=[];
if isequal(folder,'Houston3')
	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','darkgreen'};
elseif isequal(folder,'LaMarque')
	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','brown','brown'};
elseif isequal(folder,'Houston')
	colormarks={'blue','brown','brown','lightgreen','lightgreen','red','darkgreen'};
end
corr=Y(1).phase;
for i=2:length(Y)
    corr=corr+Y(i).phase;
end
amp=X1(1).amp;
sz=size(amp);
for i=2:length(X1)
    amp=amp+X1(i).amp(1:sz(1),1:sz(2));
end
k = fitcurve2(nr,folder);
drate = imresize(-k,size(amp));
corr = imresize(corr,size(amp));
coords = load(strcat(folder,'/coords.mat'));
coords = coords.coords;
centers = computecenters(coords,amp,corr,drate);
c=classification(centers,amp,corr,drate);
fitkml3(c,4720,folder,'savefilename',strcat(char(savefolder),'/avgsupcl') ...
                                ,'marks',colormarks,'cutedge',[150,150,100,100]);