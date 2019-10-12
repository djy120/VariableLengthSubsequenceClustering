%% Subsequence clustering for fixed length
%% input: 
%%      X : input time series
%%      k : cluster number
%%      p : subsequence length
%% output:
%%      Z: the subsequence partition
%%      C: the cluster centers
%%      L: the label of each subsequence
function [Z,C,L] =  FixedLenSubKmeansInTimeSeries(X,k,p)

n = length(X);

%% Random initialization
ss = randperm(n-p+1);
ss = ss(1:k);

C = zeros(k,p);
for i = 1:k
    C(i,:) = X(ss(i):ss(i)+p-1)';
end

%% Optimizaiton iteration
maxIter = 100;

epslon = 10^(-8);

oldC = C;
for i = 1:maxIter

    % Given C, update Z and L
    [Z,L] = UpdateSubsequencePartition(X,oldC);
    % Given Z and L, update C
    C = UpdateClusterCenter(X,Z,L,k,p);

    % if converge
    dd = ComputeClusterCenterDistance(oldC,C);
    if (dd<epslon)
%         disp('converge');
        break;
    end
    
    tmpC{1}.clusterCenter = C;
    tmpL = [ones(length(L),1),L];
    lost = ComputeLostFunction(X,tmpC,Z,tmpL);
    %     disp(['Iteration: ',num2str(i),'   ',num2str(lost)]);
    
    oldC = C;
end

% Remove clusters without subsequences
[C,L] = RemoveNullCluster(C,L);

