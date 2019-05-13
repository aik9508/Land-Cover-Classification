function g = greyscale(x,l,h,n)
dv = (h-l)/n;
g = floor((x-l)/dv);
g = max(0,min(n-1,g));
g = g+1;