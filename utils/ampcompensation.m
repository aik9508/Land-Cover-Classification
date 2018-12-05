function antennagain = ampcompensation()
w = 3.1;        % Attenna width
wvl = 0.236057; % Wavelength
r0 = 856117;    % Near range distance
ht = 697799.36496277945;    % orbit altitude
fs = 32E6;      % Sample rate
c = 3E8;        % Speed of light
dr = c/(2*fs);  % Slant range spacing
nr = 9440;      % Number of range bins
looks = 2;      % Looks taken in range direction
re = 6373040.699757;    % Local Earth radius

nrlooks = round(nr/looks);
r = r0 + (0:nrlooks)*looks*dr;
theta = acos((r.^2+(ht+re)^2-re^2)./(2*(ht+re)*r));
% theta0 = theta(round(nrlooks/2));
% theta0 = theta(2000);
theta0 = (theta(1)+theta(end))/2;
antennagain = sinc(w*sin(theta(1:end-1)-theta0)/wvl).*(theta(2:end)-theta(1:end-1));
antennagain = antennagain / max(antennagain);
% plot(1:nrlooks,antennagain);
% axis([1,nrlooks,0,1]);