
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
linewidth = 1;


%% subsequence clustering on EEG time series with cluster number one
figure(61),

load('./OurResults/Data_14_result.mat');
resResult = SubClusterStatistic(C,L);

subplot(231),
plot(X,'-k','LineWidth',linewidth);
xlabel('(a)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(232),
plot(resResult(1,5:resResult(1,1)+4),colorArray{1},'LineWidth',linewidth);
xlabel('(b)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(233),
hold on;
for i = 1:size(Z,1)
    plot(X(Z(i,1):Z(i,2)),colorArray{1},'LineWidth',linewidth);
end
xlabel('(c)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

load('./OurResults/Data_18_result.mat');
resResult = SubClusterStatistic(C,L);

subplot(234),
plot(X,'-k','LineWidth',linewidth);
xlabel('(d)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(235),
plot(resResult(1,5:resResult(1,1)+4),colorArray{1},'LineWidth',linewidth);
xlabel('(e)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(236),
hold on;

for i = 1:size(Z,1)
    plot(X(Z(i,1):Z(i,2)),colorArray{1},'LineWidth',linewidth);
end
xlabel('(f)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

%% subsequence clustering on EEG time series with different cluster numbers
figure(62),

load('./OurResults/Data_14_result.mat'); % k=1
resResult = SubClusterStatistic(C,L);

subplot(231),
plot(X,'-k','LineWidth',linewidth);
xlabel('(a)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(232),
hold on;
for i = 1:size(resResult,1)
    plot(resResult(i,5:resResult(i,1)+4),colorArray{max(1,mod(i,length(colorArray)))});
end
xlabel('(b)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(233),
hold on;
for i = 1:size(Z,1)
    for j = 1:size(resResult,1)
        if (L(i,1)==resResult(j,3) && L(i,2)==resResult(j,4))
            plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(j,length(colorArray)))},'LineWidth',linewidth);
        end
    end
end
xlabel('(c)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

load('./OurResults/Data_40_result.mat'); % k=2
resResult = SubClusterStatistic(C,L);

subplot(234),
hold on;
for i = 1:size(resResult,1)
    plot(resResult(i,5:resResult(i,1)+4),colorArray{max(1,mod(i,length(colorArray)))});
end
xlabel('(d)','FontSize',fontsize);
set(gca,'FontSize',fontsize);

subplot(235),
hold on;
for i = 1:size(Z,1)
    for j = 1:size(resResult,1)
        if (L(i,1)==resResult(j,3) && L(i,2)==resResult(j,4))
            plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(j,length(colorArray)))},'LineWidth',linewidth);
        end
    end
end
xlabel('(e)','FontSize',fontsize);
set(gca,'FontSize',fontsize);
