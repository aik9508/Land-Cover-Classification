function [X,Y,amp,corr,drate]=avgprepare(folder,nr,looks)
fprintf('reading slc files...\n');
X=readslcs(folder,nr,'fbs');
fprintf('reading correlation files...\n');
Y=readcs(folder,nr,looks);
corr=Y(1).phase;
fprintf('computing mean correlation..\n');
for i=2:length(Y)
    corr=corr+Y(i).phase;
end
fprintf('computing mean amplitude..\n');
amp=X(1).amp;
sz=size(amp);
for i=2:length(X)
    amp=amp+X(i).amp(1:sz(1),1:sz(2));
end
amp = amp/length(X);
% correct amplitude
fitk = load('fitk.mat');
fitk = fitk.fitk;
amp = correctamp(amp,fitk);
corr = corr/length(Y);
k = fitcurve3(Y,folder,23,1,[3,5,21,22,23]);
drate = imresize(-k,size(amp));
corr = imresize(corr,size(amp));

