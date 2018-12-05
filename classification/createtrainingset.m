function trainingset = createtrainingset(coords,plotflag,varargin)
xmin=coords(1);
xmax=coords(3);
ymin=coords(2);
ymax=coords(4);
[xx,yy]=meshgrid(xmin:xmax,ymin:ymax);
xx=reshape(xx',[1,numel(xx)]);
yy=reshape(yy',[1,numel(yy)]);
sz=size(varargin{1});
idx=sub2ind(sz,xx,yy);
trainingset=zeros(numel(idx),length(varargin));
for i=1:length(varargin)
    trainingset(:,i)=transpose(varargin{i}(idx));
end
if plotflag
    for i=1:length(varargin)
        crop=reshape(varargin{i}(idx),[xmax-xmin+1,ymax-ymin+1]);
        figure,imagesc(crop),colormap('jet'),colorbar;
        figure,histogram(crop);
    end
end
