%% Compute the lost function value 
%% \sum_{i=1}^{k} \sum_{x \in C^{i}} ||x-\mu^{i}||^{2}
%% Input:
%%      X: input data
%%      C: the cluster centers
%%      Z: the subsequence partition
%%      L: the cluster label
%% Output:
%%      lost: the lost function value
function lost = ComputeLostFunction(X,C,Z,L)
lost = 0;
for i = 1:size(Z,1)
    x     = X(Z(i,1):Z(i,2));
    c     = C{L(i,1)}.clusterCenter(L(i,2),:);
    d     = sum((x-c).^2);
    lost = lost + d;
end




