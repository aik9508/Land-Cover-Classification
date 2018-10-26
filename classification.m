function [c,min_distance]=classification(amp,corr,drate,centers)
[nlbs,~]=size(centers);
fprintf('Land classification, number of categories: %d\n',nlbs);
npts=numel(amp);
sigma_amp=sqrt(var(amp(:)));
sigma_corr=sqrt(var(corr(:)));
sigma_drate=sqrt(var(drate(:)));
fprintf('flatten data...\n');
data=[reshape(amp/sigma_amp,[1,npts]);...
      reshape(corr/sigma_corr,[1,npts]);...
      reshape(drate/sigma_drate,[1,npts])];
distance=zeros(nlbs,npts);
for i=1:nlbs
    fprintf('Processing, iteration %d, total %d\n',i,nlbs);
    mean_amp=centers(i,1);
    mean_corr=centers(i,2);
    mean_drate=centers(i,3);
    center=[mean_amp/sigma_amp;mean_corr/sigma_corr;mean_drate/sigma_drate];
    dup_center=repmat(center,[1,npts]);
    distance(i,:)=sum((data-dup_center).^2,1);
end
min_distance=min(distance,[],1);
c=zeros(size(amp));
for i=1:nlbs
    k=min_distance==distance(i,:);
    c(k)=i;
end
