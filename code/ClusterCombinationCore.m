function [Z,C,L] = ClusterCombinationCore(X,C,L,cInd1,cInd2,comFlag,model)

maxLen = model.maxLen;

%%
len1   = C{cInd1(1)}.len;
len2   = C{cInd2(1)}.len;
cls1    = C{cInd1(1)}.clusterCenter(cInd1(2),:);
cls2    = C{cInd2(1)}.clusterCenter(cInd2(2),:);
num1 = sum( (L(:,1)==cInd1(1)) .* (L(:,2)==cInd1(2)) ==1);
num2 = sum( (L(:,1)==cInd2(1)) .* (L(:,2)==cInd2(2)) ==1);

% estimate the combination position
% interval = 1; % default value
interval = 3; % large number for speeding up
posArray = (len1-len2+2):interval:(len1+1);
if (posArray(end)<(len1+1))
    posArray(end+1) = len1+1;
end


%% 
ZArray     = cell(length(posArray),1);
CArray     = cell(length(posArray),1);
LArray     = cell(length(posArray),1);
lostArray = zeros(length(posArray),1);
flagArray = zeros(length(posArray),1);
for posInd = 1:length(posArray)
    
    i = posArray(posInd);
    newLen = i+len2-1;
    
    if (newLen>maxLen || newLen<len2+1)
        continue;
    end
    
    % combine the selected two clusters into one
    flagArray(posInd) = 1;
    
    newCls  = zeros(newLen,1);
    for j = 1:newLen
        if (j<=len1 && j<i)
            newCls(j) = cls1(j);
        elseif (j<=len1 && j>=i)
            newCls(j) = (num1 * cls1(j) + num2 * cls2(j-i+1)) / (num1+num2);
        else
            newCls(j) = cls2(j-i+1);
        end
    end
    % 
    tmpC = C;
    if (comFlag==0)
        tmpC{cInd1(1)}.clusterCenter(cInd1(2),:) = inf;
    elseif(comFlag==1)
        tmpC{cInd2(1)}.clusterCenter(cInd2(2),:) = inf;
    end
    
    %  new cluster
    ind = 0;
    for j = 1:length(C)
        len = C{j}.len;
        if (len==newLen)
            ind = j;
        end
    end
    if (ind==0)
        tmpC{end+1}.clusterCenter(1,:) = newCls; %#ok<*AGROW>
        tmpC{end}.len = newLen;
    else
        tmpC{ind}.clusterCenter(end+1,:) = newCls;
    end
    
    % model optimization after cluster combination
    [Z,tmpC,L] = AdaptiveTimeSeriesSubKmeansIteration(X,tmpC); 

    [Z,tmpC,L] = RemoveClusterWithFewSamples(X,Z,tmpC,L);

    lostArray(posInd) = ComputeLostFunction(X,tmpC,Z,L);
    ZArray{posInd}    = Z;
    CArray{posInd}    = tmpC;
    LArray{posInd}    = L;
    
%     disp(['Len: ',num2str(newLen)]);
end

%% Select the combination position with the minimal loss function
lostArray(flagArray==0) = nan;
[~,ind] = min(lostArray);

Z = ZArray{ind};
C = CArray{ind};
L = LArray{ind};


