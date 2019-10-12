function [Z,C,L] = RefineSubkmeansBySplitting(X,Z,C,L,minLen,k,lostFunction)

%
% [Z,C,L] = ClusterSplitting(X,C,Z,L,minLen,k,lostFunction);

[Z,C,L] = ClusterSplittingByDeviance(X,C,Z,L,minLen,k,lostFunction);