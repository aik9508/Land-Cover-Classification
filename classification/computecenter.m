function center=computecenter(coords,plotflag,varargin)
xmin=coords(1:4:end);
xmax=coords(3:4:end);
ymin=coords(2:4:end);
ymax=coords(4:4:end);
indices=[];
for k=1:length(xmin)
    if xmin(k)==0 && xmax(k)==0
        break;
    end
    [xx,yy]=meshgrid(xmin(k):xmax(k),ymin(k):ymax(k));
    xx=reshape(xx',[1,numel(xx)]);
    yy=reshape(yy',[1,numel(yy)]);
    sz=size(varargin{1});
    index=sub2ind(sz,xx,yy);
    indices=[indices,index];
    if plotflag
        for i=1:length(varargin)
            crop=reshape(varargin{i}(index),[xmax(k)-xmin(k)+1,ymax(k)-ymin(k)+1]);
            figure,imagesc(rot90(crop)),colormap('jet'),colorbar;
            figure,histogram(crop);
        end
    end
end
center=zeros(1,length(varargin));
for i=1:length(varargin)
    center(i)=mean(varargin{i}(indices));
end
