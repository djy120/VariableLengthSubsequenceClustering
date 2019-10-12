function allData = ExtractAllSubsequences(X,M)

allData = zeros(length(X)-M+1,M);
for i = 1:length(X)-M+1
    allData(i,:) = X(i:i+M-1);
end