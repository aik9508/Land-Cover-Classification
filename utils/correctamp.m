function newamp = correctamp(amp,fitk)
newamp=amp;
amp0=fitk(1)*2500+fitk(2);
for i=2500:4500
    newamp(i,:)=amp(i,:)*amp0/(fitk(1)*i+fitk(2));
end
newamp=min(600,newamp);