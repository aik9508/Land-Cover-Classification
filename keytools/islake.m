%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function k = islake(z)
% ISLAKE mask of zero gradient on 3x3 tiles
% We use diff matrix in row and column directions, and shift it to build
% a single vectorized test of surrounding pixels. To do this we must
% concatenate unit vectors in different combinations...

dx = diff(z,1,2);	% differences in X direction
dy = diff(z,1,1);	% differences in Y direction
u1 = ones(size(z,1),1);	% row unit vector 
u2 = ones(1,size(z,2));	% column unit vector
u2r = u2(2:end);

% index of the tiles center pixel
k = ( ...
	[u2;dy] == 0 & [dy;u2] == 0 & ...
	[u1,dx] == 0 & [dx,u1] == 0 & ...
	[u1,[dx(2:end,:);u2r]] == 0 & [[dx(2:end,:);u2r],u1] == 0 & ...
	[u1,[u2r;dx(1:end-1,:)]] == 0 & [[u2r;dx(1:end-1,:)],u1] == 0 ...
);

% now extends it to surrounding pixels
k(1:end-1,:) = (k(1:end-1,:) | k(2:end,:));
k(2:end,:) = (k(2:end,:) | k(1:end-1,:));
k(:,1:end-1) = (k(:,1:end-1) | k(:,2:end));
k(:,2:end) = (k(:,2:end) | k(:,1:end-1));