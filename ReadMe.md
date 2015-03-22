---
title: "ReadMe"
date: "Sunday, March 22, 2015"
output: html_document
---

This file describes scripts and their usage that are needed to make a tidy set for the raw data of the course project. 

1.  First download the .zip file from

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

2.  Unzip the .zip file so that the contents of .zip file going into folder called "UCI HAR Dataset".

3.  There is only one script:  run_analysis.R.  It requires 2 inputs:

fname1 = "./UCI HAR Dataset/test/X_test.txt"
fname2 = "./UCI HAR Dataset/train/X_train.txt"

The transformations carried out by the script are documented in CodeBook.md.  The script writes the resulting tidy data set to the file TidyDataFrameOutput.txt.  One way to examine output effectively is to drag and drop file into Excel, highlight column A, click on Text-To-Columns under the Data tab, and then select the space-delimited option.

