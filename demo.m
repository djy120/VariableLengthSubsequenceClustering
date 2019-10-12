
% clear all;
close all;clc;


%%
addpath('.\code\');

%% input time series and paramter setting
dataSet = 19;
[X,model] = ReadData(dataSet);

k = model.k;
minLen = model.minLen;
maxLen = model.maxLen;
lenArray = model.lenArray;

figure,plot(X);

%% variable-length subsequence clustering
tic;
[Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
toc;
C = ComputeClusterDescription(X,Z,C,L);
model.C = C;

%% show result
lost = ComputeLostFunction(X,C,Z,L);

resResult = SubClusterStatistic(C,L);
disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
ShowCluster(X,Z,C,L);
% ShowApproximation(X,Z,C,L);

% filename = ['Data_',num2str(dataSet),'_result.mat'];
% save(filename,'X','model','Z','C','L');
