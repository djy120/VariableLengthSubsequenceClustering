function [minD,minInd] = ClusterAssignment(x,C)

k = size(C,1);
p = size(C,2);

% for empty cluster
flag = zeros(k,1);
for i = 1:k
    if (sum(isinf(C(i,:)))>0)
        flag(i) = 1;
        C(i,:) = rand(1,p);
    end
end

mm = sum((repmat(x,k,1)-C).^2,2);
mm(flag==1) = max(mm) + 1;
[minD,minInd] = min(mm);