function t = gettime(folder)
filelist=dir(strcat(folder,'/*.c'));
nd=length(filelist);
files1=string([1,nd]);
files2=string([1,nd]);
for i=1:nd
    files=split(filelist(i).name,[string('_'),string('.')]);
    files1(i)=files(1);
    files2(i)=files(2);
end
fid=fopen(strcat(folder,'/sbas_list'),'r');
t=zeros(1,nd);
k=1;
while ~feof(fid)
    if k>nd 
        break
    end
    tline=fgetl(fid);
    words=split(tline);
    if contains(words(1),files1(k)) && contains(words(2),files2(k))
        fprintf('file1: %s, file2: %s\n',files1(k),files2(k));
        t(k)=str2double(words(3));
        k=k+1;
    end
end
fclose(fid);
