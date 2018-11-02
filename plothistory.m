function plothistory(x,y,t,X,index,k,b,color,displayname)
ch=zeros(1,length(index));
ws=2;
for i=1:length(index)
    ch(i)=mean(mean(X(index(i)).phase(x-ws:x+ws,y-ws:y+ws)));
end
uniquet=unique(sort(t));
t=t/30;
uniquet=uniquet/30;
if nargin<=8
    plot(t,ch,strcat(color,'o'),'Displayname',sprintf('(%d,%d)',x,y),'Linewidth',2);
else
    plot(t,ch,strcat(color,'o'),'Displayname',displayname,'Linewidth',2);
end
if nargin>5
    hold on
    
%     plot(uniquet,k(x,y)*uniquet+b(x,y),'Linewidth',2);
%     plot(uniquet,0.1+exp(k(x,y)*uniquet+b(x,y)),'Linewidth',2);
    plot(uniquet,exp(b(x,y))*uniquet.^k(x,y),color,'Linewidth',2);
    hold off
end
xlabel('Time/month','Fontsize',15);
ylabel('Coherence','Fontsize',15);
title('Coherence history','Fontsize',20);
axis([0,uniquet(end),0,1]);
% title(sprintf('correlation history (%d,%d)',x,y));