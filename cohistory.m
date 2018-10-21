% figure(1)
% hold on
% plothistory(819,193,t,Y,'Open Water')
% plothistory(932,1127,t,Y,'Urban City')
% plothistory(283,1215,t,Y,'Forest')
% plothistory(569,901,t,Y,'Barren Land')
% plothistory(175,1175,t,Y,'Farmland')
% xlabel('Time/month','Fontsize',15)
% ylabel('Coherence','Fontsize',15)
% lgd=legend('show');
% lgd.FontSize=15;
% hold off

figure(1)
hold on
plothistory(819,193,t,Y,'Open Water')
plothistory(932,1127,t,Y,'Urban City')
plothistory(283,1215,t,Y,'Forest')
plothistory(569,901,t,Y,'Barren Land')
plothistory(175,1175,t,Y,'Farmland')
xlabel('Time/month','Fontsize',15)
ylabel('Coherence','Fontsize',15)
lgd=legend('show');
lgd.FontSize=15;
hold off