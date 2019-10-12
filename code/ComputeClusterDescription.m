%% The mean and maximial distance square for each subsequence cluster
function C = ComputeClusterDescription(X,Z,C,L)

for i = 1:length(C)
    for j = 1:size(C{i}.clusterCenter,1)
        cls = C{i}.clusterCenter(j,:);
        inds = find((L(:,1)==i).*(L(:,2)==j)==1);
        tmpData = zeros(length(inds),length(cls));
        for k = 1:length(inds)
            tmpData(k,:) = X(Z(inds(k),1):Z(inds(k),2));
        end
    end
    C{i}.meanDisSquare = mean(sum((tmpData-repmat(cls,length(inds),1)).^2,2));
    C{i}.maxDisSquare = max(sum((tmpData-repmat(cls,length(inds),1)).^2,2));
end