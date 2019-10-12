function indArray = FindCorrespondingWindowSize(windowSizeArray,refLens)

ss = unique(refLens);
indArray = zeros(length(ss),3);
for i = 1:length(ss)
    [indArray(i,2),indArray(i,1)] = max(windowSizeArray(windowSizeArray<=refLens(i)));
    indArray(i,3) = refLens(i);
end