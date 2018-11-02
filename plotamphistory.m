function plotamphistory(x,y,X,t,color,displayname)
ch=zeros(1,length(X));
ws=2;
for i=1:length(X)
    ch(i)=mean(mean(X(i).amp(x-ws:x+ws,y-ws:y+ws)));
end
t=t/30;
% k=polyfit(log(t+1),log(ch),1);
if nargin<=5
    plot(t,ch,strcat(color,'o'),'Displayname',sprintf('(%d,%d)',x,y),'Linewidth',2);
else
    plot(t,ch,strcat(color,'o'),'Displayname',displayname,'Linewidth',2);
end
% hold on
% plot(t,t.^k(1)*exp(k(2)),color,'Linewidth',2);
% hold off
xlabel('Time/month','Fontsize',15);
ylabel('Amplitude','Fontsize',15);
title('Amplitude history','Fontsize',20);
axis tight
% title(sprintf('correlation history (%d,%d)',x,y));