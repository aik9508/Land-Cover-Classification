function plotlbs2(lbs,coords,amp,corr,drate)
n=max(lbs(:));
xmin=coords(1);
xmax=coords(3);
ymin=coords(2);
ymax=coords(4);
[xx,yy]=meshgrid(xmin:xmax,ymin:ymax);
xx=reshape(xx',[1,numel(xx)]);
yy=reshape(yy',[1,numel(yy)]);
sz=size(amp);
k=sub2ind(sz,xx,yy);
figure;
hold on;
for i=1:n
%     if i==4 || i==6
    idx = intersect(find(lbs==i),k);
    plot3(amp(idx),corr(idx),drate(idx),'.','displayname',sprintf('%d',i));
%     end
end
xlabel('amplitude');
ylabel('correlaiton');
zlabel('decorrelation rate');
legend('show');