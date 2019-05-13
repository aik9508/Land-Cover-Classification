function cm=coocurrenceMatrix(dx,dy,g,greylevel,windowsize)
[m,n] = size(g);
cm = zeros(greylevel,greylevel,m,n,'int8');
x_aug = -1*ones(m,abs(dx));
y_aug = -1*ones(abs(dy),n);

% padding -1 to the augmented g matrix
if dx > 0
    g_aug = [g(:,dx+1:end),x_aug];
elseif dx<0
    g_aug = [x_aug,g(:,1:end+dx)];
end
if dy > 0
    g_aug = [g(dy+1:end,:);y_aug];
elseif dy<0
    g_aug = [y_aug;g(1:end+dy)];
end
for i = 1:greylevel
    for j = 1:greylevel
        tmp = g==i & g_aug==j;
        cm(i,j,:,:) = conv2(tmp,ones(windowsize),'same');
    end
end
