function locm = lochist(m,x,y,ws)
[s1,s2] = size(m);
hw = floor(ws/2);
xmin = max(1,x-hw);
xmax = min(s1,x+hw);
ymin = max(1,y-hw);
ymax = min(s2,y+hw);
locm = m(xmin:xmax,ymin:ymax);
figure2(1),histogram(locm);
figure2(2),imagesc(locm,[0,600]),colormap('gray');