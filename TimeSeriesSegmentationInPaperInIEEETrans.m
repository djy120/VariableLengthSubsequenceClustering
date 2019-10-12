
close all; clc;


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

pointColorArray{1} = '.r';
pointColorArray{2} = '.g';
pointColorArray{3} = '.b';
pointColorArray{4} = '.k';
pointColorArray{5} = '.m';
pointColorArray{6} = '.c';

fontsize = 20;
linewidth = 1;

%% time series segmentation comparisons
dirname = '.\OurResults\';
saveDirname = '.\CompareResults\';

filenames(1).name = 'SyntheticcodeInPaper1.mat';
filenames(2).name = 'GestureMidAirD1_result.mat';

segResComparisonArray = cell(1,7);

dr = 2;
dc = 4;
for df = 1:length(filenames)
    
    close all;

    filename = filenames(df).name;
    
    figure(56),
    
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
    tmpLen = length(X);

    %% original data
    subplot(dr,dc,1)
    plot(X(1:tmpLen),'-k','LineWidth',linewidth);    
    xlabel('(a)','FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    
    %% ground truth segmentation
    if (strcmp(filename,'SyntheticcodeInPaper1.mat'))
            
        subplot(dr,dc,2),
        hold on,
        for i = 1:size(Z,1)
            inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
            if (Z(i,1)<=tmpLen)
                plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{inds},'LineWidth',linewidth);
            end
        end
        xlabel('(b)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
        
        segRes = zeros(1,length(X));
        for i = 1:size(Z,1)
            inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
            if (Z(i,1)<=tmpLen)
                segRes(Z(i,1):Z(i,2)) = inds;
            end
        end
        segResComparisonArray{1}.name = 'ground truth';
        segResComparisonArray{1}.segRes = segRes;

    elseif (strcmp(filename,'GestureMidAirD1_result.mat'))
        selClusterInds;
        selSegInd;
        subplot(dr,dc,2),
        hold on;
        for i = 1:length(selClusterInds)
            tmpInds = find(selSegInd(:,1)==selClusterInds(i));
            for j = 1:length(tmpInds)
                plot(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3),X(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i},'LineWidth',linewidth);
            end
        end
        xlabel('(b)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
        
        segRes = zeros(1,length(X));
        for i = 1:length(selClusterInds)
            tmpInds = find(selSegInd(:,1)==selClusterInds(i));
            for j = 1:length(tmpInds)
                b = selSegInd(tmpInds(j),2);
                e = selSegInd(tmpInds(j),3);
                segRes(b:e) = selClusterInds(i);
            end
        end
        segResComparisonArray{1}.name = 'ground truth';
        segResComparisonArray{1}.segRes = segRes;
        
    end

    %% our method
    subplot(dr,dc,3),
    hold on,
    for i = 1:size(Z,1)
        inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
        for j = 1:length(inds)
            if (Z(i,1)<=tmpLen)
                plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{inds},'LineWidth',linewidth);
            else
                break;
            end
        end
    end
    xlabel('(c)','FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    
    
    segRes = zeros(1,length(X));
    for i = 1:size(Z,1)
        inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
        if (Z(i,1)<=tmpLen)
            segRes(Z(i,1):Z(i,2)) = inds;
        end
    end
    segResComparisonArray{2}.name = 'our method';
    segResComparisonArray{2}.segRes = segRes;

    %% Kmeans
    if (exist([saveDirname,'Kmeans_',filename],'file'))
    
        load([saveDirname,'Kmeans_',filename]);
        KmeansRes;
        
        subplot(dr,dc,4)
        hold on;
        for i = length(KmeansRes):length(KmeansRes)
            idx = KmeansRes{i}.idx;
            ra = floor(KmeansRes{i}.len/2);
            tmpIdx = zeros(length(X),1);
            tmpIdx(1:ra-1) = idx(1);
            tmpIdx(ra:ra+length(idx)-1) = idx;
            tmpIdx(ra+length(idx):end) = idx(end);
            idx = tmpIdx;

            segArray = ClusterIdxToSegmentation(idx);
            for j = 1:size(KmeansRes{i}.cls,1)   
                inds = find(segArray(:,3)==j);
                for m = 1:length(inds)
                    b = segArray(inds(m),1);
                    e = segArray(inds(m),2);
                    ra = ceil(KmeansRes{i}.len/2);
                    plot(b:e,X(b:e),colorArray{j},'LineWidth',linewidth);
                end
            end
        end
        xlabel('(d)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
        
        for i = length(KmeansRes):length(KmeansRes)
            idx = KmeansRes{i}.idx;
            ra = floor(KmeansRes{i}.len/2);
            tmpIdx = zeros(length(X),1);
            tmpIdx(1:ra-1) = idx(1);
            tmpIdx(ra:ra+length(idx)-1) = idx;
            tmpIdx(ra+length(idx):end) = idx(end);
            segRes = tmpIdx';
        end
        segResComparisonArray{3}.name = 'Kmeans';
        segResComparisonArray{3}.segRes = segRes;
           
    end
    
    
    %% DTWGAK and NeuralGas
    if (exist([saveDirname,'dtwPartition_',filename],'file'))
        load([saveDirname,'dtwPartition_',filename]);
        dtwPartitionClusterArray;
        agkClusterArray;
        dtwHierarchicalClusterArray;
        nerualGasClusterArray;
        windowSizeArray;
        
        indArray = FindCorrespondingWindowSize(windowSizeArray,resResult(:,1));
        
        for mm = 1:2
            if (mm==1)
                tmpRes = agkClusterArray;
                titleName = '(e)';
                methodName = 'agkCluster';
            elseif (mm==2)
                tmpRes = nerualGasClusterArray;
                titleName = '(f)';
                methodName = 'nerualGasCluster';
            end
            subplot(dr,dc,4+mm),
            hold on;
            for i = size(indArray,1):size(indArray,1)
                tt = tmpRes(indArray(i,1),:);
                idx = tt(tt>-1);
                
                ra = floor(windowSizeArray(indArray(i,1))/2);
                tmpIdx = zeros(length(X),1);
                tmpIdx(1:ra-1) = idx(1);
                tmpIdx(ra:ra+length(idx)-1) = idx;
                tmpIdx(ra+length(idx):end) = idx(end);
                idx = tmpIdx;
                
                segRes = idx';

                segArray = ClusterIdxToSegmentation(idx);
                for j = 1:max(idx)+1
                    inds = find(segArray(:,3)==j);
                    for m = 1:length(inds)
                        b = segArray(inds(m),1);
                        e = segArray(inds(m),2);
                        plot(b:e,X(b:e),colorArray{j},'LineWidth',linewidth);
                    end
                end
                xlabel(titleName,'FontSize',fontsize);
                set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

                segResComparisonArray{4+mm}.name = methodName;
                segResComparisonArray{4+mm}.segRes = segRes;

            end

        end
    end

    %% TICC
    if (exist([saveDirname,'TICC_',filename],'file'))
        load([saveDirname,'TICC_',filename]);
        cluster_assignment_array;
        window_size_array;
        
        subplot(dr,dc,7),
        hold on;
        indArray = FindCorrespondingWindowSize(window_size_array,resResult(:,1));
        for i = 2:2
            idx = cluster_assignment_array{i};
            ra = floor(window_size_array(i)/2);
            tmp = zeros(1,tmpLen);
            tmp(1:ra) = idx(1);
            tmp(ra:ra+length(idx)-1) = idx;
            tmp(ra+length(idx):end) = idx(end);
            idx = tmp;
            
            segRes = idx;
            
            segArray = ClusterIdxToSegmentation(idx(1:tmpLen));
            for j = 1:max(idx)+1
                inds = find(segArray(:,3)==j-1);
                for m = 1:length(inds)
                    b = segArray(inds(m),1);
                    e = segArray(inds(m),2);
                    plot(b:e,X(b:e),colorArray{j},'LineWidth',linewidth);
                end
            end
            xlabel('(g)','FontSize',fontsize);
            set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
            
            segResComparisonArray{7}.name = 'TICC';
            segResComparisonArray{7}.segRes = segRes;

        end
    end
    
    

    %% casc
    if (exist([saveDirname,'casc_',filename],'file'))
        load([saveDirname,'casc_',filename]);
        window_size_array;
        cluster_assignment_array;
        cluster_MRF_array;
        cluster_motifs_array;
        cluster_motifRanked_array;
        cluster_bic_array;
        
        
        subplot(dr,dc,8),
        hold on;
        for i = 2:2
            idx = cluster_assignment_array(i,:);           
            segArray = ClusterIdxToSegmentation(idx);
            for j = 1:max(idx)+1
                inds = find(segArray(:,3)==j-1);
                for m = 1:length(inds)
                    plot(segArray(inds(m),1):segArray(inds(m),2),X(segArray(inds(m),1):segArray(inds(m),2)),colorArray{j},'LineWidth',linewidth);
                end
            end
            xlabel('(h)','FontSize',fontsize);
            set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
            
            segRes = idx;
            segResComparisonArray{8}.name = 'CASC';
            segResComparisonArray{8}.segRes = segRes;
            
        end
    end

end

