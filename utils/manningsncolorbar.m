% manning's n colorbar
figure,colormap(manningsncmap),colorbar
h=colorbar;
h.Limits=[0,1];
h.Ticks=[0,0.25,0.5,0.75,1];
h.TickLabels={'0.00','0.05','0.10','0.15','0.20'};
h.FontSize=18;
h.FontName='Times New Roman';
% h.Label.String='N';
% h.Label.Rotation=0;
% h.Label.Units='normalized';
% % h.Location='southoutside';
% h.Label.Position=[0.5,1.02];

