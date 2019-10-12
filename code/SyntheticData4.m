%% Generate a time series with two different subsequence patterns with lengths of 10 and30 respectively.
%% This time series will be used to show our optimization process of cluster initializaiton, cluster splitting, cluster combination and cluster removing.
function [allData,k,minLen,maxLen,lenArray,groudTruthLabel] = SyntheticData4()

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


num = 20;
inds = randperm(num);
inds = mod(inds,2);

allData = [];
groudTruthLabel = [];
for i = 1:num
    if (inds(i)==0)
        allData = [allData,x1];
        groudTruthLabel = [groudTruthLabel, ones(1,n1)];
    elseif (inds(i)==1)
        allData = [allData,x2];
        groudTruthLabel = [groudTruthLabel, 2*ones(1,n2)];
    end
end

allData = allData + 0.1*(rand(1,length(allData))-0.5);

k = 2;
minLen = 5;
maxLen = 50;
lenArray = minLen:5:maxLen;