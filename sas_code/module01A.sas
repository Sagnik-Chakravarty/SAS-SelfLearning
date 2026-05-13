/* Create a small survey style dataset */

data sample_file;
	length sample_id $8 region $12 assigned_mode $8;
	input sample_id $ region $ assigned_mode $ eligible weight;
	datalines;
S001 Northeast Web 1 1.20
S002 Midwest Mail 1 0.95
S003 South Web 1 1.10
S004 West Phone 0 1.35
S005 Northeast Mail 1 0.88
;
run;

/* See the structure */
proc contents data=sample_file;
run;

/* Print the data */
proc print data=sample_file;
run;

/* Create a new dataset from the old one */
data eligible_sample;
	set sample_file;
	if eligible = 1;
run;

/* Add new variables */
data eligible_sample2;
	set eligible_sample;
	web_case = assigned_mode = "Web";
	if weight >1 then high_weight = 1;
	else high_weight = 0;
run;

/* Print the cleaned data */
proc print data=eligible_sample2;
run;

/*Frequency tables */
proc freq data=eligible_sample2;
	tables region assigned_mode web_case high_weight/missing;
run;

/*Numeric summary */
proc means data=eligible_sample2 n mean min max;
	var weight;
run;