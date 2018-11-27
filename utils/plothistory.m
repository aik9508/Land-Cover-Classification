function plothistory(x,y,t,X,index,color,k,b,displayname)
ch=zeros(1,length(index));
ws=0;
for i=1:length(index)
    ch(i)=mean(mean(X(index(i)).phase(x-ws:x+ws,y-ws:y+ws)));
end
t=t/30;
tsample=linspace(min(t),max(t),100);
if nargin<=8
    plot(t,ch,strcat(color,'o'),'Displayname',sprintf('(%d,%d)',x,y),'Linewidth',2);
else
    plot(t,ch,strcat(color,'o'),'Displayname',displayname,'Linewidth',2);
end
if nargin>6
    hold on
    
%     plot(uniquet,k(x,y)*uniquet+b(x,y),'Linewidth',2);
%     plot(tsample,exp(k(x,y)*tsample+b(x,y))-0.5,color,'Linewidth',2);
    plot(tsample,exp(b(x,y))*tsample.^k(x,y)+min(ch)*0,color,'Linewidth',2);
    hold off
end
xlabel('Time/month','Fontsize',15);
ylabel('Coherence','Fontsize',15);
title('Coherence history','Fontsize',20);
axis([0,max(t),0,1]);
% title(sprintf('correlation history (%d,%d)',x,y));