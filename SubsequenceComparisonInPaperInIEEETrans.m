
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

%% 
dirname = '.\OurResults\';
saveDirname = '.\CompareResults\';

filenames(1).name = 'SyntheticcodeInPaper1.mat';
filenames(2).name = 'GestureMidAirD1_result.mat';

%% subsequence comparisons
for df = 1:length(filenames)

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
    m = 2;
    n = 4;
    
    subplot(m,n,1)
    plot(X(1:tmpLen),'-k','LineWidth',linewidth);    
    xlabel('(a)','FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
   
    
    %% ground truth subsequences
    if (strcmp(filename,'SyntheticcodeInPaper1.mat'))
        subplot(m,n,2),
        hold on,
        for i = 1:size(Z,1)
            inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
            if (Z(i,1)<=tmpLen)
                plot(X(Z(i,1):Z(i,2)),colorArray{inds},'LineWidth',linewidth);
            end
        end
        xlabel('(b)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

    elseif (strcmp(filename,'GestureMidAirD1_result.mat'))
        selClusterInds;
        selSegInd;
        subplot(m,n,2),
        hold on;
        for i = 1:length(selClusterInds)
            tmpInds = find(selSegInd(:,1)==selClusterInds(i));
            for j = 1:length(tmpInds)
                plot(X(selSegInd(tmpInds(j),2):selSegInd(tmpInds(j),3)),colorArray{i},'LineWidth',linewidth);
            end
        end
        xlabel('(b)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    end

    %% our method
    subplot(m,n,3),
    hold on,
    for i = 1:size(Z,1)
        inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
        if (Z(i,1)<=tmpLen)
            plot(X(Z(i,1):Z(i,2)),colorArray{inds},'LineWidth',linewidth);
        end
    end
    xlabel('(c)','FontSize',fontsize);
    set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
   

    %% k-motif and MDL-motif
    if (exist([saveDirname,'Motif_',filename],'file'))
        load([saveDirname,'Motif_',filename]);
        load([saveDirname,'MDLMotif_',filename]);
        MotifRes;
        MDLMotifRes;
        
        indArray = FindCorrespondingWindowSize(MotifRes.MM,resResult(:,1));
        
        subplot(m,n,4),
        hold on;
        for i = 1:size(indArray,1)
            b1 = MotifRes.motifArray{indArray(i)}(2);
            e1 = b1+MotifRes.MM(indArray(i))-1;
            plot(X(b1:e1),colorArray{mod(i,6)+1},'LineWidth',linewidth);
        end
        xlabel('(d)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

        a = MDLMotifRes.MDLMotif.CPath{end};

        subplot(m,n,5),
        hold on;
        for i = 1:length(a)
            elm = a(i).elm;
            elm = elm(elm(:,2)>8,:);
            elm = elm(2:2:end,:);
            segArray = i*ones(size(elm,1),2);
            for j = 1:size(elm,1)
                segArray(j,1) = max(elm(j,1)-elm(j,3),1);
                segArray(j,2) = max(elm(j,1)+elm(j,2)-1-elm(j,3),1);
                plot(X(segArray(j,1):segArray(j,2)),colorArray{mod(j,6)+1},'LineWidth',linewidth);
            end
        end
        xlabel('(e)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

    end

    %% variable-length motif
    if (exist([saveDirname,'variableMotif_',filename],'file'))
        load([saveDirname,'variableMotif_',filename]);
        variableMotifRes;
        
        variableMotif = variableMotifRes.variableMotif;
        variableMotif = variableMotif(variableMotif(:,4)>8,:);

        subplot(m,n,6),
        hold on;
        for i = 1:size(variableMotif,1)
            b1 = variableMotif(i,2);
            e1 = b1+variableMotif(i,4)-1;
            plot(X(b1:e1),colorArray{mod(i,6)+1},'LineWidth',linewidth);
        end
        xlabel('(f)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

    end
    
    %% VALMOD
    if (exist([saveDirname,'VALMOD_',filename],'file'))
        load([saveDirname,'VALMOD_',filename]);
        VALMOD_motifs;

        subplot(m,n,7),
        hold on;
        for i = 1:size(VALMOD_motifs,1)
            b1 = VALMOD_motifs(i,1);
            e1 = b1+VALMOD_motifs(i,4)-1;
            plot(X(b1:e1),colorArray{mod(i,6)+1},'LineWidth',linewidth);
        end
        xlabel('(g)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');

    end    
    

    %% Extract: Strong examples from weakly-labeled sensor data
    %% https://github.com/dblalock/extract
    if (exist([saveDirname,'extract_',filename],'file'))
        load([saveDirname,'extract_',filename]);
        start_idx_array;
        end_idx_array;
        extract_model_array;
        feature_mat_array;
        feature_mat_blur_array;
        min_len_array;
        max_len_array;
        
        lenArray = zeros(length(start_idx_array),1);
        for i = 1:length(start_idx_array)
            lenArray(i) = unique(end_idx_array{i} - start_idx_array{i}) + 1;
        end
        indArray = zeros(length(lenArray),2);
        indArray(:,1) = [1:length(lenArray)]';

        subplot(m,n,8),
        hold on;
        for i = 1:size(indArray,1)
            s1 = start_idx_array{indArray(i,1)};
            s2 = end_idx_array{indArray(i,1)};
            for j = 1:length(s1)
                b = s1(j);
                e = s2(j);
                plot(X(b:e),colorArray{mod(j,6)+1},'LineWidth',linewidth);
            end
        end
        xlabel('(h)','FontSize',fontsize);
        set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');
    end
    
end
