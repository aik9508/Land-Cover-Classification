function e = energy(cm)
m = size(cm,3);
n = size(cm,4);
e = zeros(m,n);
for i = 1:m
    for j= 1:n
        e(i,j) = sum(single(cm(:,:,i,j)).^2,'all');
    end
end