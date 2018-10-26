function X=readslcs(nr,folder,beam,varargin)
filelist=dir(strcat([folder,'/slc',beam,'/*.slc']));
tocrop=false;
if any(strcmpi(varargin,'crop'))
    tocrop=true;
    lats=varargin{2};
    lons=varargin{3};
    [subr,subc]=ll2ind(lats,lons,nr);
end
nfile=length(filelist);
X=repmat(struct('amp',[],'id',[]),[1,nfile]);
for i=1:nfile
    fid=fopen(strcat(filelist(i).folder,'/',filelist(i).name));
    X(i).amp=fread(fid,[nr,inf],'float','ieee-le');
    X(i).id=filelist(i).name(7:11);
    fclose(fid);
    if sum(X(i).amp(:)>400)/numel(X(i).amp)<0.01 %FBD slc \in [0,400]
        maxamp=400;
    else %FBS slc \in [0,600]
        maxamp=600;
    end
%     fprintf('filename: %s, maximum amplitude: %d\n',filelist(i).name,maxamp);
    X(i).amp=min(maxamp,X(i).amp);
    if tocrop
        X(i).amp=X(i).amp(subr,subc);
    end
end