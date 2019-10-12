
% clear all;
close all;clc;

%%
addpath('.\code\');

%%

runNum = 10;
runTimeArray = zeros(runNum,1);

% % % load('.\OurResults\SyntheticcodeInPaper1.mat'); % for synthtic results in figure 4 in IEEE trans paper
% % % X = X(1:300);

% load('.\OurResults\GestureMidAirD1_result.mat'); % for GestureMidAir dataset in figure 11 in IEEE trans paper

dataSet = 1; 
[X,model] = ReadData(dataSet);

figure,plot(X);

for i = 1:runNum

    k = model.k;
    minLen = model.minLen;
    maxLen = model.maxLen;
    lenArray = model.lenArray;
    lostFunction = model.lostFunction;
    ifDTW = model.ifDTW;

    model.ifDTW=  0;

    model.ifDTW = 0;
    lostFunction = model.lostFunction;

    t1 = clock;
    [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
    t2 = clock;
    runTimeArray(i) = etime(t2,t1);

    %
    C = ComputeClusterDescription(X,Z,C,L);
    model.C = C;

    % show result
    lost = ComputeLostFunction(X,C,Z,L,ifDTW,lostFunction);

    resResult = SubClusterStatistic(C,L);
    disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
    ShowCluster(X,Z,C,L);

end

%
mu = mean(runTimeArray);
sigma = sqrt(var(runTimeArray));

