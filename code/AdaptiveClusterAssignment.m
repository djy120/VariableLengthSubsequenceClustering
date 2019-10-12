%% Function for cluster assignment
%% Input:
%%      x: input subsequence
%%      C: cluster centers
%% Output:
%%      minD: the distance to the closest cluster
%%      minInd: the label of the closest cluster
function [minD,minInd] = AdaptiveClusterAssignment(x,C)

k = size(C,1);

flag = 0;
for i = 1:k
    if (sum(isinf(C(i,:)))==0)
        minD = sum( (x-C(i,:)).^2 );
        minInd = i;
        flag = 1;
        break;
    end
end

if (flag==0)
    minD    = [];
    minInd = [];
else
    for i = 1:k
        if (sum(isinf(C(i,:)))==0)
            d = sum( (x-C(i,:)).^2 );
            if (d<minD)
                minD    = d;
                minInd = i;
            end
        end
    end
end




