function [resC,resL] = RemoveNullCluster(C,L)

if (size(L,2)==1)
    uL    = unique(L);
    resC = zeros(length(uL),size(C,2));
    resL = zeros(length(uL),1);
    for i = 1:length(uL)
        inds = find(L==uL(i));
        resC(i,:) = C(uL(i),:);
        resL(inds) = i; %#ok<FNDSB>
    end
else
    uL = unique(L,'rows');
    [~,inds] = sort(uL(:,1),'ascend');
    uL = uL(inds,:);

    uLens = unique(uL(:,1));
    resC   = cell(length(uLens),1);
    resL   = zeros(size(L,1),size(L,2));
    for i = 1:length(uLens)
        inds = find(uL(:,1)==uLens(i));
        for j = 1:length(inds)
            tmpInds                       = find( (L(:,1)==uL(inds(j),1)) .* (L(:,2)==uL(inds(j),2)) ==1 );
            resC{i}.len                     = C{uL(inds(j),1)}.len;
            resC{i}.clusterCenter(j,:) = C{uL(inds(j),1)}.clusterCenter(uL(inds(j),2),:);
            resL(tmpInds,:)              = repmat([i,j],length(tmpInds),1);
        end
    end
end
