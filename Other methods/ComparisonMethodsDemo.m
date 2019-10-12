
close all; clc;

addpath('.\code\');

%% load data
dirname = '.\';
filenames = dir([dirname,'*.mat']);
saveDirname = '.\CompareResults\';


%%
for df = 1:length(filenames)
    filename = filenames(df).name;
    disp(filename);

    %% our result
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

    %% basic-kmeans method
    addpath('.\Kmeans\');
    KmeansRes = cell(size(resResult,1),1);
    k = size(resResult,1);
    for i = 1:size(resResult,1)
        allData = ExtractAllSubsequences(X,resResult(i,1));
        [idx,cls] = kmeans(allData,k);
        KmeansRes{i}.cls = cls;
        KmeansRes{i}.idx = idx;
        KmeansRes{i}.len = resResult(i,1);
    end
    
%     save([saveDirname,'Kmeans_',filename],'KmeansRes');
    
    %% DTWGAK and NeuralGas: Fast global alignment kernels   http://marcocuturi.net/GA.html 
    %% Dtwclust https://rdrr.io/cran/dtwclust/man/GAK.html
    %% Cclust: Convex clustering methods and clustering indexes  https://CRAN.R-project.org/package=cclust
    %% see in '.\DTWGAK and NeuralGas\MyTest.R';


    %% Kmotif 
    addpath('G:\my work\SubspaceKmeans\OtherCode\MyVariableMotiy\');

    MM = model.lenArray;
    MM = [MM,resResult(:,1)'];
    MM = unique(MM);
    MM = sort(MM,'ascend');
    Mark = zeros(1,length(X));
    motifArray = cell(length(MM),1);
    for i = 1:length(MM)
         motifArray{i}= MK_Motif2(X,MM(i),Mark);
    end
    MotifRes.motifArray = motifArray;
    MotifRes.MM = MM;

%     save([saveDirname,'Motif_',filename],'MotifRes');
    
    %% VLmotif: variable-length motif
    addpath('G:\my work\SubspaceKmeans\OtherCode\MyVariableMotiy\');

    ss = model.lenArray;
    MM = ss;
    MM = [MM,resResult(:,1)'];
    MM = unique(MM);
    MM = sort(MM,'ascend');
    variableMotif = VariableLengthMotif(X,MM);
    variableMotifRes.variableMotif = variableMotif;
    variableMotifRes.MM = MM;
    
%     save([saveDirname,'variableMotif_',filename],'variableMotifRes');
    
    %% MDL-motif
    addpath('.\Time Series Epenthesis\Code\');
    
    MM = model.lenArray;
    MM = [MM,resResult(:,1)'];
    MM = unique(MM);
    MM = sort(MM,'ascend');
    Mark = zeros(1,length(X));
    MaxStep = 100;
    MDLMotif= ClusteringML(X, MM, MaxStep);
    MDLMotifRes.MDLMotif = MDLMotif;
    MDLMotifRes.MM = MM; 

%     save([saveDirname,'MDLMotif_',filename],'MDLMotifRes');
    
    %% VALMOD£ºMatrix Profile X VALMOD - Scalable Discovery of Variable-Length Motifs in Data Series
    %% http://helios.mi.parisdescartes.fr/~mlinardi/VALMOD.html
    %% see in '.\VALMOD\MyTest.m¡¯

    
    %% EXTRACT: Extract: Strong examples from weakly-labeled sensor data
    %% https://github.com/dblalock/extract
    %% see in '.\EXTRACT\MyTest.py'
    
    
    %% TICC: Toeplitz inverse covariance-based clustering of multivariate time series data
    %% see in '.\TICC\MyTest2.py'


    %% CASC:  Casc: Context-aware segmentation and clustering for motif discovery in noisy time series data
    %% see in '.\CASC\my_test.py'


end




