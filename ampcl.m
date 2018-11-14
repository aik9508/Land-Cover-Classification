ws = 10;
delta_amp = 50;
damp = round(amp/delta_amp);
n = max(damp(:));
kernel = ones(ws)/ws.^2;
dampdensity=zeros([numel(damp),n]);
for i=1:n
    dampdensity(:,i)=reshape(conv2(single(damp==i),kernel,'same'),numel(damp),1);
end
sample = damp(forest(1):forest(3),forest(2):forest(4));
sampledamp = zeros(1,n);
npts = numel(sample);
for i=1:n
    sampledamp(i) = sum(sum(sample==i))/npts;
end