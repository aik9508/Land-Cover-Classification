function plotlbs(lbs,amp,corr,drate)
n=max(lbs(:));
N=1000000;
k=round(rand(1,N)*numel(amp))+1;
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