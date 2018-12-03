function plottrainingsets(trainingsets,labels,order)
n=max(labels(:));
figure;
hold on
for i=1:n
    idx=labels==i;
    plot3(trainingsets(idx,1),trainingsets(idx,2),trainingsets(idx,3),'.',...
            'displayname',order{i});
end
legend('show');
xlabel('amplitude');
ylabel('correlaiton');
zlabel('decorrelation rate');