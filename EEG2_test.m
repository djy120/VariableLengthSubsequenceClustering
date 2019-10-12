
% clear all;
close all;clc;

%%
addpath('.\code\');

%%
dataSet = 40;
% dataSet = 14;
[X,model] = ReadData(dataSet);

k = model.k;
minLen = model.minLen;
maxLen = model.maxLen;
lenArray = model.lenArray;

figure,plot(X);

%%
[Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
% C = ComputeClusterDescription(X,Z,C,L);
% model.C = C;

%% show result
lost = ComputeLostFunction(X,C,Z,L);

resResult = SubClusterStatistic(C,L);
disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
ShowCluster(X,Z,C,L);
% ShowApproximation(X,Z,C,L);

figure,plot(X);


% filename = ['.\OurResults\Data_',num2str(dataSet),'_result.mat'];
% save(filename,'X','model','Z','C','L');
