function [newamp,meanwateramp] = correctamp(amp,water)
wateramp=amp;
wateramp(not(water))=0;
[m,~]=size(amp);
meanwateramp=zeros(1,m);
for i=1:m
    tmp = wateramp(i,:);
    tmp = tmp(tmp>0);
    meanwateramp(i)=mean(tmp);
end
x = 2000:4500;
y = meanwateramp(x);
fitk = polyfit(x,y,1);
% hold on
% plot(x,fitk(1)*x+fitk(2));
newamp=amp;
amp0=fitk(1)*2000+fitk(2);
for i=2000:m
    newamp(i,:)=amp(i,:)*amp0/(fitk(1)*i+fitk(2));
end
newamp=min(600,newamp);