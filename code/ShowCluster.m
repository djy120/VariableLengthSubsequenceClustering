function ShowCluster(X,Z,C,L)

%%
resResult = SubClusterStatistic(C,L);

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

%%
figure(50),
hold on;
for i = 1:size(resResult,1)
    plot(resResult(i,5:resResult(i,1)+4),colorArray{max(1,mod(i,length(colorArray)))});
end
title(num2str(size(resResult,1)));

figure(51),
hold on;
for i = 1:size(Z,1)
    inds = find( (resResult(:,3)==L(i,1)).*(resResult(:,4)==L(i,2)) ==1);
    for j = 1:length(inds)
        plot(Z(i,1):Z(i,2),X(Z(i,1):Z(i,2)),colorArray{max(1,mod(inds,length(colorArray)))});
    end
end
title(num2str(size(resResult,1)));


