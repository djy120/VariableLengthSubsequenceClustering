


clear all;
close all;
clc;

%%
addpath('.\code\');


%%
colorArray{1} = '-r';
colorArray{2} = '-g';
colorArray{3} = '-b';
colorArray{4} = '-c';
colorArray{5} = '-m';
colorArray{6} = '-k';
% colorArray{7} = '-or';
% colorArray{8} = '-og';
% colorArray{9} = '-ob';
% colorArray{10} = '-oc';
% colorArray{11} = '-om';
% colorArray{12} = '-ok';


fontsize = 20;
linewidth = 1;

%%
dirname = '.\OurResults\';

fileGroup{1} = {[dirname,'Data_35_result.mat'],[dirname,'Data_23_result.mat'],[dirname,'Data_29_result.mat'],[dirname,'Data_22_result.mat']};
fileGroup{2} = {[dirname,'Data_38_result.mat'],[dirname,'Data_25_result.mat'],[dirname,'Data_30_result.mat']};
fileGroup{3} = {[dirname,'Data_28_result.mat'],[dirname,'Data_26_result.mat'],[dirname,'Data_27_result.mat']};

for dg = 1:length(fileGroup)
    filenames = fileGroup{dg};
    m = length(filenames);
    n = 4;
    figure,
    for df = 1:length(filenames)
        filename = filenames{df};
        load(filename);
        resResult = SubClusterStatistic(C,L);

        subplot(m,n,(df-1)*n+1),
        hold on;

        plot(X,'-k','LineWidth',linewidth);
        if (df==length(filenames))
            xlabel('(a)','FontSize',fontsize);
        end
        axis([0,floor(length(X)*1.05),0,1]);
        set(gca,'FontSize',fontsize);

        subplot(m,n,(df-1)*n+2),
        hold on;
        for i = 1:size(resResult,1)
            plot(resResult(i,5:resResult(i,1)+4),colorArray{i});
        end
        if (df==length(filenames))
            xlabel('(b)','FontSize',fontsize);
        end
        set(gca,'FontSize',fontsize);

        subplot(m,n,(df-1)*n+3),
        hold on;
        for i = 1:size(L,1)
            inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
            for j = 1:length(inds)
                plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(inds,length(colorArray)))},'LineWidth',linewidth);
            end
        end
        if (df==length(filenames))
            xlabel('(c)','FontSize',fontsize);
        end
        axis([0,floor(length(X)*1.05),0,1]);
        set(gca,'FontSize',fontsize);

        subplot(m,n,(df-1)*n+4),
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
        if (df==length(filenames))
            xlabel('(d)','FontSize',fontsize);
        end
        set(gca,'FontSize',fontsize);

    end
end






