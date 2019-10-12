function resArray = SubClusterStatistic(C,L)

uniqueClusters = unique(L,'rows');
[~,inds] = sort(uniqueClusters(:,1));
uniqueClusters = uniqueClusters(inds,:);

maxLen = 0;
for i = 1:size(uniqueClusters,1)
    p = C{uniqueClusters(i,1)}.len;
    if (p>maxLen)
        maxLen = p;
    end
end

resArray = zeros(size(uniqueClusters,1),maxLen+4);
for i = 1:size(uniqueClusters,1)
    p = C{uniqueClusters(i,1)}.len;
    c = C{uniqueClusters(i,1)}.clusterCenter(uniqueClusters(i,2),:);
    
    inds = find( (L(:,1)==uniqueClusters(i,1)) .* (L(:,2)==uniqueClusters(i,2)) ==1);
    num = length(inds);
    resArray(i,1) = p;
    resArray(i,2) = num;
    resArray(i,3) = uniqueClusters(i,1);
    resArray(i,4) = uniqueClusters(i,2);    
    resArray(i,5:4+length(c)) = c;
end


