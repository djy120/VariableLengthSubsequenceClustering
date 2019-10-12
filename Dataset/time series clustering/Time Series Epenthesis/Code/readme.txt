== Readme ==

To find the clustering from a given time series TS. 
1. Prepare the input time series and store it, says in variable TS.

1. set the length of motifs (subsequences in clusters) that you want.
   For example, 
		MM = [55:5:80];

2. run command ClusteringML on the input time series TS, and motif interval MM.
   For example, 
		Result = ClusteringML(TS, MM);
   
3. After receive a clustering result, run command DisplayClusterML, which required one parameter and two optional parameters.
   For more details, in command DisplayClusterML(Result, [delay, MaxSteps]);
   - Result      is the clustering result from step 2.
   - delay       is how long (in seconds) to pause between each step of clustering when cluster is displaying. Default value is 1 and the time between each step is 1 second. If default < 0, the program will pause at every step and wait until the user press any key.
   - Maxsteps    is the maximum number of steps which you want to see.
   For Example,  
		DisplayClusterML(Result);		 	% pause for 1 second between each step (default)
		DisplayClusterML(Result, 0.5);	  	% pause for 0.5 second between each step
		DisplayClusterML(Result, -1);		% pause until user press any key
		  

For quieck run, please try to use the following commands:
	load('Bird_MFCC.txt');
	Result = ClusteringML(Bird_MFCC, [55:5:80]);
	DisplayClusterML(Result);