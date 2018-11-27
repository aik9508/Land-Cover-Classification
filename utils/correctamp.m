function newamp = correctamp(amp,fitk)
[m,~]=size(amp);
newamp=amp;
amp0=fitk(1)*2500+fitk(2);
amp0/(fitk(1)*4500+fitk(2))
for i=2500:m
    newamp(i,:)=amp(i,:)*amp0/(fitk(1)*i+fitk(2));
end
newamp=min(600,newamp);
