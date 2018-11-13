% label			classification
% 1				water
% 2				barren land/road
% 10			shrub
newlbs=lbs;
newlbs(lbs<=2)=1; % merge open water areas
newlbs(lbs>=3 & amp<80)=1;
newlbs(lbs>3 & amp<120)=2;
newlbs(lbs==3)=2;
ws=10;
kernel5=ones(5,5)/(5^2);
kernel10=ones(10,10)/(10^2);
hampdensity=conv2(single(lbs>8),kernel10,'same');
newlbs(lbs==5 & hampdensity<0.05)=3;
newlbs(newlbs==5 & amp<150)=2;
treedensity=conv2(single(lbs==7 | lbs==8),kernel5,'same');

