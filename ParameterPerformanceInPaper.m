
% clear all;
close all;clc;

%%
addpath('.\code\');

%%
colorArray{1} = '-or';
colorArray{2} = '-og';
colorArray{3} = '-ob';
colorArray{4} = '-ok';
colorArray{5} = '-om';
colorArray{6} = '-oc';
colorArray{7} = '-or';
colorArray{8} = '-og';
colorArray{9} = '-ob';
colorArray{10} = '-ok';
colorArray{11} = '-om';
colorArray{12} = '-oc';

fontsize = 20;
linewidth = 1;

%% Robustness of minimal and maximal subsequence lengths
% dirname = '.\OurResults\';
% filename = 'GestureMidAirD1_result.mat';
% load([dirname,filename]);
% X;
% model;
% selSegInd;
% 
% minLenArray = [5,10,10,10,15,15,30];
% maxLenArry = [20,30,40,60,30,50,60];
% selClusterInds = [9,10];
% 
% k = 2;
% differentLenResArray = cell(length(minLenArray),1);
% for i = 1:length(minLenArray)
%     
%     model.minLen = minLenArray(i);
%     model.maxLen = maxLenArry(i);
%     model.lenArray = model.minLen:3:model.maxLen;
%     model.k = k;
% 
%     figure,plot(X);
% 
%     %
%     [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
%     C = ComputeClusterDescription(X,Z,C,L);
%     model.C = C;
% 
%     % show result
%     lost = ComputeLostFunction(X,C,Z,L);
% 
%     resResult = SubClusterStatistic(C,L);
%     disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
%     ShowCluster(X,Z,C,L);
% 
%     differentLenResArray{i}.model = model;
%     differentLenResArray{i}.Z = Z;
%     differentLenResArray{i}.C = C;
%     differentLenResArray{i}.L = L;
%     differentLenResArray{i}.X = X;
% end
% 
% figure,
% for i = 1:length(differentLenResArray)
%     Z = differentLenResArray{i}.Z;
%     C = differentLenResArray{i}.C;
%     L = differentLenResArray{i}.L;
%     resResult = SubClusterStatistic(C,L);
%     [v,ind] = sort(resResult(:,1));
%     resResult = resResult(ind,:);
% 
%     subplot(3,3,i),
%     hold on;
%     for j = 1:size(resResult,1)
%         plot(resResult(j,5:resResult(j,1)+4),colorArray{j+6});
%     end
% end
% % save('./ParameterRobustnessExperiments/LenRobustExperiments.mat','differentLenResArray');

%%
load('./ParameterRobustnessExperiments/LenRobustExperiments.mat');
differentLenResArray;

aa = zeros(length(differentLenResArray),1);
for i = 1:length(differentLenResArray)
    aa(i) = differentLenResArray{i}.model.minLen*100+differentLenResArray{i}.model.maxLen;
end
[v,ind] = sort(aa);
differentLenResArray = differentLenResArray(ind);

for i = 1:length(differentLenResArray)
    disp([num2str(differentLenResArray{i}.model.minLen), '    ', num2str(differentLenResArray{i}.model.maxLen)]);
end


figure(27),
subplot(3,3,1)
plot(X,'-ok','LineWidth',linewidth);
xlabel('(a)','FontSize',fontsize);
set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

selAllData  = X;

subplot(3,3,2),
hold on;
for i = 1:length(selClusterInds)
    tmpInds = find(selSegInd(:,1)==selClusterInds(i));
    for j = 1:length(tmpInds)
        plot(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3),selAllData(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i},'LineWidth',linewidth);
    end
end
xlabel('(b)','FontSize',fontsize);
set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

xlabelName = {'(c)','(d)','(e)','(f)','(g)','(h)','(i)','(j)'};


groudTruthLabel = zeros(1,length(X));
for i = 1:length(selClusterInds)
    tmpInds = find(selSegInd(:,1)==selClusterInds(i));
    for j = 1:length(tmpInds)
        groudTruthLabel(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)) = selClusterInds(i);
    end
end

for i = 1:length(differentLenResArray)
    Z = differentLenResArray{i}.Z;
    C = differentLenResArray{i}.C;
    L = differentLenResArray{i}.L;
    resResult = SubClusterStatistic(C,L);
    [v,ind] = sort(resResult(:,1));
    resResult = resResult(ind,:);

    subplot(3,3,i+2),
    hold on;
    
    tmpNum = length(unique(L));
    tmpL = L(:,1)*tmpNum + L(:,2);
    tmpClusterLabel = zeros(1,length(X));
    for j = 1:size(Z,1)
        inds = find( (resResult(:,3)==L(j,1)).*(resResult(:,4)==L(j,2)) ==1);
        for k = 1:length(inds)
            tmpClusterLabel(Z(j,1):Z(j,2)) = tmpL(j);
        end
    end
    res = ClusterLabelCorrespond(tmpClusterLabel,groudTruthLabel);
    for j = 1:size(Z,1)
        ind1 = find(res(:,1)==tmpL(j));
        ind2 = res(ind1,2);
        ind3 = find(selClusterInds==ind2);
        for k = 1:length(inds)
            plot(Z(j,1):Z(j,2),X(Z(j,1):Z(j,2)),colorArray{max(1,mod(ind3,length(colorArray)))},'LineWidth',linewidth);
        end
    end

    xlabel(xlabelName{i},'FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

end



%% experiment on different subsequence cluster numbers
dirname = '.\OurResults\';
filename = 'GestureMidAirD1_result.mat';
load([dirname,filename]);
selClusterInds = [9,10];

kArray = [1,2,3,4];

differentKResArray = cell(length(kArray),1);
for i = 1:length(kArray)
    

    model.k = kArray(i);
    model.ifDTW=  0;
    figure,plot(X);
    
    ifDTW = model.ifDTW;
    lostFunction = model.lostFunction;

    %%
    [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
    C = ComputeClusterDescription(X,Z,C,L);
    model.C = C;

    %% show result
    lost = ComputeLostFunction(X,C,Z,L);

    resResult = SubClusterStatistic(C,L);
    disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
    ShowCluster(X,Z,C,L);

    differentKResArray{i}.model = model;
    differentKResArray{i}.Z = Z;
    differentKResArray{i}.C = C;
    differentKResArray{i}.L = L;
    differentKResArray{i}.X = X;
end
% save('.\ParameterRobustnessExperiments\clusterNumberExperiments.mat','differentKResArray');

%%
load('.\ParameterRobustnessExperiments\clusterNumberExperiments.mat','differentKResArray');
differentKResArray;

figure(28),
m = 1;
n = 4;

subplot(m,n,1),
hold on;
for i = 1:length(selClusterInds)
    tmpInds = find(selSegInd(:,1)==selClusterInds(i));
    for j = 1:length(tmpInds)
        plot(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3),X(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i},'LineWidth',linewidth);
    end
end
xlabel('(a)','FontSize',fontsize);
set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

xlabelName = {'(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)','(j)'};

for i = 2:length(differentKResArray)
    Z = differentKResArray{i}.Z;
    C = differentKResArray{i}.C;
    L = differentKResArray{i}.L;
    resResult = SubClusterStatistic(C,L);
    [v,ind] = sort(resResult(:,1));
    resResult = resResult(ind,:);
    [v,ind] = sort(resResult(:,1));
    resResult = resResult(ind,:);

    subplot(m,n,i),
    hold on;
    for j = 1:size(Z,1)
        inds = find( (resResult(:,3)==L(j,1)).*(resResult(:,4)==L(j,2)) ==1);
        for k = 1:length(inds)
            plot(Z(j,1):Z(j,2),X(Z(j,1):Z(j,2)),colorArray{inds},'LineWidth',linewidth);
        end
    end
    xlabel(xlabelName{i-1},'FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
end