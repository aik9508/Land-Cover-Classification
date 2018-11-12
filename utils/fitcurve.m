function [k,b,index,t]=fitcurve(X,data1,folder,ndata)
%FITCURVE decorrelation rate.
% A power function of the form c=alpha*t^k is used to fit the coherence
% history.
% 
% [k,b,index,t]=fitcurve(X,data1,folder,ndata) fits the evolution of the
% coherence between data1 and other data contained in X acquired at 
% different dates. folder is the path of the sbas_list file which contains
% the information of temporal baselines. ndata indicates the maximum number
% of points that are used to fit the coherence history. k is the matrix of
% the decorrelation rate. b = log(alpha).

% find all 'data1_*.c' files
count=0;
index=zeros(1,length(X));
for i=1:length(X)
    if isequal(char(X(i).data1),char(data1)) || ...
	   isequal(char(X(i).data2),char(data1))
        count=count+1;
        index(count)=i;
    end
end
index=index(1:count);

[m,n]=size(X(1).phase);
y=zeros(m*n,ndata);
windowsize=3;
kernel=ones(windowsize)/(windowsize^2);

% get the time baseline of all InSAR data
t=gettime(data1,folder);
% sort the time baseline
[t_sorted,I]=sort(t);
uniquet=unique(t_sorted);
ndata=min(ndata,numel(uniquet));
uniquecount=0;
i=1;
while i<=count && uniquecount<ndata
	uniquecount=uniquecount+1;
    % if there are two data correponding to an identical time baseline we
    % use the mean value of these two data to do the curve fitting.
	if i<count && t_sorted(i) == t_sorted(i+1)
		y(:,uniquecount)= ...
		0.5*(reshape(conv2(single(X(index(I(i))).phase),kernel,'same'),[m*n,1]) + ...
		reshape(conv2(single(X(index(I(i+1))).phase),kernel,'same'),[m*n,1]));
		i=i+2;
	else
		y(:,uniquecount)=reshape(conv2(single(X(index(I(i))).phase),kernel,'same'),[m*n,1]);
		i=i+1;
	end
end
y=y(:,1:ndata);
if uniquecount == ndata
	x=log(uniquet(1:ndata)/30);
    y=log(y);
    A=sum(x.^2);
    B=sum(x);
    C=sum(y.*x,2);
    D=sum(y,2);
    k=(ndata*C-B*D)/(A*ndata-B^2);
    b=(A*D-C*B)/(A*ndata-B^2);
	k=reshape(k,[m,n]);
    b=reshape(b,[m,n]);
    k(isnan(k))=0;
	k=min(0,k);
else
	k=[];
  b=[];
end
