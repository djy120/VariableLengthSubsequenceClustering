
% clear all;
close all;clc;

%%
colorArray{1} = '-r';
colorArray{2} = '-g';
colorArray{3} = '-b';
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
linewidth = 2;

%%
addpath('.\code\');

%%
% dataSet = 18;
dataSet = 19;
% [X,model] = ReadData(dataSet);
% 
% figure,plot(X);
% 
% %
% [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
% % C = ComputeClusterDescription(X,Z,C,L);
% % model.C = C;
% 
% % show result
% lost = ComputeLostFunction(X,C,Z,L);
% 
% resResult = SubClusterStatistic(C,L);
% disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
% ShowCluster(X,Z,C,L);
% % ShowApproximation(X,Z,C,L);
% 
% figure,plot(X);
% 
% % filename = ['.\OurResults\Data_',num2str(dataSet),'_result.mat'];
% % save(filename,'X','model','Z','C','L');

%%
% filename = ['.\OurResults\Data_',num2str(dataSet),'_result.mat'];
% load(filename);
% 
% resResult = SubClusterStatistic(C,L);
% 
% figure(63),
% 
% subplot(131),
% plot(X,'-k','LineWidth',linewidth);
% xlabel('(a)','FontSize',fontsize);
% set(gca,'FontSize',fontsize);
% 
% subplot(132),
% hold on;
% for i = 1:size(resResult,1)
%     plot(resResult(i,5:resResult(i,1)+4),colorArray{mod(i,3)+1},'LineWidth',linewidth);
% end
% xlabel('(b)','FontSize',fontsize);
% set(gca,'FontSize',fontsize);
% 
% subplot(133),
% hold on;
% for i = 1:size(Z,1)
%     for j = 1:size(resResult,1)
%         if (L(i,1)==resResult(j,3) && L(i,2)==resResult(j,4))
%             plot(X(Z(i,1):Z(i,2)),colorArray{mod(j,3)+1},'LineWidth',linewidth);
%         end
%     end
% end
% 
% xlabel('(c)','FontSize',fontsize);
% set(gca,'FontSize',fontsize);


%%
filename = ['.\OurResults\Data_',num2str(dataSet),'_result.mat'];
load(filename);
load(filename);
resResult = SubClusterStatistic(C,L);

m = 2;
n = 2;

subplot(m,n,1),
hold on;

plot(X,'-k','LineWidth',linewidth);
xlabel('(a)','FontSize',fontsize);
axis([0,floor(length(X)*1.05),0,1]);
set(gca,'FontSize',fontsize);

subplot(m,n,2),
hold on;
for i = 1:size(resResult,1)
    plot(resResult(i,5:resResult(i,1)+4),colorArray{i});
end
xlabel('(b)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(m,n,3),
hold on;
for i = 1:size(L,1)
    inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
    for j = 1:length(inds)
        plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(inds,length(colorArray)))},'LineWidth',linewidth);
    end
end
xlabel('(c)','FontSize',fontsize);

axis([0,floor(length(X)*1.05),0,1]);
set(gca,'FontSize',fontsize);

subplot(m,n,4),
hold on;

posArray = zeros(size(resResult,1),2);
posArray(1,:) = [1,resResult(1,1)];
for i = 2:size(posArray,1)
    posArray(i,1) = posArray(i-1,2)+1;
    posArray(i,2) = posArray(i-1,2)+resResult(i,1);
end

for i = 1:size(L,1)
    inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
    for j = 1:length(inds)
        plot(posArray(inds,1):posArray(inds,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(inds,length(colorArray)))},'LineWidth',linewidth);
    end
end
xlabel('(d)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

