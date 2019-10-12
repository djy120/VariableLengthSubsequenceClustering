
function [allData,model] = ReadData(dataSet)


lostFunction = 1; 

ifDTW = 0; 

groudTruthLabel = [];

switch dataSet
    case 1
        [allData,k,minLen,maxLen,lenArray] = SyntheticData1();

    case 2
        [allData,k,minLen,maxLen,lenArray] = SyntheticData2();
        
    case 3
        [a,b,c] = xlsread('.\NAB-master\NAB-master\data\realAWSCloudwatch\ec2_cpu_utilization_24ae8d.csv');
        allData = a';
        allData = allData(allData<0.5);
        
        k = 6;
        minLen = 2;
        maxLen = 80;
        lenArray = minLen:3:maxLen;

    case 4
        [a,b,c] = xlsread('.\NAB-master\data\artificialNoAnomaly\art_daily_small_noise.csv');
        allData = a';
        allData = allData(1:5:end);

        k = 1;
        minLen = 10;
        maxLen = 80;
        lenArray = minLen:5:maxLen;
        
    case 5
        [a,b,c] = xlsread('.\NAB-master\NAB-master\data\realAdExchange\exchange-2_cpc_results.csv');
        allData = a';
        
        k = 6;
        minLen = 2;
        maxLen = 80;
        lenArray = minLen:3:maxLen;
        
    case 6
        a = load('.\SubKmeans-author code\datasets\sample.dat');
        allData = a(:,2)';
        allData = allData(1:3:end);
        
        k = 2;
        minLen = 10;
        maxLen = 80;
        lenArray = minLen:10:maxLen;
        
    case 7
        a = load('.\nasa dashlink\FLEA\08-05-2010_UH60_2\UH60__8_5_2010_2_44_55 PM_Low.data');    
        allData = a(:,11)';
        allData = allData(1:100:end);
        
        k = 4;
        minLen = 5;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 8
        [a,b,c] = xlsread('.\time series clustering\monthly-milk-production-pounds-p.csv');
        allData = a';
        
        k = 4;
        minLen = 2;
        maxLen = 20;
        lenArray = minLen:3:maxLen;
        
    case 9
        [a,b,c] = xlsread('.\time series clustering\monthly-demand-repair-parts-larg.csv');
        allData = a';
        
        k = 4;
        minLen = 2;
        maxLen = 20;
        lenArray = minLen:3:maxLen;
        
    case 10
        a = load('.\nasa dashlink\Data_from_Sustainability_Base_Characterizing_Cold_Complaints_for_ACCEPT\Sustainability_Base_Characterizing_Cold_Training.mat');     
        allData = a.allData.data;
        allData = allData(1:20:end);
        
        k = 2;
        minLen = 5;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 11
        [a,b,c] = xlsread('.\NAB-master\data\artificialWithAnomaly\art_daily_flatmiddle.csv');     
        allData = a';
        
        k = 3;
        minLen = 5;
        maxLen = 20;
        lenArray = minLen:3:maxLen;
        
    case 12
        [allData,k,minLen,maxLen,lenArray] = SyntheticData3();
        
    case 13
        a = load('.\time series clustering\Time Series Epenthesis\Winding_data.txt');
        
        allData = a(:,4)';
        allData = allData(1:2:end);
        
        k = 4;
        minLen = 20;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 14
        a = load('.\time series clustering\Time Series Epenthesis\ECG2_data.txt');
        allData = a;
        k = 1;
        minLen = 20;
        maxLen = 100;
        lenArray = minLen:10:maxLen;
        
     case 15
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0007_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
     case 16
        a = load('.\time series clustering\CBF\CBF_TRAIN.txt');
        label = a(:,1);
        allData = [];
        for i = 1:size(a,1)
            allData = [allData,a(i,2:end)];
        end
        
        k = 3;
        minLen = 120;
        maxLen = 300;
        lenArray = minLen:10:maxLen;
        
     case 17
        a = load('.\time series classification\UCRArchive_2018\UCRArchive_2018\GestureMidAirD1\GestureMidAirD1_TRAIN.tsv');
        label = a(:,1);
        allData = [];
        for i = 1:size(a,1)
            tmpData = a(i,2:end);
            f = isnan(tmpData);
            tmpData = tmpData(f==0);
            allData = [allData,tmpData];
        end
        
        k = 3;
        minLen = 120;
        maxLen = 300;
        lenArray = minLen:10:maxLen;
        
    case 18
        a = load('.\time series clustering\Time Series Epenthesis\ECG1_data.txt');
        
        allData = a;
        
%         k = 2;
        k = 1;
        minLen = 20;
        maxLen = 100;
        lenArray = minLen:10:maxLen;
        
    case 19
        a = load('.\time series clustering\Time Series Epenthesis\ECG1_data.txt');
        
        allData = a;
        
%         k = 2;
        k = 3;
        minLen = 30;
        maxLen = 100;
        lenArray = minLen:10:maxLen;
        
    case 20
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0008_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 21
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0011_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 22
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0015_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 23
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0016_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 24
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0017_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 25
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0004_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 26
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0005_ceps.txt');
        
        allData = a;
        
        k = 2;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 27
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0006_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
                
    case 28
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0008_ceps.txt');
        
        allData = a;
        
        k = 2;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
                        
    case 29
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0009_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 30
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0010_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;
        
    case 31
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0015_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;                
                
    case 32
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0016_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;            
                        
    case 33
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0019_ceps.txt');
        
        allData = a;
        
        k = 4;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;            
                                
    case 34
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0020_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 40;
        lenArray = minLen:3:maxLen;         
                                        
    case 35
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_56d\dir.20060121_0001_ceps.txt');
        
        allData = a;
        
        k = 3;
        minLen = 10;
        maxLen = 60;
        lenArray = minLen:3:maxLen;         
                                         
    case 36
        [a,b,c] = xlsread('.\time series prediction\NAB-master\data\realTraffic\occupancy_t4013.csv');
        
        allData = a';
        allData = allData(1:2:end);
        
        k = 5;
        minLen = 10;
        maxLen = 60;
        lenArray = minLen:3:maxLen;            
                                                 
    case 37
        [a,b,c] = xlsread('.\UCI time series\gesture_phase_dataset\a1_raw.csv');
        
        allData = a(:,2)';
        allData = allData(1:2:end);
        
        k = 5;
        minLen = 20;
        maxLen = 60;
        lenArray = minLen:3:maxLen;     
        
    case 38
        a = load('.\time series clustering\Time Series Epenthesis\Temp_data\ceps_90d\dir.20060224_0002_ceps.txt');
        
        allData = a;
        
        k = 5;
        minLen = 5;
        maxLen = 60;
        lenArray = minLen:3:maxLen;  
        
    case 39
        [allData,k,minLen,maxLen,lenArray,groudTruthLabel] = SyntheticData4();
        
    case 40
        a = load('.\time series clustering\Time Series Epenthesis\ECG2_data.txt');
        allData = a;
        k = 2;
        minLen = 20;
        maxLen = 100;
        lenArray = minLen:10:maxLen;
                
end

maxVal = max(allData);
minVal = min(allData);
allData = (allData-minVal)/(maxVal-minVal);

model.k = k;
model.minLen = minLen;
model.maxLen = maxLen;
model.lenArray = lenArray;
model.lostFunction = lostFunction;
model.ifDTW = ifDTW;
model.groudTruthLabel = groudTruthLabel;

