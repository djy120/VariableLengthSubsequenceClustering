%% Update cluster centers C given the partitation and lablels
%% Input:
%%      X: input data
%%      Z: subsequence partition
%%      L: cluster labels
%% Output:
%%      C: cluster centers
function C = UpdateClusterCenter(X,Z,L,k,p)
C = zeros(k,p);
for i = 1:k
    inds = find(L==i);
    if (isempty(inds))
        C(i,:) = inf;
    else
        tmpData = zeros(length(inds),p);
        for j = 1:length(inds)
            tmpData(j,:) = X(Z(inds(j),1):Z(inds(j),2));
        end
        C(i,:) = mean(tmpData,1);
    end
end