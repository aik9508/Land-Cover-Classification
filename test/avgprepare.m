function [X,Y,amp,corr,drate]=avgprepare(nr,looks,folder)
% if isequal(folder,'Houston3')
% 	gooddata = {'10242','10193','11584','22991','23662','25675','26346'};
% end
X=readslcs(folder,nr,'fbs');
% X2=readslcs(folder,nr,'fbd');
Y=readcs(folder,nr,looks);
corr=Y(1).phase;
for i=2:length(Y)
    corr=corr+Y(i).phase;
end
amp=X(1).amp;
sz=size(amp);
for i=2:length(X)
    amp=amp+X(i).amp(1:sz(1),1:sz(2));
end
drate=zeros(size(corr));
count=0;
for i=1:length(X)
    t=gettime(X(i).id,folder);
    if numel(t)>5 % && ismember(X(i).id,gooddata)
        count=count+1;
        k=fitcurve(Y,X(i).id,folder,7);
		k=max(-1,k);
		savematrix(-k,sprintf('drate%s',X(i).id),1);
        drate=drate+k;
    end
end
% for i=1:length(X2)
%     t=gettime(X2(i).id,folder);
%     if numel(t)>5 && ismember(X2(i).id,gooddata)
%         count=count+1;
%         k=fitcurve(Y,X2(i).id,folder,7);
% 		k=max(-1,k);
% 		savematrix(-k,sprintf('drate%s',X2(i).id),1);
%         drate=drate+k;
%     end
% end
drate = -drate/count;
drate = resizem(drate,size(amp),'bilinear');
corr = resizem(corr,size(amp),'blinear');
