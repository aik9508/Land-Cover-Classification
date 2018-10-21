a=70:-10:0;
b=0.28:-0.04:0;
dk=0.05/(length(b)+length(a)-2);
se=strel('disk',1);
z=zeros(size(slc));
for i = 1:length(a)
    for j = 1:length(b)
        mask=slc<=a(i) & cavg<=b(j) & land;
%         mask=imdilate(mask,se);
        fprintf('%d, %d, %d\n',i,j,sum(mask(:)));
        z(mask)=max(z(mask),0.05-dk*(i+j-2));
    end
end