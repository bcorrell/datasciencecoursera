---
title: "Codebook For Coursera Course Project"
date: "Sunday, March 22, 2015"
output: html_document
---

This codebook describes the transformations applied to the raw data set of the
course project (Coursera) to make a tidy data set by the script run_analysis.R.  The transformations create a 181 x 88 tidy set from a merged data set of training and test data made according to a set of online course project instructions.  Note that the numbering of 5 steps corresponds to the operations specified online.

To get started, the code uses read.table() to read in the test X-data and train X-data into 2 data frames df1 and df2, respectively.  The test data frame is 2947 observations (rows) of 561 variables (columns).  Similarly, the train data frame is 7352 x 561.  The required filenames are to be stored in the variables fnmae1 and fname2, respectively, and will be

fname1 = "./UCI HAR Dataset/test/X_test.txt"
fname2 = "./UCI HAR Dataset/test/X_train.txt"

1.  The script uses merge() to merge df1 and df2 along all of the 561 common columns to obtain the 10299 x 561 data frame mdf whose first rows are those of df1.   

2.  The column labels of df1, df2, and hence mdf are feature labels as listed in the features.txt file in the .zip file.  Read in this features file and find all 86 of the entries of labels that contain "mean", "Mean", "Std", or "std".  The merged data frame should only have these column labels so the code subsets the merged data frame to focus on them.  The required indices are found by line-by-line processing using 4 logical grepl statements.

3.  In order to eventually add an activity column to the merged data set, load in the file of activities activity_labels.txt.  Then load in the y-files from the test and training subdirectories.  These y-files contain integer indices from 1-6 that map to activities.  Create a length 10299 column vector from this data containing activity strings with the first (top) 2947 entries as the test activity labels.

4.  Read in the subect.txt files from the test and train directories.  Store the anonymizing subject #s in column vectors and concatenate these columns to obtain a length 10299 column vector with test subject #s as the top 2947 entries.  Add the columns to the merged data frame so that the subject number column is leftmost with the second column containing activity labels.  The script adds descriptive column names to the final tidy data set from this first, merged data frame mdf.  At this point mdf has 10299 rows and 88 columns.

5.  The script uses the summarize_each command to create a tidy data frame dftidy from the merged data frame.  The script groups by subject number and activity label and apply the mean to each of the other columns.  The result is a 181 x 88 data frame whose first row is a row of headers.  The next 180 rows contain the required averaged observations.  The script then adjusts the column labels.  From left to right, they are "SubjectNumber", "Activity", and then 86 average feature labels of the form "Average[*]" where the text in brackets is from features.txt.  The only entries of the tiday data frame that have units are the average statistics.  Since all features in the tidy data frame are means and are normalized to [-1,1], it follows that all the average feature values reported in the tidy data frame are unitless.

6.  The script writes this file to file to TidyDataFrameOutput.txt using write.table() and suppress listing of any row names.  

