function [lbs,centers,mindis] = km(x,k,maxiters,centers)

npts=size(x,1);
if nargin<3 || isempty(maxiters)
    maxiters=100;
end

if nargin<4
    centers=x(ceil(rand(k,1)*npts),:);
end

lbs=zeros(npts,1);
dis=zeros(npts,k);
oldcost=inf;
for i=1:maxiters
    for j=1:k
        dis(:,j)=sum((x-centers(j,:)).^2,2);
    end
    mindis=min(dis,[],2);
    for j=1:k
        ind = mindis==dis(:,j); 
        if sum(ind)==0
            centers(j,:)=x(ceil(rand()*npts),:);
        else
            lbs(ind)=j;
            centers(j,:)=mean(x(ind,:),1);
        end
    end
    cost=sum(mindis);
    fprintf('iteration %d, cost %5.4E\n',i,cost);
    if abs(cost-oldcost)/oldcost<5e-5
        break;
    else
        oldcost=cost;
    end
end
