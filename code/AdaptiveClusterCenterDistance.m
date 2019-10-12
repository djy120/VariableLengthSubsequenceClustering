%% compute the distance between old cluster centers and new cluster centers
function dd = AdaptiveClusterCenterDistance(oldClusterArray,newClusterArray)

if (length(oldClusterArray) ~= length(newClusterArray))
    dd = 10^(8);
else
    s1 = zeros(length(oldClusterArray),1);
    for i = 1:length(oldClusterArray)
        s1(i) = oldClusterArray{i}.len;
    end
    s2 = zeros(length(newClusterArray),1);
    for i = 1:length(newClusterArray)
        s2(i) = newClusterArray{i}.len;
    end
    
    disVec = zeros(length(oldClusterArray),1);
    for i = 1:length(s1)
        p = s1(i);
        ind = find(s2==p);
        if (isempty(ind)==1)
            dd = 10^(8);
            return;
        else
            oldC   = oldClusterArray{i}.clusterCenter;
            newC = newClusterArray{ind}.clusterCenter;
            disVec(i) = ComputeClusterCenterDistance(oldC,newC);
        end
        
    end
    dd = max(disVec);
end