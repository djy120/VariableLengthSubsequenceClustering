%% subsequence cluster in time series
%% input:
%%      X : input data
%%      model: parameter settings
%%                model.k : the cluster number
%%                model.minLen : the minimal subsequence length
%%                model.maxLen : the maximal subsequence length
%%                model.lenArray: the length array of subsequences for initialization
%% output:
%%      Z: the subsequence partition
%%      C: the cluster center
%%      L: the label of each subsequence
%%
%% Author: Jiangyong Duan
%% 	            Key Laboratory of Space Utilization, Technology and Engineering Center for Space Utilization, Chinese Academy of Sciences, 100094, Beijing, China
%%              e-mail: duanjy@csu.ac.cn
%%              2019/10/08
function [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model)

k = model.k;

%% Initialization
[Z,C,L] = AdaptiveSubKmeansWithoutCombineAndSplit(X,model);

resResult = SubClusterStatistic(C,L);
DispMat(resResult(:,1:5));

lost = ComputeLostFunction(X,C,Z,L);
disp(['Iteration 1, cluster number ',num2str(size(resResult,1)), ',    Lost: ',num2str(lost)]);

%% Optimization by cluster combination, splitting and removing 
eplson       = 10^(-6);
ifSplit        = 1;
ifCombine = 1;

% To store the iteration process for test
tmpArray{1}.Z = Z;
tmpArray{1}.C = C;
tmpArray{1}.L = L;
num = 1;

oldK = size(resResult,1);
oldZ = Z;
oldC = C;
oldL = L;
preLost = lost;
ifStop = 0;
while (size(resResult,1)>=k && ifStop==0)
    close all;
    [Z,C,L] = RefineSubkmeansByCombineAndSplit2(X,Z,oldC,L,model,ifCombine,ifSplit);
    resResult = SubClusterStatistic(C,L);
    newK = size(resResult,1);
    dd = AdaptiveClusterCenterDistance(oldC,C);
    if (newK==oldK && dd<eplson)
        disp('Converge, reduce cluster number');
        if (newK<=1)
            break;
        end
        [tmpZ,tmpC,tmpL] = ReduceClusterByOne(X,C,L);
        resResult = SubClusterStatistic(tmpC,tmpL);  
        if (size(resResult,1)>=k)
            Z = tmpZ;
            C = tmpC;
            L = tmpL;
            ifSplit = 0;
            DispMat(resResult(:,1:5));
        else
            ifStop = 1;
        end
    elseif (newK>oldK)
        disp('cluster number increase');
        [Z,C,L] = ReduceClusterByOne(X,C,L);
        resResult = SubClusterStatistic(C,L);
        DispMat(resResult(:,1:5));
        tmpLost = ComputeLostFunction(X,C,Z,L);
        disp(['Lost: ',num2str(tmpLost)]);
        if (tmpLost>=preLost)
            Z = oldZ;
            C = oldC;
            L = oldL;
            ifSplit = 0;
        end
        resResult = SubClusterStatistic(C,L);  
        DispMat(resResult(:,1:5));
    end
    resResult = SubClusterStatistic(C,L);
    newK = size(resResult,1);
    if (newK<oldK)
        ifSplit = 1;
    end
    lost = ComputeLostFunction(X,C,Z,L);
    disp(['Iteration ',num2str(num+1), ', cluster number ',num2str(newK), ',    Lost: ',num2str(lost)]);
        
    oldC = C;
    oldZ = Z;
    oldL = L;
    preLost = lost;
    oldK = newK;
    
    num = num + 1;
    tmpArray{num}.Z = Z;
    tmpArray{num}.C = C;
    tmpArray{num}.L = L;
end
