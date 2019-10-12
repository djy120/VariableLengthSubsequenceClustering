%% Estimate the closest adaptive cluster
%% Input:
%%      X: input data
%%      curPos: the end position of the subsequence
%%      ClusterArray: clusterArray
%%      Z: the old subsequence partition
%%      L: the old subsequence cluster label
%%      S: the old distance array
%%      lostFunction: lost function
%%                                                ==1: \sum_{i} \sum_{x \in C_{i}} || x-\mu^{i}||^{2}
%%                                                ==2: \sum_{i} \frac{1}{|\mu^{i}|} \sum_{x \in C_{i}} || x-\mu^{i}||^{2}
%% Output:
%%      Z: the updated subsequence partition
%%      L: the updated subsequence cluster label
%%      S: the update distance array
function [Z,L,S] = EstimateClosestAdaptiveClusterWithDeletion(X,curPos,clusterArray,Z,L,S,deleteLost,lostFunction)

pArray = zeros(length(clusterArray),1);
for i = 1:length(clusterArray)
    p = clusterArray{i}.len;
    C = clusterArray{i}.clusterCenter;
    flag = 0;
    for j = 1:size(C,1)
        if (sum(isinf(C(j,:)))==0)
            flag = 1;
        end
    end
    if (flag==1)
        pArray(i) = p;
    else
        pArray(i) = 10^(8);
    end
end
[minP,~] = min(pArray);

indArray = zeros(length(clusterArray),2);
disArray = zeros(length(clusterArray),1);
for i = 1:length(clusterArray)
    p = clusterArray{i}.len;
    if ((curPos-p+1)>0)
        x = X(curPos-p+1:curPos);
        C = clusterArray{i}.clusterCenter;
        [minD,minInd] = AdaptiveClusterAssignment(x,C); % find the minimal distance to the clusters
        if (lostFunction==2)
            minD = minD/p;
        end
        if (~isempty(minD)) % find the optimal subsequence partition
            if (p==curPos)
                disArray(i)   = minD;
                indArray(i,:) = [minInd,-1];
            else
                b = max(minP,curPos-p);
                e = curPos-1;
                minS = S(b);
                tmpInd = b;
                for j = b+1:e
                    if (S(j)<minS)
                        minS = S(j);
                        tmpInd = j;
                    end
                end
                disArray(i)   = minD;
                indArray(i,:) = [minInd,tmpInd]; % the index of current subsequence, the index of previous partition
            end
            if (lostFunction==2)
                disArray(i) = disArray(i)/p;
            end
        else
            disArray(i)   = -1;
            indArray(i,:) =  [-1,-1];
        end      
    else
        disArray(i)   = -1;
        indArray(i,:) =  [-1,-1];
    end
end

%% Compute the optimal partition
disVec = zeros(length(clusterArray),1);
for i = 1:length(clusterArray)
    if (disArray(i)==-1)
        disVec(i) = -1;
    else
        if (indArray(i,2)==-1)
            disVec(i) = disArray(i);
        else
            disVec(i) = disArray(i) + S(indArray(i,2));
        end
    end
end

inds = find(disVec>-1);
[minD,minInd] = min(disVec(inds));
minInd = inds(minInd);

% disVec(disVec==-1) = max(disVec(disVec>-1))+1;
% [minD,minInd] = min(disVec);

if (minD<(S(curPos-1)+deleteLost))
    if (indArray(minInd,2)==-1)
        Z{curPos} = [curPos-clusterArray{minInd}.len+1,curPos]; % the begin position and the end position
        L{curPos} = [minInd,indArray(minInd,1)]; 
    else
        Z{curPos} = [Z{indArray(minInd,2)};[curPos-clusterArray{minInd}.len+1,curPos]]; % the begin position and the end position
        L{curPos} = [L{indArray(minInd,2)};[minInd,indArray(minInd,1)]]; 
    end
    S(curPos) = minD;
else
    Z{curPos} = Z{curPos-1};
    L{curPos} = L{curPos-1};
    S(curPos) = S(curPos-1)+deleteLost;
end
