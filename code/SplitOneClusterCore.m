function [lost,C] = SplitOneClusterCore(X,C,cInd,splitPos)

% generate new cluster
C = GenerateNewClusterBySplit(C,cInd,splitPos);

% optimization
[Z,C,L] = AdaptiveTimeSeriesSubKmeansIteration(X,C); 
[Z,C,L] = RemoveClusterWithFewSamples(X,Z,C,L);

lost = ComputeLostFunction(X,C,Z,L);

