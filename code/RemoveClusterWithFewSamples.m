%% Remove clusters with few samples for speeding up.
function [Z,C,L] = RemoveClusterWithFewSamples(X,Z,C,L)

%%
maxIter = 500;

minNum = 2;
for i = 1:maxIter
    resResult = SubClusterStatistic(C,L);
    inds = find(resResult(:,2)<minNum);
    if (isempty(inds))
%         disp('converge');
        break;
    else
        for j = 1:length(inds)
            C{resResult(inds(j),3)}.clusterCenter(resResult(inds(j),4),:) = inf;
        end
    end
    [Z,C,L] = AdaptiveTimeSeriesSubKmeansIteration(X,C);

%     disp(['Postprocess ',num2str(i)]);
end

[C,L] = RemoveNullCluster(C,L);