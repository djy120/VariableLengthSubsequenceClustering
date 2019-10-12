%% Given C, estimate Z and L
%% input:
%%      X: input data
%%      oldClusterArray: cluster centers C in oldClusterArray
%% output:
%%      Z: subsequence partition
%%      L: cluster label
function [Z,L] =  UpdateAdaptiveSubsequencePartition(X,oldClusterArray)

%% Initialization
n = length(X);
Z = cell(n,1); % store the optimal subsequnce partition for each position
L = cell(n,1); % store the optimal subsequnce label for each position
S = zeros(n,1); % store the optimal distance for each position

%%
[tmpP,tmpZ,tmpL,tmpS] = IntialAdaptiveClusterAssignment(X,oldClusterArray);
p     = tmpP;
Z{p} = tmpZ;
L{p} = tmpL;
S(p) = tmpS;

%% Find optimal partition by dynamic programming
for i = p+1:n
    [Z,L,S] = EstimateClosestAdaptiveCluster(X,i,oldClusterArray,Z,L,S);
end
Z = Z{end};
L = L{end};

