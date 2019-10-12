function dd = ComputeClusterCenterDistance(oldC,C)

k1 = size(oldC,1);
k2 = size(C,1);

if (abs(k1-k2)>0)
    dd = 10^(8); 
else
    % for empty cluster
    flag1 = zeros(k1,1);
    for i = 1:k1
        if (sum(isinf(oldC(i,:)))>0)
            flag1(i) = 1;
        end
    end

    flag2 = zeros(k2,1);
    for i = 1:k2
        if (sum(isinf(C(i,:)))>0)
            flag2(i) = 1;
        end
    end

    %
    if (max(abs(flag1-flag2))>0) % a big number
        dd = 10^(8); 
    elseif (sum(flag1)==k1)
        dd = 0;
    else
        c1 = oldC(flag1==0,:);
        c2 = C(flag2==0,:);
        if (size(c1,1)==1)
            dd = sum((c1-c2).^2);
        else
            dArray = zeros(size(c1,1),1);
            ff         = zeros(size(c1,1),1);
            for i = 1:size(c1,1)
                x      = c1(i,:);
                inds = find(ff==0);
                A     = c2(inds,:);
                tmp = sum((repmat(x,size(A,1),1)-A).^2,2);
                [v,ind] = min(tmp);
                dArray(i) = v;
                ff(inds(ind)) = 1;
            end
            dd = max(dArray);
        end
    end
end
    