Observing that most time series are consisted of various patterns with different unknown lengths, we propose an optimization framework to adaptively estimate the lengths and
representations for different patterns.

Author: Jiangyong Duan
	Key Laboratory of Space Utilization, Technology and Engineering Center for Space Utilization, Chinese Academy of Sciences, 100094, Beijing, China
        e-mail: duanjy@csu.ac.cn

Date: 2019/10/08


To run our codes and show the results on variable-length subsequence clustering in time series, just run "demo.m"

In demo.m£¬the inputs and outputs are listed and explained below:

	inputs: the input time series and the model parameter settings

		X     ---- the input time series;

		model ---- the model settings of variable-length subsequence clustering

		    model.k        --- the cluster number

		    model.minLen   --- the minimal subsequence length

		    model.maxLen   --- the maximal subsequence length

		    model.lenArray --- the length array in cluster initialization, default value is [model.minLen:model.maxLen], you can set other values for speeding-up


	outputs: the resulted subsequence segmentation, clustering centers and clustering lables for each segmented subsequence.

		Z --- the estimated subsequence segmentation

		C --- the estimated clustering centers

		L --- the clustering lable for each segmented subsequence


To show our results on the synthetic time series on three subsequence patterns with length of 10, 15 and 30 respectively, see SyntheticResultInPaper.m

To show our results on the synthetic time series on three randomly generated subsequence patterns with length of 10, 20 and 30 respectively, see SyntheticResultInPaper.m

To show our results on  NAB synthetic time series, see NAB_test.m 
  
To show our results on  GestureMidAirD1 time series, see GestureMidAir_Test.m

To show our results on temperature time series, see TempdataResultsInPaper.m

To show our results on ECG time series, see EEG_test.m, EEG2_test.m and ECGResutlInPaper.m

To show our subsequence clustering process, see ClusterInitSplitCombineRemoveDemo.m

To compare with other methods, see ComparisonInPaper.m

To show the results of cluster center comparision, see ClusterCenterComparisonInPaperInIEEETrans.m

To show the results of subsequence comparision, see SubsequenceComparisonInPaperInIEEETrans.m

To show the results of time series segmentation comparision, see TimeSeriesSegmentationInPaperInIEEETrans.m

To show our results on runtime on GestureMidAirD1 time series, see RunTimeVSTimeLength2.m and RuntimeComparisonInIEEETrans.m

To show experiments on different minimal/maximal subsequence lengths and subsequence cluster numbers, see ParameterPerformanceInPaper.m

