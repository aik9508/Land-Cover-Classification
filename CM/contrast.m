function c=contrast(cm)
greylevel = size(cm,1);
f = ((1:greylevel)-(1:greylevel)').^2;
m = size(cm,3);
n = size(cm,4);
c = zeros(m,n);
for i = 1:m
    for j= 1:n
        c(i,j) = sum(single(cm(:,:,i,j)).*f,'all');
    end
end