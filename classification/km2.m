function [lbs,centers,mindis] = km2(x,k,maxiters,centers,rigidity)

npts=size(x,1);
lbs=zeros(npts,1);
dis=zeros(npts,k);
oldcost=inf;
centers0=centers;
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
            centers(j,:)=(1-rigidity)*mean(x(ind,:),1)+rigidity*centers0(j,:);
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
