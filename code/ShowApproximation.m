%% Approximate the original time series X with the estimated subsequence clusters of Z, C and L
function ShowApproximation(X,Z,C,L)

resResult = SubClusterStatistic(C,L);
clsVariance = zeros(size(resResult,1),5);
for i = 1:size(resResult,1)
    cInd = resResult(i,3:4);
    cls = C{cInd(1)}.clusterCenter(cInd(2),:);
    inds = find((L(:,1)==cInd(1)).*(L(:,2)==cInd(2))==1);
    tmpData = zeros(length(inds),length(cls));
    for j = 1:length(inds)
        tmpData(j,:) = X(Z(inds(j),1):Z(inds(j),2));
    end
    clsVariance(i,1:4) = resResult(i,1:4);
    clsVariance(i,5) = mean(sum((tmpData-repmat(cls,length(inds),1)).^2,2));
end

%
eplson = 10^(-6);
largeNum = 10^(10);
outlierScore = largeNum*ones(1,length(X));
newX = zeros(1,length(X));
for i = 1:size(Z,1)
    a = Z(i,1);
    b = Z(i,2);
    cls = C{L(i,1)}.clusterCenter(L(i,2),:);
    dd = sum((X(a:b)-cls).^(2));
    ind = find((clsVariance(:,3)==L(i,1)).*(clsVariance(:,4)==L(i,2))==1);
    dd = dd/max(clsVariance(ind,5),eplson); %#ok<*FNDSB>
    for j = a:b
        if (dd<outlierScore(j))
            outlierScore(j) = dd;
            newX(j) = cls(j-a+1);
        end
    end
end

%
errX = newX-X;

%
figure(23),
subplot(411),plot(X),title('Original');
subplot(412),plot(newX),title('Reconstruction');
subplot(413),plot(abs(errX)),title('Reconstruction error');
subplot(414),plot(outlierScore),title('outlier Score');
