

close all;


%%
addpath('.\code\');

%%
colorArray{1} = '-or';
colorArray{2} = '-og';
colorArray{3} = '-ob';
colorArray{4} = '-ok';
colorArray{5} = '-om';
colorArray{6} = '-oc';
colorArray{7} = '-r';
colorArray{8} = '-g';
colorArray{9} = '-b';
colorArray{10} = '-k';
colorArray{11} = '-*m';
colorArray{12} = '-*c';

fontsize = 20;

linewidth = 1;


%% Demo 1: subsequence clustering on three patterns with lengths of 10, 15 and 30 respectively.
% load('.\OurResults\SyntheticcodeInPaper1.mat');
% 
% [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
% C = ComputeClusterDescription(X,Z,C,L);
% model.C = C;
% 
% % show result
% lost = ComputeLostFunction(X,C,Z,L);
% 
% resResult = SubClusterStatistic(C,L);
% disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
% ShowCluster(X,Z,C,L);
% ShowApproximation(X,Z,C,L);

% Compare our results with the groundtruth on synthetic time series
% load('.\OurResults\SyntheticcodeInPaper1.mat');
% n1 = 10;
% x1 = zeros(1,n1);
% for i = 1:n1
%     x1(i) = i-1;
% end
% 
% n2 = 30;
% x2 = zeros(1,n2);
% a = (x1(1)-x1(end)) / (n2^2-1);
% b = x1(end) - a; 
% for i = 1:n2
%     x2(i) = a*i^2 + b;
% end
% 
% n3 = 15;
% x3 = zeros(1,n3);
% a = (x1(1)-x1(end)) / (n3^3-1);
% b = x1(end) - a; 
% for i = 1:n3
%     x3(i) = a*i^3 + b;
% end
% 
% maxLen = max([length(x1),length(x2),length(x3)]);
% tmpC = zeros(3,maxLen+4);
% tmpC(1,5:length(x1)+4) = x1;
% tmpC(2,5:length(x2)+4) = x2;
% tmpC(3,5:length(x3)+4) = x3;
% tmpC(:,1) = [10,30,15]';
% tmpC(:,5:end)  =tmpC(:,5:end)/9;
% 
% % show
% resResult = SubClusterStatistic(C,L);
% 
% CC = tmpC;
% for i = 1:size(resResult,1)
%     ind = find(tmpC(:,1)==resResult(i,1));
%     CC(i,:) = tmpC(ind,:);
% end
% tmpC = CC;
% 
% tmpLen = 300;
% 
% figure(50),
% subplot(221),
% hold on
% for i = 1:size(resResult,1)
%     plot(tmpC(i,5:resResult(i,1)+4),colorArray{i});
% end
% xlabel('(a)');
% legend({'pattern 1','pattern 2','pattern 3'})
% title('Original patterns');
% set(gca,'FontSize',fontsize);
% 
% subplot(222),
% plot(X(1:tmpLen),'-k');
% xlabel('(b)');
% title('Original time series');
% set(gca,'FontSize',fontsize);
% 
% subplot(223),
% hold on,
% for i = 1:size(resResult,1)
%     plot(resResult(i,5:resResult(i,1)+4),colorArray{i});
% end
% xlabel('(c)');
% legend({'cluster 1','cluster 2','cluster 3'})
% title('Extracted clusters');
% set(gca,'FontSize',fontsize);
% 
% subplot(224),
% hold on,
% for i = 1:size(Z,1)
%     inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
%     for j = 1:length(inds)
%         if (Z(i,1)<=tmpLen)
%             plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{inds});
%         else
%             break;
%         end
%     end
% end
% xlabel('(d)');
% title('Subsequence clustering results');
% set(gca,'FontSize',fontsize);


%% Demo 2: subsequence clustering on three randomly generated patterns with lengths of 10, 20 and 30 respectively.
% n1 = 10;
% x1 = zeros(1,n1);
% for i = 1:n1
%     x1(i) = rand;
% end
% 
% n2 = 20;
% x2 = zeros(1,n2);
% for i = 1:n2
%     x2(i) = rand;
% end
% 
% n3 = 30;
% x3 = zeros(1,n3);
% for i = 1:n3
%     x3(i) = rand;
% end
% 
% num = 20;
% inds = randperm(num);
% inds = mod(inds,3);
% 
% allData = [];
% for i = 1:num
%     if (inds(i)==0)
%         allData = [allData,x1];
%     elseif (inds(i)==1)
%         allData = [allData,x2];
%     elseif (inds(i)==2)
%         allData = [allData,x3];
%     end
% end
% 
% allData = allData + 0.01*(rand(1,length(allData))-0.5);
% 
% maxVal = max(allData);
% minVal = min(allData);
% allData = (allData-minVal)/(maxVal-minVal);
% 
% x1 = (x1-minVal)/(maxVal-minVal);
% x2 = (x2-minVal)/(maxVal-minVal);
% x3 = (x3-minVal)/(maxVal-minVal);
% 
% maxLen = max([length(x1),length(x2),length(x3)]);
% tmpC = zeros(3,maxLen+4);
% tmpC(1,5:length(x1)+4) = x1;
% tmpC(2,5:length(x2)+4) = x2;
% tmpC(3,5:length(x3)+4) = x3;
% tmpC(:,1) = [10,20,30]';
% tmpC(:,5:end)  =tmpC(:,5:end);
% 
% k = 3;
% minLen = 5;
% maxLen = 60;
% lenArray = minLen:5:maxLen;
% 
% model.k = k;
% model.minLen = minLen;
% model.maxLen = maxLen;
% model.lenArray = lenArray;
% 
% X = allData;
% [Z,C,L] = AdaptiveTimeSeriesSubKmeans2(X,model);
% C = ComputeClusterDescription(X,Z,C,L);
% model.C = C;
% 
% % show result
% lost = ComputeLostFunction(X,C,Z,L);
% 
% resResult = SubClusterStatistic(C,L);
% disp(['Cluster number: ',num2str(size(resResult,1)),' lost ',num2str(lost)]);
% ShowCluster(X,Z,C,L);
% 
% % 
% figure(55),
% subplot(221),
% hold on
% for i = 1:3
%     plot(tmpC(i,5:tmpC(i,1)+4),colorArray{mod(i,length(colorArray))+1});
% end
% xlabel('(a)');
% legend({'pattern 1','pattern 2','pattern 3'})
% title('Original patterns');
% set(gca,'FontSize',fontsize);
% 
% subplot(222),
% plot(X(1:tmpLen),'-r');
% xlabel('(b)');
% title('Original time series');
% set(gca,'FontSize',fontsize);
% 
% subplot(223),
% hold on,
% for i = 1:size(resResult,1)
%     plot(resResult(i,5:resResult(i,1)+4),colorArray{mod(i,length(colorArray))+1});
% end
% xlabel('(c)');
% legend({'cluster 1','cluster 2','cluster 3'})
% % title('Extracted clusters');
% set(gca,'FontSize',fontsize);
% 
% subplot(224),
% hold on,
% for i = 1:size(Z,1)
%     inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
%     for j = 1:length(inds)
%         if (Z(i,1)<=tmpLen)
%             plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{mod(inds,length(colorArray))+1});
%         else
%             break;
%         end
%     end
% end
% xlabel('(d)');
% title('Subsequence clustering results');
% set(gca,'FontSize',fontsize);
% 
% disp('ok');

