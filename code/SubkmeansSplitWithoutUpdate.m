%% Cluster splitting
function [Z,C,L] = SubkmeansSplitWithoutUpdate(X,Z,C,L,model)

k = model.k;
minLen = model.minLen;
epslon = 10^(-6);

preLost    = ComputeLostFunction(X,C,Z,L);
resResult = SubClusterStatistic(C,L);

%% choose the splitting cluster with maximal variance
flagArray = zeros(size(resResult,1),1);
varVec    = zeros(size(resResult,1),1);
for i = 1:size(resResult,1)
    p = resResult(i,1);
    if (p<2*minLen)
        continue;
    end
    cInd           = resResult(i,3:4);
    mu             = C{cInd(1)}.clusterCenter(cInd(2),:);
    flagArray(i) = 1;
    
    inds = find( (L(:,1)==cInd(1)) .* (L(:,2)==cInd(2)) ==1);

    for j = 1:p
        tmp = X(Z(inds)+j-1);  
        varVec(i) = varVec(i) + sum((tmp-mu(j)).^2);
    end 

    varVec(i) = varVec(i)/length(inds)/p;
end

inds = find(flagArray==1);
if (~isempty(inds))
    [~,ind] = max(varVec(inds));
    selInd  = inds(ind);
else
    return;
end

%% cluster split
p                = resResult(selInd,1); % the selected cluster to split
% posInterval = 1;% important for synthetic time series, default value
posInterval = 3; % for speeding up
posArray    = minLen:posInterval:(p-minLen);

cInd           = resResult(selInd,3:4);
lostArray    = zeros(length(posArray),1);
tmpCArray = cell(length(posArray),1);
for j = 1:length(posArray)
    tmpC1 = GenerateNewClusterBySplit(C,cInd,posArray(j));
    [lost,tmpC] = SplitOneClusterCore(X,C,cInd,posArray(j));
    lostArray(j)    = lost;
    tmpCArray{j} = tmpC1;
end

% optimization
[curLost,ind] = min(lostArray);
if (abs(preLost-curLost)/preLost>epslon)
    C = tmpCArray{ind};
    [Z,L] = UpdateAdaptiveSubsequencePartition(X,C);
end

%% postprocess
[C,L] = RemoveNullCluster(C,L);