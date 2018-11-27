function [amp,corr,drate,c]=avgsupcl(folder,nr,looks,savefolder,X1,Y)
if nargin<5
	fprintf('reading slc files...\n');
	X1=readslcs(folder,nr,'fbs');
	fprintf('reading correlation files...\n');
	Y=readcs(folder,nr,looks);
end
if isequal(folder,'Houston3')
	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','darkgreen'};
elseif isequal(folder,'LaMarque')
	colormarks={'blue','brown','brown','lightgreen','red','darkgreen','brown','brown'};
elseif isequal(folder,'Houston')
	colormarks={'blue','brown','brown','lightgreen','lightgreen','red','darkgreen'};
end
corr=Y(1).phase;
fprintf('computing mean correlation..\n');
for i=2:length(Y)
	corr=corr+Y(i).phase;
end
fprintf('computing mean amplitude..\n');
amp=X1(1).amp;
sz=size(amp);
for i=2:length(X1)
    amp=amp+X1(i).amp(1:sz(1),1:sz(2));
end
amp = amp/X1.length;
fitk = load('fitk.mat');
fitk = fitk.fitk;
amp = correctmap(amp,fitk);
corr = corr/Y.length;
k = fitcurve3(Y,folder,23,1,[21,22,23]);
drate = imresize(-k,size(amp));
corr = imresize(corr,size(amp));
coords = load(strcat(folder,'/coords.mat'));
coords = coords.coords;
centers = computecenters(coords,amp,corr,drate);
sigma_corr=sqrt(var(corr(:)));
sigma_drate=sqrt(var(drate(:)));
c=supcl(centers,[102,sigma_corr,sigma_drate],amp,corr,drate);
fitkml3(c,4720,folder,'savefilename',strcat(char(savefolder),'/avgsupcl') ...
                                ,'marks',colormarks,'cutedge',[150,150,100,100]);
