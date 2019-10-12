%% Generate a time series with three random subsequence patterns with lengths of 10, 20 and 30 respectively. 
function [allData,k,minLen,maxLen,lenArray] = SyntheticData3()

n1 = 10;
x1 = zeros(1,n1);
for i = 1:n1
    x1(i) = rand;
end

n2 = 20;
x2 = zeros(1,n2);
for i = 1:n2
    x2(i) = rand;
end

n3 = 30;
x3 = zeros(1,n3);
for i = 1:n3
    x3(i) = rand;
end

num = 300;
inds = randperm(num);
inds = mod(inds,3);

allData = [];
for i = 1:num
    if (inds(i)==0)
        allData = [allData,x1];
    elseif (inds(i)==1)
        allData = [allData,x2];
    elseif (inds(i)==2)
        allData = [allData,x3];
    end
end

allData = allData + 0.01*(rand(1,length(allData))-0.5);

k = 3;
minLen = 2;
maxLen = 60;
lenArray = minLen:3:maxLen;