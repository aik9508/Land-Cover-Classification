function [water,lake,ocean]=watermark(dem,slc,decayrate,c1,X)

lake=islake(dem);
lake=rmhighval(lake,slc,80,0);
lake=rmhighval(lake,decayrate,0.45,0);
% lake=rmhighval(lake,c1,0.3,0);
ocean=bwareaopen(lake,100000);

water=slc<63;
water=water|ocean;
water=bwmorph(water,'clean');
water=bwmorph(water,'spur');
water=bwmorph(water,'hbreak');
water=bwareaopen(water,100);
water=bwmorph(water,'bridge');
water=bwmorph(water,'fill');
water=not(bwareaopen(not(water),30));
m=maxmean(water,X,0);
water=water & m<=67;
