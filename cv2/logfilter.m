function logf = logfilter(ws,sigma)
gf = fspecial('Gaussian',[ws+2,ws+2],sigma);
logf = conv2(gf,[0,1,0;1,-4,1;0,1,0],'same');
logf = logf(2:end-1,2:end-1);
logf = logf / max(max(abs(logf(:))));