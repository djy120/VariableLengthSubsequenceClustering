%% Cluster combination
function [Z,C,L] = RefineSubkmeansByComining(X,Z,C,L,model)

maxLen = model.maxLen;

origZ = Z;
origC = C;
origL = L;

% show current result
resResult = SubClusterStatistic(C,L);

%% Compute cluster neighbourhood matrix
rowInds = resResult(:,3);
colInds  = resResult(:,4);

clsNum = size(resResult,1);
corrMat = zeros(clsNum,clsNum);
for i = 1:size(L,1)-1
    ind1 = find( (rowInds==L(i,1)) .* (colInds==L(i,2)) ==1);
    ind2 = find( (rowInds==L(i+1,1)) .* (colInds==L(i+1,2)) ==1);
    len1 = C{L(i,1)}.len;
    len2 = C{L(i+1,1)}.len;
    if (len1<maxLen && len2<maxLen)
        corrMat(ind1,ind2) = corrMat(ind1,ind2)+1;
    end
end

if (max(corrMat(:))==0)
    return;
end

% DispMat(corrMat);

%% 
epslon = 10^(-6);

S1 = corrMat ./ repmat(max(1,sum(corrMat,2)),1,size(corrMat,2));
S2 = corrMat ./ repmat(max(1,sum(corrMat,1)),size(corrMat,1),1);

S = [S1(:);S2(:)];
[sortS,sortInd] = sort(S,'descend');
for i = 1:length(sortS)
    if (sortInd(i)<=length(S1(:)))
        [xInd,yInd] = ind2sub(size(S1),sortInd(i));
        cInd1 = resResult(xInd,3:4);
        cInd2 = resResult(yInd,3:4);
        comFlag = 0;
        [tmpZ,tmpC,tmpL] = ClusterCombinationCore(X,C,L,cInd1,cInd2,comFlag,model);
        dd = AdaptiveClusterCenterDistance(tmpC,C);
        if (dd>epslon)
            Z = tmpZ;
            C = tmpC;
            L = tmpL;
            break;
        end
    else
        [xInd,yInd] = ind2sub(size(S2),sortInd(i)-length(S1(:)));
        cInd1 = resResult(xInd,3:4);
        cInd2 = resResult(yInd,3:4);
        comFlag = 1;
        [tmpZ,tmpC,tmpL] = ClusterCombinationCore(X,C,L,cInd1,cInd2,comFlag,model);

        dd = AdaptiveClusterCenterDistance(tmpC,C);
        if (dd>epslon)
            Z = tmpZ;
            C = tmpC;
            L = tmpL;
            break;
        end
    end
end


if (isempty(L))
    disp('ww');
    Z = origZ;
    C = origC;
    L = origL;
end

%% Postprocess
[Z,C,L] = RemoveClusterWithFewSamples(X,Z,C,L);
[C,L] = RemoveNullCluster(C,L);


