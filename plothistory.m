function plothistory(x,y,t,X,displayname)
ch=zeros(1,length(X));
for i=1:length(X)
    ch(i)=mean(mean(X(i).phase(x-5:x+5,y-5:y+5)));
end
t=t/30;
if nargin<5
    plot(t,ch,'Displayname',sprintf('(%d,%d)',x,y),'Linewidth',2);
else
    plot(t,ch,'Displayname',displayname,'Linewidth',2);
end
axis([t(1),t(end),0,0.7]);
% title(sprintf('correlation history (%d,%d)',x,y));