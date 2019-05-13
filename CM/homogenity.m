function h=homogenity(cm)
greylevel = size(cm,1);
den = 1+abs((1:greylevel)-(1:greylevel)');
m = size(cm,3);
n = size(cm,4);
h = zeros(m,n);
for i = 1:m
    for j= 1:n
        h(i,j) = sum(single(cm(:,:,i,j))./den,'all');
    end
end