function map=getcolormap(cbarfile,n,cmapname)
%% generate the colormap from a colorbar
if nargin<2 || isempty(n)
    n=256;
end
X=imread(cbarfile);
% [~,map]=rgb2ind(X,n);
line=size(X,1);
column=size(X,2);
midcolumn=round(column/2);
samplelines=linspace(1,line,min(line,n));
samplelines=floor(samplelines);
map=X(samplelines,midcolumn,1:3);
map=double(reshape(map,[size(map,1),3]))/256;
map=flipud(map);

%% write the colormap to a .m file
if nargin<3 || isempty(cmapname)
    cmapname = 'customizedcmap';
end
fid = fopen(strcat(cmapname,'.m'),'w');
fprintf(fid,'function y = %s(n)\n',cmapname);
fprintf(fid,'J = [ ...\n');
for i=1:n
    fprintf(fid,'\t%5.4f\t%5.4f\t%5.4f\n',map(i,1),map(i,2),map(i,3));
end
fprintf(fid,'];\n');
fprintf(fid,'l = length(J);\n');
fprintf(fid,'if nargin<1\n');
fprintf(fid,'\tn = 256;\n');
fprintf(fid,'end\n');
fprintf(fid,'y = interp1(1:l,J,linspace(1,l,n),''*linear'');\n');
fclose(fid);
