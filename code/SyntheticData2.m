%% A toy time series containing three different subsequence patterns
function [allData,k,minLen,maxLen,lenArray] = SyntheticData2()

for count = 1:50
    y(1+(count-1)*3) = 7;
    y(2+(count-1)*3) = 8;
    y(3+(count-1)*3) = 9;
end
for count = 51:100
    y(1+(count-1)*3) = 4;
    y(2+(count-1)*3) = 5;
    y(3+(count-1)*3) = 6;
end

for count = 101:150
    y(1+(count-1)*3) = 1;
    y(2+(count-1)*3) = 2;
    y(3+(count-1)*3) = 3;
end

for x = 451:900
    if rem(x,9) ~= 0
        y(x) = rem(x,9);
    else
        y(x) = 9;
    end
end

allData = y(1:450);
allData = allData + 0.1*(rand(1,length(allData))-0.5);

figure,plot(allData);

k = 3;
minLen = 2;
maxLen = 20;
lenArray = minLen:2:maxLen;
