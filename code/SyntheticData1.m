%% Generate a time series with three different subsequence patterns with lengths of 10, 15 and 30 respectively.
function [allData,k,minLen,maxLen,lenArray] = SyntheticData1()

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

num = 30;
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

allData = allData + 0.1*(rand(1,length(allData))-0.5);

k = 3;
minLen = 5;
maxLen = 50;
lenArray = minLen:5:maxLen;