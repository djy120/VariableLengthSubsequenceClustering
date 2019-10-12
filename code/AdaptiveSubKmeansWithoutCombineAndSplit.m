%% variable-length subsequence clustering initialization
%% input:
%%      X : input data
%%      model: parameter settings
%%                model.k : the cluster number
%%                model.minLen : the minimal subsequence length
%%                model.maxLen : the maximal subsequence length
%%                model.lenArray: the length array of subsequences for initialization
%% output:
%%      Z: the subsequence partition
%%      C: the cluster centers
%%      L: the label of each subsequence
%%
%% Author: Jiangyong Duan
%% 	            Key Laboratory of Space Utilization, Technology and Engineering Center for Space Utilization, Chinese Academy of Sciences, 100094, Beijing, China
%%              e-mail: duanjy@csu.ac.cn
%%              2019/10/08
function [Z,C,L] = AdaptiveSubKmeansWithoutCombineAndSplit(X,model)

%% Initialization for each fixed subsequence length
disp('Initialization ......');
InitialClusterArray = AdaptiveTimeSeriesSubKmeansInitialization(X,model);

%% Optimization iteration for initialized subsequence clusters
disp('Iteration ......');
[Z,C,L] = AdaptiveTimeSeriesSubKmeansIteration(X,InitialClusterArray);

%% Remove clusters with few samples
% resResult = SubClusterStatistic(C,L);
% disp(resResult(:,1:5));

[Z,C,L] = RemoveClusterWithFewSamples(X,Z,C,L);

