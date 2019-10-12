

close all;
clc;


%%
colorArray{1} = '-or';
colorArray{2} = '-og';
colorArray{3} = '-ob';
colorArray{4} = '-k';
colorArray{5} = '-m';
colorArray{6} = '-c';
colorArray{7} = '-or';
colorArray{8} = '-og';
colorArray{9} = '-ob';
colorArray{10} = '-ok';
colorArray{11} = '-om';
colorArray{12} = '-oc';

fontsize = 20;
linewidth = 1;

%% Read data from GestureMidAirD1 time series
a = load('.\Dataset\UCRArchive_2018\UCRArchive_2018\GestureMidAirD1\GestureMidAirD1_TRAIN.tsv');
label = a(:,1);

segInd = zeros(size(a,1),3);
segInd(:,1) = label;

samplingRatio = 6;

tmpData = a(1,2:end);
f = isnan(tmpData);
tmpData = tmpData(f==0);
tmpData = tmpData(1:samplingRatio:end);
segInd(1,2) = 1;
segInd(1,3) = length(tmpData);
curPos = segInd(1,3);

allData = tmpData;
for i = 2:size(a,1)
    tmpData = a(i,2:end);
    f = isnan(tmpData);
    tmpData = tmpData(f==0);
    tmpData = tmpData(1:samplingRatio:end);
    
    maxV = max(tmpData);
    minV = min(tmpData);
    tmpData = (tmpData-minV)/(maxV-minV);
    
    allData = [allData,tmpData];
    
    segInd(i,2) = curPos+1;
    segInd(i,3) = curPos+length(tmpData);
    curPos = curPos+length(tmpData);
end

allClusters = unique(segInd(:,1));
allLens      = segInd(:,3)-segInd(:,2)+1;

numArray = zeros(length(allClusters),1);
for i = 1:length(allClusters)
    inds = find(segInd(:,1)==allClusters(i));
    tmpLens = allLens(inds);
    disp([num2str(allClusters(i)),'  :  ']);
    numArray(i) = length(inds);
end

selClusterInds = [9,10];
flagArray = zeros(size(segInd,1),1);
for i = 1:length(selClusterInds)
    flagArray(segInd(:,1)==selClusterInds(i)) = 1;
end

selAllData = [];
selSegInd = zeros(sum(flagArray),3);
curPos = 0;
num = 0;
for i = 1:length(flagArray)
    if (flagArray(i)==1)
        tmpData = allData(segInd(i,2):segInd(i,3));
        selAllData = [selAllData,tmpData];

        num = num + 1;
        selSegInd(num,1) = segInd(i,1);
        selSegInd(num,2) = curPos+1;
        selSegInd(num,3) = curPos+length(tmpData);
        curPos = curPos+length(tmpData);
    end
end

X = selAllData;

figure(101),hold on;
for i = 1:length(selClusterInds)
    tmpInds = find(selSegInd(:,1)==selClusterInds(i));
    for j = 1:length(tmpInds)
        plot(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3),selAllData(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i});
    end
end

k = 2;
minLen = 10;
maxLen = 40;
lenArray = minLen:5:maxLen;

model.k = k;
model.minLen = minLen;
model.maxLen = maxLen;
model.lenArray = lenArray;

%% subsequence clustering
[Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
% C = ComputeClusterDescription(X,Z,C,L);
% model.C = C;

lost = ComputeLostFunction(X,C,Z,L);
resResult = SubClusterStatistic(C,L);
disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
ShowCluster(X,Z,C,L);

% save('.\OurResults\GestureMidAirD1_result.mat','X','Z','C','L','model','selSegInd','selClusterInds');

%% show result
% load('.\OurResults\GestureMidAirD1_result.mat');

figure,
subplot(221),
hold on;

plot(X,'-ob','LineWidth',linewidth);
xlabel('(a)','FontSize',fontsize);

subplot(222),
hold on;
for i = 1:length(selClusterInds)
    tmpInds = find(selSegInd(:,1)==selClusterInds(i));
    for j = 1:length(tmpInds)
        plot(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3),selAllData(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i},'LineWidth',linewidth);
    end
end
xlabel('(b)','FontSize',fontsize);

subplot(223),
hold on;
for i = 1:size(resResult,1)
    plot(resResult(i,5:resResult(i,1)+4),colorArray{i});
end
xlabel('(c)','FontSize',fontsize);

subplot(224)
hold on;
for i = 1:size(Z,1)
    inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
    for j = 1:length(inds)
        plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(inds,length(colorArray)))},'LineWidth',linewidth);
    end
end
xlabel('(d)','FontSize',fontsize);
set(gca,'FontSize',fontsize);
