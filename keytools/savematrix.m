function m=savematrix(m,savefilename,looks,maskflag)
[s1,s2]=size(m);
if looks>1
    s1=round(s1/looks);
    s2=round(s2/looks);
end
m=imresize(m,[s1,s2]);
if nargin>3 && maskflag
    mask=zeros(size(m));
    m(isinf(m))=0;
    m(isnan(m))=0;
    mask(m>0)=1;
else
    mask=ones(size(m));
end
% Scale to Color Map
cmap=jet();
% cmap=sub(); % as defined in sub.m 
nmap = size(cmap,1);
minm = min(m(:));
maxm = max(m(:));
dout=m-minm;
dout=dout/(maxm-minm);
dout=round((nmap-1)*dout);
dout=dout+1;

% index into the color map, creating an NxMx3 truecolor image
dout=reshape(cmap(dout(:),:),s1,s2,3);
imwrite(dout,sprintf('%s.png',savefilename),'Alpha',mask);