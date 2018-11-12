folder='LaMarque';
X1=readslcs(folder,4720,'fbs');
Y=readcs(folder,4720,4);
% X2=readslcs(folder,4720,'fbd');
corr=Y(1).phase;
for i=2:length(Y)
    corr=corr+Y(i).phase;
end
amp=X1(1).amp;
sz=size(amp);
for i=2:length(X1)
    amp=amp+X1(i).amp(1:sz(1),1:sz(2));
end
drate=zeros(size(corr));
count=0;
for i=1:length(X1)
    t=gettime(X1(i).id,folder);
    if numel(t)>5
        count=count+1;
        k=fitcurve(Y,X1(i).id,'LaMarque',7);
        drate=drate+k;
    end
end
drate = -drate/count;
drate = imresize(drate,size(amp));
corr = imresize(corr,size(amp));