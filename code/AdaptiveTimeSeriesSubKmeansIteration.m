%% The core function of subsequence clustering with fixed subsequence lengths in time series
function [Z,C,L] = AdaptiveTimeSeriesSubKmeansIteration(X,oldC)

maxIter = 100;
epslon = 10^(-8);

for i = 1:maxIter

    % Given C, estimate Z and L
    [Z,L] =  UpdateAdaptiveSubsequencePartition(X,oldC);

    % Given Z and L, update C
    newC = UpdateAdaptiveClusterCenter(X,oldC,Z,L);

    % if convergence
    dd = AdaptiveClusterCenterDistance(oldC,newC);
    if (dd<epslon)
       % disp('Converge');
        break;
    end
    
    lost = ComputeLostFunction(X,newC,Z,L);
    %     disp(['Iteration: ',num2str(i),'   ',num2str(lost)]);

    oldC = newC;

end

C = newC;
[C,L] = RemoveNullCluster(C,L);

