
close all; clc;

addpath('.\code\');

%%
dirname = '.\OurResults\';
filenames = dir([dirname,'*.mat']);

saveDirname = '.\CompareResults\';

% for df = 1:length(filenames)
for df = 31:32
    filename = filenames(df).name;
    
    disp(filename);

    %% my result
    load([dirname,filename]);

    if (~exist('model') || ~exist('C') || ~exist('Z') || ~exist('L') )
        continue;
    end
    model;
    X;
    C;
    Z;
    L;
    resResult = SubClusterStatistic(C,L);

    %% basic-kmeans and hierarchical clustering methods
%     addpath('G:\my work\SubspaceKmeans\OtherCode\basic kmeans methods\');
% 
%     KmeansRes = cell(size(resResult,1),1);
%     HierRes = cell(size(resResult,1),1);
%     k = size(resResult,1);
%     for i = 1:size(resResult,1)
%         allData = ExtractAllSubsequences(X,resResult(i,1));
%         [idx,cls] = kmeans(allData,k);
%         KmeansRes{i}.cls = cls;
%         KmeansRes{i}.idx = idx;
%         KmeansRes{i}.len = resResult(i,1);
%         idx = clusterdata(allData,'linkage','ward','savememory','on','maxclust',k);
%         cls = zeros(k,resResult(i,1));
%         for j = 1:k
%             cls(j,:) = mean(allData(idx==j,:),1);
%         end
%         HierRes{i}.cls = cls;
%         HierRes{i}.idx = idx;
%         HierRes{i}.len = resResult(i,1);
%     end
%     
%     save([saveDirname,'Kmeans_',filename],'KmeansRes');

    %% k-motif and MDL-motif
%     addpath('G:\my work\SubspaceKmeans\OtherCode\Time Series Epenthesis\Code\');
%     addpath('G:\my work\SubspaceKmeans\OtherCode\MyVariableMotiy\');
% 
%     MM = model.lenArray;
%     MM = [MM,resResult(:,1)'];
%     MM = unique(MM);
%     MM = sort(MM,'ascend');
%     Mark = zeros(1,length(X));
%     motifArray = cell(length(MM),1);
%     for i = 1:length(MM)
%          motifArray{i}= MK_Motif2(X,MM(i),Mark);
%     end
%     MotifRes.motifArray = motifArray;
%     MotifRes.MM = MM;
% 
%     % MDL-motif
%     MM = model.lenArray;
%     MM = [MM,resResult(:,1)'];
%     MM = unique(MM);
%     MM = sort(MM,'ascend');
%     Mark = zeros(1,length(X));
%     MaxStep = 100;
%     MDLMotif= ClusteringML(X, MM, MaxStep);
%     MDLMotifRes.MDLMotif = MDLMotif;
%     MDLMotifRes.MM = MM; 
% 
%     save([saveDirname,'Motif_',filename],'MotifRes');
%     save([saveDirname,'MDLMotif_',filename],'MDLMotifRes');

    %% variable-length motif
%     addpath('G:\my work\SubspaceKmeans\OtherCode\MyVariableMotiy\');
% 
%     ss = model.lenArray;
%     MM = ss;
%     MM = [MM,resResult(:,1)'];
%     MM = unique(MM);
%     MM = sort(MM,'ascend');
%     variableMotif = VariableLengthMotif(X,MM);
%     variableMotifRes.variableMotif = variableMotif;
%     variableMotifRes.MM = MM;
% 
%     save([saveDirname,'variableMotif_',filename],'variableMotifRes');


    
    %% VALMOD£ºMatrix Profile X VALMOD - Scalable Discovery of Variable-Length Motifs in Data Series
    %% http://helios.mi.parisdescartes.fr/~mlinardi/VALMOD.html
    %% 'G:\my work\SubspaceKmeans\OtherCode\VALMOD_src\MyTest.m¡¯

    %% Toeplitz inverse covariance-based clustering of multivariate time series data
    %  'G:\my work\SubspaceKmeans\OtherCode\TICC-based\TICC-master\MyTest2.py'
    

    %% Greedy gaussian segmentation of multivariate time series
    %% useful for multivariate time series
    

    %% Casc: Context-aware segmentation and clustering for motif discovery in noisy time series data
    % 'G:\my work\SubspaceKmeans\OtherCode\TICC-based\casc-master\my_test.py'



    %% Fast global alignment kernels   http://marcocuturi.net/GA.html 
    %% Dtwclust https://rdrr.io/cran/dtwclust/man/GAK.html
    %% Cclust: Convex clustering methods and clustering indexes  https://CRAN.R-project.org/package=cclust
    %     'G:\my work\SubspaceKmeans\OtherCode\Fast global alignment kernels\dtwclust-master\MyTest.R';



    %% Extract: Strong examples from weakly-labeled sensor data
    %% https://github.com/dblalock/extract
    %% 'G:\my work\SubspaceKmeans\OtherCode\extract-master-variable length motif\MyRuntimeComparison.py'
    


end




