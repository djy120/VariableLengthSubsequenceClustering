
close all; clc;
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
% colorArray{7} = '-or';
% colorArray{8} = '-og';
% colorArray{9} = '-ob';
% colorArray{10} = '-ok';
% colorArray{11} = '-om';
% colorArray{12} = '-oc';
colorArray{7} = '-.r';
colorArray{8} = '-.g';
colorArray{9} = '-.b';
colorArray{10} = '-*k';
colorArray{11} = '-.m';
colorArray{12} = '-.c';

% pointColorArray{1} = '.r';
% pointColorArray{2} = '.g';
% pointColorArray{3} = '.b';
% pointColorArray{4} = '.k';
% pointColorArray{5} = '.m';
% pointColorArray{6} = '.c';

fontsize = 20;
linewidth = 1;

%% cluster centers comparisons
dirname = '.\OurResults\';
saveDirname = '.\CompareResults\';

filenames(1).name = 'SyntheticcodeInPaper1.mat';
filenames(2).name = 'GestureMidAirD1_result.mat';

for df = 1:length(filenames)

    filename = filenames(df).name;
    
    figure(55), 
    
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

    tmpLen = length(X);
    
    %% original data and ground truth
    subplot(2,3,1)
    plot(X(1:tmpLen),'-k','LineWidth',linewidth);    
    xlabel('(a)','FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    
    if (strcmp(filename,'SyntheticcodeInPaper1.mat'))
        % groud truth
        n1 = 10;
        x1 = zeros(1,n1);
        for i = 1:n1
            x1(i) = i-1;
        end

        n2 = 30;
        x2 = zeros(1,n2);
        a = (x1(1)-x1(end)) / (n2^2-1);
        b = x1(end) - a; 
        for i = 1:n2
            x2(i) = a*i^2 + b;
        end

        n3 = 15;
        x3 = zeros(1,n3);
        a = (x1(1)-x1(end)) / (n3^3-1);
        b = x1(end) - a; 
        for i = 1:n3
            x3(i) = a*i^3 + b;
        end

        maxLen = max([length(x1),length(x2),length(x3)]);
        tmpC = zeros(3,maxLen+4);
        tmpC(1,5:length(x1)+4) = x1;
        tmpC(2,5:length(x2)+4) = x2;
        tmpC(3,5:length(x3)+4) = x3;
        tmpC(:,1) = [10,30,15]';
        tmpC(:,5:end)  =tmpC(:,5:end)/9;

        resResult = SubClusterStatistic(C,L);

        CC = tmpC;
        for i = 1:size(resResult,1)
            ind = find(tmpC(:,1)==resResult(i,1));
            CC(i,:) = tmpC(ind,:);
        end
        tmpC = CC;

        %groud truth
        subplot(2,3,2),
        hold on;
        for i = 1:size(resResult,1)
            plot(tmpC(i,5:resResult(i,1)+4),colorArray{i},'LineWidth',linewidth);
        end
        xlabel('(b)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    elseif (strcmp(filename,'GestureMidAirD1_result.mat'))
        selClusterInds;
        selSegInd;
        %groud truth
        subplot(2,3,2),
        hold on;
        for i = 1:length(selClusterInds)
            tmpInds = find(selSegInd(:,1)==selClusterInds(i));
            for j = 1:length(tmpInds)
                plot(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3),X(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i},'LineWidth',linewidth);
            end
        end
        xlabel('(b)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    end

    %% our method
    subplot(2,3,3)
    hold on;
    for i = 1:size(resResult,1)
        plot(resResult(i,5:resResult(i,1)+4),colorArray{i},'LineWidth',linewidth);
    end
    xlabel('(c)','FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    

    %% Kmeans
    if (exist([saveDirname,'Kmeans_',filename],'file'))
    
        load([saveDirname,'Kmeans_',filename]);
        KmeansRes;

        subplot(2,3,4),
        hold on;
        for i = 1:length(KmeansRes)
            for j = 1:size(KmeansRes{i}.cls,1)
                plot(KmeansRes{i}.cls(j,:),colorArray{(i-1)*length(KmeansRes)+j},'LineWidth',linewidth);
            end
        end
        xlabel('(d)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

    end
    
    
    %% DTWGAK and NeuralGas
    if (exist([saveDirname,'dtwPartition_',filename],'file'))
        load([saveDirname,'dtwPartition_',filename]);
        dtwPartitionClusterArray;
        agkClusterArray;
        dtwHierarchicalClusterArray;
        nerualGasClusterArray;
        windowSizeArray;

        for mm = 1:2
            if (mm==1)
                tmpRes = agkClusterArray;
                xlabelName = '(e)';
            elseif (mm==2)
                tmpRes = nerualGasClusterArray;
                xlabelName = '(f)';
            end

            ss = unique(resResult(:,1));
            indArray = zeros(length(ss),3);
            for i = 1:length(ss)
                [indArray(i,2),indArray(i,1)] = max(windowSizeArray(windowSizeArray<=resResult(i,1)));
                indArray(i,3) = resResult(i,1);
            end
            
            subplot(2,3,4+mm),
            hold on;
            for i = 1:size(indArray,1)
                allData = ExtractAllSubsequences(X,indArray(i,3));
                tt = tmpRes(indArray(i,1),:);
                tt = tt(tt>-1);
                tt = tt(1:size(allData,1));

                clsLabels = unique(tt);
                clsArray = zeros(length(clsLabels),size(allData,2));
                for j = 1:length(clsLabels)
                    clsArray(j,:) = mean(allData(tt==clsLabels(j),:));
                end
                
                for j = 1:length(clsLabels)
                    plot(clsArray(j,:),colorArray{(i-1)*size(indArray,1)+j},'LineWidth',linewidth);
                end
                xlabel(xlabelName,'FontSize',fontsize);
                set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

            end
        end
    end

end

