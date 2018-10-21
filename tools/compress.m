function compress(filename,nr,rlooks,alooks)
% filename='10242_23662.flat';
% nr=4720;
% rlooks=4;
% alooks=4;
fid=fopen(filename);
dat=fread(fid, [2*nr,inf],'float','ieee-le');
fclose(fid);
dat=dat(1:2:end,:)+1j*dat(2:2:end,:);
dat=abs(dat);
na=size(dat,2);
sampr=1:rlooks:nr;
sampa=1:alooks:na;
if sampr(end) < nr
    sampr=[sampr,nr];
end
if sampa(end) < na
    sampa=[sampa,na];
end
newnr=length(sampr)-1;
newna=length(sampa)-1;
compdat=zeros(newnr,newna);
for i=1:newnr
    for j=1:newna
        block=dat(sampr(i):sampr(i+1),sampa(j):sampa(j+1));
        compdat(i,j)=mean(block(:));
    end
end
words=strsplit(filename,'.');
fid=fopen(strcat(words{1},'looks.',words{2}),'w');
fwrite(fid,compdat,'float','ieee-le');
fclose(fid);
