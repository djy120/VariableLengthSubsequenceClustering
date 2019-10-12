function res = ClusterLabelCorrespond(label,refLabel)

a = unique(label);
b = unique(refLabel);

if (length(a)==length(b))
    
    corrMat = zeros(length(a),length(a));
    for i = 1:length(a)
        for j = 1:length(b)
            s1 = label==a(i);
            s2 = refLabel==b(j);
            s3 = s1.*s2;
            corrMat(i,j) = sum(s3);
        end
    end
    
    flag = ones(length(a),length(a));
    res = zeros(length(a),2);
    for i = 1:length(a)
        tmpMat = flag .* corrMat;
        [v,ind] = max(tmpMat(:));
        [xind,yind] = ind2sub([length(a),length(b)],ind);
        res(i,1) = a(xind);
        res(i,2) = b(yind);
        corrMat(xind,:) = -1;
        corrMat(:,yind) = -1;
    end
    
    res2 = zeros(length(a),2);
    for i = 1:length(a)
        ind = find(res(:,1)==a(i));
        res2(i,:) = res(ind,:);
    end
    res = res2;

else
    res = [];
end