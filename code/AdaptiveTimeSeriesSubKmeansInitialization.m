function resClusterArray = AdaptiveTimeSeriesSubKmeansInitialization(X,model)
k = model.k;
lenArray = model.lenArray;

resClusterArray = cell(length(lenArray),1);
for i = 1:length(lenArray)
    len = lenArray(i);
    disp(['Initializaiton for length ',num2str(len)]);
    [Z,C,L] =  FixedLenSubKmeansInTimeSeries(X,k,len);
    resClusterArray{i}.clusterCenter = C;
    resClusterArray{i}.len                 = len;
end