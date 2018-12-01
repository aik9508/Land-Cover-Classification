function lbs = mlcl(centers,centervars,scales,windowsize,centerweight,varargin)
dim = length(varargin);
fprintf('dimension of data: %d\n',dim);
[nclass,~] = size(centers);
fprintf('number of classes: %d\n',nclass);
sz = size(varargin{1});
likelihood = zeros([sz,nclass]);
halfwindowsize = round(windowsize/2);
windowsize = halfwindowsize*2+1;
kernel = (1-centerweight)/(windowsize^2-1)*ones(windowsize);
kernel(halfwindowsize+1,halfwindowsize+1)=centerweight;
for i=1:dim
	fprintf('computing likelihood, dimension %d, total %d\n',i,dim);
	varargin{i} = varargin{i}/scales(i);
	centers(:,i) = centers(:,i)/scales(i);
	centervars(:,i) = centervars(:,i)/(scales(i)^2);
	for j=1:nclass
		fprintf('computing likelihood, iteration %d, total %d\n',j,nclass)
		tmp = (varargin{i}-centers(j,i)).^2/(2*centervars(j,i));
		likelihood(:,:,j) = likelihood(:,:,j)+conv2(tmp,kernel,'same');
	end
end
likelihood = reshape(likelihood,[sz(1)*sz(2),nclass]);
[likelihood,lbs] = min(likelihood,[],2);
lbs = reshape(lbs,sz);

