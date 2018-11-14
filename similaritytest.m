addpath(genpath(pwd))
[X,Y,amp,corr,drate]=avgprepare('LaMarque',4720,4);
load('LaMarque/coords.mat')
centers = computecenters(coords,amp,corr,drate);
[c,min_dis]=supcl(centers,amp,corr,drate);
[newamp,mwatermap]=correctamp(amp,c==1);
centers = computecenters(coords,newamp,corr,drate);
[c,min_dis]=supcl(centers,newamp,corr,drate);
% ampcl;
% forestcandidate=c==6;
% cc=bwconncomp(forestcandidate);
% sampledamp1=samplecenter(forest,damp);
% norm1=norm(sampledamp1,2);
% sampledamp2=samplecenter(suburban,damp);
% norm2=norm(sampledamp2,2);
% tf=zeros(size(damp));
% for i=1:cc.NumObjects
%     testarea = cc.PixelIdxList{i};
%     meandampdensity=mean(dampdensity(testarea,:),1);
%     norm3=norm(meandampdensity,2);
%     similarity1 = sum(meandampdensity.*sampledamp1)/norm3/norm1;
%     similarity2 = sum(meandampdensity.*sampledamp2)/norm3/norm2;
%     if similarity1>similarity2
%         tf(testarea)=1;
%     else
%         tf(testarea)=2;
%     end
% end
plot 