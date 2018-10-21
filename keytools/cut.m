function y=cut(x,nr,lats,lons,looks)
if nargin<=4
    [subr,subc]=ll2ind(lats,lons,nr);
else
    [subr,subc]=ll2ind(lats,lons,nr,looks);
end
y=x(subr,subc);