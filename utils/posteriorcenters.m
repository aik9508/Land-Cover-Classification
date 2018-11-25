function pcenters = posteriorcenters(c,n,varargin)
dim = length(varargin);
pcenters = zeros(n,dim);
for i=1:n
    a = c == i;
    for j=1:dim
        pcenters(i,j) = mean(varargin{j}(a));
    end
end