a=400:-10:250;
b=1.2:-0.04:0.52;
dk=(1.2-0.9)/(length(b)+length(a)-1);
se=strel('disk',1);
y=zeros(size(slc));
for i = 1:length(a)
    for j = 1:length(b)
        mask=slc>a(i) & cavg>b(j);
%         mask=imdilate(mask,se);
        fprintf('%d, %d, %d\n',i,j,sum(mask(:)));
        y(mask)=max(y(mask),1.2-dk*(i+j-2));
    end
end