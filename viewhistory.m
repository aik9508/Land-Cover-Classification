function viewhistory(cavg,X)
[m,n]=size(cavg);
tmp=cavg;
t=gettime('LaMarque');
xsample=100:200:m;
ysample=100:300:n;
for i=xsample
    tmp(i-2:i+2,:)=1;
end
for j=ysample
    tmp(:,j-1:j+1)=1;
end
imshow(rot90(tmp),[0.04,0.11]);
for i=xsample
    figure
    hold on
    for j=ysample
        plothistory(i,j,t,X);
    end
    legend('show')
    hold off
end

