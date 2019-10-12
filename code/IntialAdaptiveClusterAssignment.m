%% Initialize adaptive cluster assignment
%% Input:
%%      X: input data
%%      clusterArray: cluster centers
%% Output:
%%      p: the initial subsequence length
%%      Z: the initial subsequence
%%      L: the initial cluster labels
%%      S: the initial distance to the closest cluster
function [p,Z,L,S] = IntialAdaptiveClusterAssignment(X,clusterArray)

oldP = 10^(8);
for i = 1:length(clusterArray)
    p = clusterArray{i}.len;
    if (p<oldP)
        x = X(1:p);
        C = clusterArray{i}.clusterCenter;
        [minD,minInd] = AdaptiveClusterAssignment(x,C);
        if (~isempty(minD))    
            Z = [1,p];
            L = [i,minInd];
            S = minD;
            oldP = p;
        end
    end
end
p = oldP;
    

