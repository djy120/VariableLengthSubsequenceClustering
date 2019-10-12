%% reduce the cluster to produce minimal loss
function [Z,C,L] = ReduceClusterByOne(X,C,L)
resResult = SubClusterStatistic(C,L);

lostVec = zeros(size(resResult,1),1);
resArray = cell(size(resResult,1),1);
for i = 1:size(resResult,1)
    cInd   = resResult(i,3:4);
    tmpC = C;
    tmpC{cInd(1)}.clusterCenter(cInd(2),:) = inf;
    
    % optimization
    [tmpZ,tmpC,tmpL] = AdaptiveTimeSeriesSubKmeansIteration(X,tmpC); 
    [tmpZ,tmpC,tmpL] = RemoveClusterWithFewSamples(X,tmpZ,tmpC,tmpL);
    lostVec(i) = ComputeLostFunction(X,tmpC,tmpZ,tmpL);

    resArray{i}.Z = tmpZ;
    resArray{i}.C = tmpC;
    resArray{i}.L = tmpL;
end

[v,ind] = min(lostVec); %#ok<ASGLU>

Z = resArray{ind}.Z;
C = resArray{ind}.C;
L = resArray{ind}.L;