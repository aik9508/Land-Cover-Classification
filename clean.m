function y=clean(x,xcut)
ws=100;
kernel=ones(ws)/ws^2;
density=conv2(single(x),kernel,'same');
meandensity=clustermean(x,density);
y=meandensity>xcut;