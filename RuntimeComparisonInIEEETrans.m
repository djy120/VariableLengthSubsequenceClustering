
close all; clc;

addpath('.\code\');

%%
colorArray{1} = '-.*r';
colorArray{2} = '-.*g';
colorArray{3} = '-.*b';
colorArray{4} = '-.*k';
colorArray{5} = '-.*m';
colorArray{6} = '-.*c';
colorArray{7} = '-or';
colorArray{8} = '-og';
colorArray{9} = '-ob';
colorArray{10} = '-ok';
colorArray{11} = '-om';
colorArray{12} = '-oc';

pointColorArray{1} = '.r';
pointColorArray{2} = '.g';
pointColorArray{3} = '.b';
pointColorArray{4} = '.k';
pointColorArray{5} = '.m';
pointColorArray{6} = '.c';

fontsize = 40;
linewidth = 3;

%% 
dirname = '.\TimeComplexityResults\';
dataStr = 'GestureMidAirD1_runTimeArray_';

%%
load([dirname,dataStr,'ourResult.mat']);

TSLengthArray = zeros(1,length(inputSyntheticTimeArray));
for i = 1:length(inputSyntheticTimeArray)
    TSLengthArray(i) = length(inputSyntheticTimeArray{i}.X);
end

%%
figure(30),hold on;
legendStrArray = cell(11,1);


%% our result
num = 1;
load([dirname,dataStr,'ourResult.mat']);
runTimeArray;
muArray = mean(runTimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'Our model';

%% kmeans method
num = num + 1;
load([dirname,dataStr,'kmeans.mat']);
kmeans_RuntimeArray;
muArray = mean(kmeans_RuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'Kmeans';

%% dwtagk
num = num + 1;
load([dirname,dataStr,'dtwagk.mat']);
dtwagkRuntimeArray;
muArray = mean(dtwagkRuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'DTWGAK';

%% NeuralGas
num = num + 1;
load([dirname,dataStr,'nerualGas.mat']);
nerualGasRuntimeArray;
muArray = mean(nerualGasRuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'NeuralGas';

%% k-motif 
num = num + 1;
load([dirname,dataStr,'Motif.mat']);
Motif_RuntimeArray;
muArray = mean(Motif_RuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'Kmotif';

%% MDL motif
num = num + 1;
load([dirname,dataStr,'MDLMotif.mat']);
MDLMotif_RuntimeArray;
muArray = mean(MDLMotif_RuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'MDLKmotif';

%% variable-length motif
num = num + 1;
load([dirname,dataStr,'variableMotif.mat']);
variableMotif_RuntimeArray;
muArray = mean(variableMotif_RuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'VLmotif';

%% VALMOD
num = num + 1;
load([dirname,dataStr,'VALMOD.mat']);
valmod_RuntimeArray;
muArray = mean(valmod_RuntimeArray,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'VALMOD';

%% Extract: Strong examples from weakly-labeled sensor data
num = num + 1;
load([dirname,dataStr,'extract.mat']);
extract_time_array;
muArray = mean(extract_time_array,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'EXTRACT';

%% Toeplitz inverse covariance-based clustering of multivariate time series data
num = num + 1;
load([dirname,dataStr,'ticc.mat']);
ticc_runtime_array;
muArray = mean(ticc_runtime_array,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'TICC';

%% Casc: Context-aware segmentation and clustering for motif discovery in noisy time series data
num = num + 1;
load([dirname,dataStr,'casc.mat']);
casc_runtime_array;
muArray = mean(casc_runtime_array,2);
plot(TSLengthArray,muArray,colorArray{num},'LineWidth',linewidth);
legendStrArray{num} = 'CASC';

%%
xlabel('Time series length','FontSize',fontsize);
ylabel('Runtime (s)','FontSize',fontsize);
axis([0,6000, 0,3000]);
legend(legendStrArray,'FontSize',fontsize);
set(gca,'linewidth',linewidth,'fontsize',fontsize,'fontname','Times');


