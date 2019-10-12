function C = GenerateNewClusterBySplit(C,cInd,splitPos)

cls     = C{cInd(1)}.clusterCenter(cInd(2),:);
cls1   = cls(1:splitPos);
cls2   = cls(splitPos+1:end);
len1  = length(cls1);
len2  = length(cls2);

% remove old large cluster
C{cInd(1)}.clusterCenter(cInd(2),:) = inf;

% add a new cluster
ind = 0;
for m = 1:length(C)
    len = C{m}.len;
    if (len==len1)
        ind = m;
        break;
    end
end
if (ind==0)
    C{end+1}.clusterCenter(1,:) = cls1; %#ok<*AGROW>
    C{end}.len = len1;
else
    C{ind}.clusterCenter(end+1,:) = cls1;
end

% add another new cluster
ind = 0;
for m = 1:length(C)
    len = C{m}.len;
    if (len==len2)
        ind = m;
        break;
    end
end
if (ind==0)
    C{end+1}.clusterCenter(1,:) = cls2; %#ok<*AGROW>
    C{end}.len = len2;
else
    C{ind}.clusterCenter(end+1,:) = cls2;
end