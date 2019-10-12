

clear all;
close all;
clc;


%%
colorArray{1} = '-r';
colorArray{2} = '-g';
colorArray{3} = '-b';
colorArray{4} = '-k';
colorArray{5} = '-m';
colorArray{6} = '-c';
% colorArray{7} = '-or';
% colorArray{8} = '-og';
% colorArray{9} = '-ob';
% colorArray{10} = '-ok';
% colorArray{11} = '-om';
% colorArray{12} = '-oc';

%% variable-length subsequence clustering on NAB synthetic time series
dataSet = 4;
[X,model] = ReadData(dataSet);
figure,plot(X);
[Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
C = ComputeClusterDescription(X,Z,C,L);
model.C = C;

lost = ComputeLostFunction(X,C,Z,L);
resResult = SubClusterStatistic(C,L);
disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
ShowCluster(X,Z,C,L);

% filename = ['.\OurResults\Data_',num2str(dataSet),'_result.mat'];
% save(filename,'X','model','Z','C','L');

%%
% filename = ['.\OurResults\Data_',num2str(dataSet),'_result.mat'];
% load(filename);
resResult = SubClusterStatistic(C,L);
fontsize = 20;
linewidth = 1;

figure,
subplot(131),
hold on;

plot(X,'-b','LineWidth',linewidth);
xlabel('(a)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(132),
hold on;
for i = 1:size(resResult,1)
    plot(resResult(i,5:resResult(i,1)+4),colorArray{i});
end
xlabel('(b)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(133),
hold on;
for i = 1:size(L,1)
    inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
    for j = 1:length(inds)
        plot(X(Z(i,1):Z(i,2)),colorArray{max(1,mod(i,length(colorArray)))},'LineWidth',linewidth);
    end
end
xlabel('(c)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

