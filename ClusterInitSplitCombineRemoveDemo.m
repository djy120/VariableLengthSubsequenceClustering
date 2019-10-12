

close all;
clear all;

%%
addpath('.\code\');

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

fontsize = 30;
linewidth = 3;

%% Show our optimization process of cluster initializaiton, cluster splitting, cluster combination and cluster removing.
dirname = '.\OurResults\';
filename = 'Data_39_result.mat';
saveDirname = '.\clusterInitSplitCombineRemoveResult\';

load([dirname,filename]);
X;
k = model.k;
minLen = model.minLen;
maxLen = model.maxLen;
lenArray = model.lenArray;
groudTruthLabel = model.groudTruthLabel;

%% Subsequence clustering
% [Z,C,L] = AdaptiveSubKmeansWithoutCombineAndSplit(X,model);
% resResult = SubClusterStatistic(C,L);
% DispMat(resResult(:,1:5));
% lost = ComputeLostFunction(X,C,Z,L);
% disp(['Iteration 1, cluster number ',num2str(size(resResult,1)), ',    Lost: ',num2str(lost)]);
% 
% % Combine and split clusters 
% eplson       = 10^(-6);
% ifSplit        = 1;
% ifCombine = 1;
% 
% tmpArray{1}.Z = Z;
% tmpArray{1}.C = C;
% tmpArray{1}.L = L;
% num = 1;
% 
% oldK = size(resResult,1);
% oldZ = Z;
% oldC = C;
% oldL = L;
% ifStop = 0;
% 
% 
% lossArray = zeros(500,1);
% clusterNumArray = zeros(500,1);
% splitArray = zeros(500,1);
% 
% lossArray(1) = lost;
% clusterNumArray(1) = size(resResult,1);
% splitArray(1) = 1;
% 
% while (size(resResult,1)>=k && ifStop==0)
%     close all;
%     [Z,C,L] = RefineSubkmeansByCombineAndSplit2(X,Z,oldC,L,model,ifCombine,ifSplit);
%     lost = ComputeLostFunction(X,C,Z,L);
%     resResult = SubClusterStatistic(C,L);
%     newK = size(resResult,1);
%     dd = AdaptiveClusterCenterDistance(oldC,C);
%     if (dd<eplson)
%         disp('Converge, reduce cluster number');
%         if (newK<=2)
%             break;
%         end
%         [tmpZ,tmpC,tmpL] = ReduceClusterByOne(X,C,L);
%         resResult = SubClusterStatistic(tmpC,tmpL);  
%         if (size(resResult,1)>=k)
%             Z = tmpZ;
%             C = tmpC;
%             L = tmpL;
%             ifSplit = 0;
%             DispMat(resResult(:,1:5));
%         else
%             ifStop = 1;
%         end
%     elseif (newK>oldK)
%         disp('cluster number increase');
%         [Z,C,L] = ReduceClusterByOne(X,C,L);
%         tmpLost = ComputeLostFunction(X,C,Z,L);
%         if (tmpLost>=lost)
%             Z = oldZ;
%             C = oldC;
%             L = oldL;
%             ifSplit = 0;
%         end
%         DispMat(resResult(:,1:5));
%     end
%     resResult = SubClusterStatistic(C,L);
%     newK = size(resResult,1);
%     if (newK<oldK)
%         ifSplit = 1;
%     end
%     lost = ComputeLostFunction(X,C,Z,L);
%     disp(['Iteration ',num2str(num+1), ', cluster number ',num2str(newK), ',    Lost: ',num2str(lost)]);
%         
%     oldC = C;
%     oldZ = Z;
%     oldL = L;
%     preLost = lost;
%     oldK = newK;
%     
%     num = num + 1;
%     tmpArray{num}.Z = Z;
%     tmpArray{num}.C = C;
%     tmpArray{num}.L = L;
%     
%     lossArray(num) = lost;
%     clusterNumArray(num) = size(resResult,1);
%     splitArray(num) = ifSplit;
% end
% 
% iterNum = num;
% 
% clusterNumArray = clusterNumArray(1:num);
% splitArray = splitArray(1:num);
% 
% save([saveDirname,filename(1:end-4),'_Init_split_combine_remove.mat'],'X','model','tmpArray','lossArray','clusterNumArray','splitArray','iterNum');

%% show results
load([saveDirname,filename(1:end-4),'_Init_split_combine_remove.mat']);
X;
model;
tmpArray;
lossArray;
clusterNumArray;
splitArray;
iterNum;
 
xlabelArray = {'(a)','(b)','(c)','(d)','(e)','(f)'};

figure(40),
subplot(2,3,1),hold on;
plot(X,'-k','LineWidth',linewidth);
xlabel(xlabelArray{1},'FontSize',fontsize);
set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

selInds = [1,4,5,7,8];
for i = 1:length(selInds)
    C = tmpArray{selInds(i)}.C;
    Z = tmpArray{selInds(i)}.Z;
    L = tmpArray{selInds(i)}.L;

    subplot(2,3,i+1);
    hold on;
    tmpL = unique(L,'rows');
    for j = 1:size(tmpL,1)
        inds = find(((L(:,1)==tmpL(j,1)) .* (L(:,2)==tmpL(j,2)))==1);
        for k = 1:length(inds)
            plot(Z(inds(k),1):Z(inds(k),2),X(Z(inds(k),1):Z(inds(k),2)),colorArray{j},'LineWidth',linewidth);
        end
    end
    xlabel(xlabelArray{i+1},'FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    title(['k=',num2str(clusterNumArray(selInds(i)))],'FontSize',fontsize);
end    


