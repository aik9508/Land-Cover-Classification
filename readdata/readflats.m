function X=readflats(nr,varargin)
% X=readslcs(nr,'crop',lats,lons,'plot')
% nr=4720;
% lats=[29.35,29.45];
% lons=[-95,-94.9];
filelist=dir('*.flat');
tocrop=false;
if any(strcmpi(varargin,'crop'))
    tocrop=true;
    lats=varargin{2};
    lons=varargin{3};
    [subr,subc,ind]=ll2ind(lats,lons,nr);
    invind=[];
end
nfile=length(filelist);
X=repmat(struct('amp',[],'phase',[]),[1,nfile]);
for i=1:nfile
    fid=fopen(filelist(i).name);
    dat=fread(fid, [2*nr,inf],'float','ieee-le');
    fclose(fid);
    dat=dat(1:2:end,:)+1j*dat(2:2:end,:);
    if tocrop && isempty(invind)
        invind=setdiff(1:numel(dat)/2,ind);
    end
    X(i).amp=abs(dat);
    X(i).phase=angle(dat);
    if tocrop
        X(i).amp(invind)=1;
        X(i).phase(invind)=0;
        X(i).amp=X(i).amp(subr,subc);
        X(i).phase=X(i).phase(subr,subc);
    end
end