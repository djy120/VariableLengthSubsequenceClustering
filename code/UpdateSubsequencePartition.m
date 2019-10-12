%% Find the optimal subsequence partition given the cluster C
%% Input:
%%      X: input data
%%      C: cluster centers
%% Output:
%%      Z: optimal subsequence partition
%%      L: optimal cluster labels
function [Z,L] = UpdateSubsequencePartition(X,C)

n = length(X);
p = size(C,2);

%%
Z = cell(n,1);
L = cell(n,1);
S = zeros(n,1);

%% Initialization
x = X(1:p);
Z{p} = [1,p];
[d,minInd] = ClusterAssignment(x,C);
L{p} = minInd;
S(p) = d;

%% Find optimal partition by dynamic programming
for i = p+1:length(X)
    % current subsequence
    x = X(i-p+1:i);
    [minD,minInd] = ClusterAssignment(x,C);

    % find the optimal subsequence partition until position i
    b = max(p,i-p);
    e = i-1;
    minS = S(b);
    minI = b;
    for j = b+1:e
        if (S(j)<minS)
            minS = S(j);
            minI = j;
        end
    end
    S(i) = minS + minD;
    Z{i} = [Z{minI};[i-p+1,i]];
    L{i} = [L{minI};minInd];
end

Z = Z{end};
L = L{end};
