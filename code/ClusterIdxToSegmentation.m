function segArray = ClusterIdxToSegmentation(idx)

inds = find(abs(diff(idx))>0);

segArray = zeros(length(inds)+1,3);
segArray(1,1) = 1;
for i = 1:length(inds)
    segArray(i,2) = inds(i);
    segArray(i+1,1) = inds(i)+1;
    segArray(i,3) = idx(segArray(i,2));
end
segArray(end,2) = length(idx);
segArray(end,3) = idx(segArray(end,2));



