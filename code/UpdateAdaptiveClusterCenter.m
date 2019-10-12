%% Given Z and L, estimate C
%% input:
%%      X: input data
%%      oldClusterArray: cluster centers C in oldClusterArray
%%      Z: subsequence partition
%%      L: subsequence cluster label
%% output:
%%      newClusterArray: new cluster centers C in newClusterArray
function newClusterArray = UpdateAdaptiveClusterCenter(X,oldClusterArray,Z,L)

newClusterArray = oldClusterArray;
for i = 1:length(oldClusterArray)
    p = oldClusterArray{i}.len;
    k = size(oldClusterArray{i}.clusterCenter,1);
    C = zeros(k,p);
    for j = 1:k
        inds = find( (L(:,1)==i) .* (L(:,2)==j) == 1);
        if (~isempty(inds))
            tmpData = nan*ones(length(inds),p);
            for m = 1:length(inds)
                tmpData(m,:) = X(Z(inds(m),1):Z(inds(m),2));
            end
            C(j,:) = mean(tmpData,1);
        else
            C(j,:) = inf;
        end
    end
    newClusterArray{i}.clusterCenter = C;
end