%% The core function for adaptive subsequence clustering
%% input:
%%      X : input data
%%      Z: old subsequence partition
%%      C: old cluster centers
%%      L: old label of each subsequence
%%      model: parameter settings
%%                model.k : the cluster number
%%                model.minLen : the minimal subsequence length
%%                model.maxLen : the maximal subsequence length
%%                model.lenArray: the length array of subsequences for initialization
%%      ifCombine: flag of cluster combination 
%%      ifSplit: flag of cluster splitting
%% output:
%%      Z: the subsequence partition
%%      C: the cluster centers
%%      L: the label of each subsequence
%%
%% Author: Jiangyong Duan
%% 	            Key Laboratory of Space Utilization, Technology and Engineering Center for Space Utilization, Chinese Academy of Sciences, 100094, Beijing, China
%%              e-mail: duanjy@csu.ac.cn
%%              2019/10/08
function [Z,C,L] = RefineSubkmeansByCombineAndSplit2(X,Z,C,L,model,ifCombine,ifSplit)

resResult = SubClusterStatistic(C,L);
oldK        = size(resResult,1);
preLost   = ComputeLostFunction(X,C,Z,L);
eplson    = 10^(-6);

%% cluster combination
[Z2,C2,L2] = RefineSubkmeansByComining(X,Z,C,L,model);
curLost = ComputeLostFunction(X,C2,Z2,L2);
if (curLost<=preLost)
    Z = Z2;
    C = C2;
    L = L2;
    resResult = SubClusterStatistic(C,L);
    disp(['Combination     Cluster number: ',num2str(size(resResult,1))]);
    ShowCluster(X,Z,C,L);
    DispMat(resResult(:,1:5));
    
    oldK = size(resResult,1);
    preLost = curLost;
end

%% cluster splitting
if (ifSplit==1)
    if (preLost<10^(-8))
        dd = 0;
        Z1 = Z;
        C1 = C;
        L1 = L;
    else
        [Z1,C1,L1] = SubkmeansSplitWithoutUpdate(X,Z,C,L,model); 
        dd = AdaptiveClusterCenterDistance(C,C1);
    end
    
    if (dd<eplson)
        disp('No split');
    else
        resResult = SubClusterStatistic(C1,L1);
        disp(['Splitting       Cluster number: ',num2str(size(resResult,1))]);
    %     ShowCluster(X,Z,C,L);
        DispMat(resResult(:,1:5));
        curLost = ComputeLostFunction(X,C1,Z1,L1);
        curK = size(resResult,1);
        if (curK<=oldK)
            ifCombine = 0;
            Z = Z1;
            C = C1;
            L = L1;
        end
    end
    
end

%% combination
if (ifCombine==1)
    if (ifSplit==1)
        [Z2,C2,L2] = RefineSubkmeansByComining(X,Z1,C1,L1,model);
    else
        [Z2,C2,L2] = RefineSubkmeansByComining(X,Z,C,L,model);
    end
    curLost = ComputeLostFunction(X,C2,Z2,L2);

    if (curLost<=preLost)
        Z = Z2;
        C = C2;
        L = L2;
        resResult = SubClusterStatistic(C,L);
        
        disp(['Combination     Cluster number: ',num2str(size(resResult,1))]);
        ShowCluster(X,Z,C,L);
        DispMat(resResult(:,1:5));
    end
end


