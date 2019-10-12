
% clear all;
close all;clc;

%%
addpath('.\code\');

%% subsequence clustering runtimes for different lengths of GestureMidAirD1 time series
numArray = zeros(10,1);
numArray(1) = 30;
for i = 2:length(numArray)
    numArray(i) = numArray(1)*i*2;
end

numArray = 1:2:20;

runNum = 5;
runTimeArray = zeros(length(numArray),runNum);
lengthArray = zeros(length(numArray),1);

inputSyntheticTimeArray = cell(length(numArray),1);
for i = 1:length(numArray)
    load('.\OurResults\GestureMidAirD1_result.mat'); 
    X = repmat(X,[1,numArray(i)]);
    inputSyntheticTimeArray{i}.X = X;
    inputSyntheticTimeArray{i}.model = model;
end


for i = 1:length(numArray)
    X = inputSyntheticTimeArray{i}.X;
    model = inputSyntheticTimeArray{i}.model;
    lengthArray(i) = length(X);

    figure(1),plot(X);
    for j = 1:runNum
        
        disp([num2str(i), '/', num2str(j)]);
        
        t1 = clock;
        [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
        t2 = clock;
        runTimeArray(i,j) = etime(t2,t1);

        %
        C = ComputeClusterDescription(X,Z,C,L);
        model.C = C;

        % show result
        lost = ComputeLostFunction(X,C,Z,L);

        resResult = SubClusterStatistic(C,L);
        disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
        ShowCluster(X,Z,C,L);

    end
end

%
muArray = zeros(length(numArray),1);
sigmaArray = zeros(length(numArray),1);
for i = 1:length(numArray)
    muArray(i) = mean(runTimeArray(i,:));
    sigmaArray(i) = sqrt(var(runTimeArray(i,:)));
end

% save('.\TimeComplexityResults\GestureMidAirD1_runTimeArray_ourResult.mat','X','model','Z','C','L','inputSyntheticTimeArray','runTimeArray','muArray','sigmaArray');


%% show results
fontsize = 20;
linewidth = 1;

figure,
plot(lengthArray,muArray,'-ok','LineWidth',linewidth);    
xlabel('Time series length','FontSize',fontsize);
ylabel('RuntTime(s)','FontSize',fontsize);
set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
