function y=cut(x,folder,nr,lats,lons,looks)
if nargin<=5
    [subr,subc]=ll2ind(folder,nr,lats,lons);
else
    [subr,subc]=ll2ind(folder,nr,lats,lons,looks);
end
y=x(subr,subc);