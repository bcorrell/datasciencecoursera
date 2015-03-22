run_analysis <- function (fname1,fname2){

## Set up shop--this is a time-consuming install so only do if necessary
if ("dplyr" %in% installed.packages()[,"Package"] == FALSE){
   print("Installing dplyr package...")
   install.packages("dplyr")
   library(dplyr)
}   

# Hardwired filename strings used by code here
ffname = "./UCI HAR Dataset/features.txt"
afname = "./UCI HAR Dataset/activity_labels.txt"

ststname = "./UCI HAR Dataset/test/subject_test.txt"
strnname = "./UCI HAR Dataset/train/subject_train.txt"

ststyname = "./UCI HAR Dataset/test/y_test.txt"
strnyname = "./UCI HAR Dataset/train/y_train.txt"

## Read in data from text files fname1 and fname2 into data frames.  After my unzip I use 
##
##    fname1 = "./UCI HAR Dataset/test/X_test.txt"
##    fname2 = "./UCI HAR Dataset/train/X_train.txt"
##
df1 = read.table(fname1)
df2 = read.table(fname2)

## STEP 1:  Merge the test and training data
## The use of the merge command below makes use of the default merge which is
## to merge by common column names
mdf <- merge(df1,df2,all=TRUE)
    
## STEP 2:  Extract the data
##   
## Plan:  Use text processing to search for "mean" and "std" in features.txt
## to find indices on which to work.  These are stored as true in the Boolean
## list dataList.
## you often want a clipping data together function like rbind() or cbind(). 
## To work out how various parts (x files, y files, subjects, train vs test) 
## flow together try reading in the files and looking at their dimensions 
## with a command like dim(), by matching sizes like lego bricks there really 
## are a very limited number of ways the data can fit together.
## Perhaps use dplyr.  
con  <- file(ffname, open = "r")
dataList <- NULL
oneLine <- readLines(con, n=1, warn=FALSE)
while (length(oneLine)>0) {
   dataList<-c(dataList,(grepl("mean",oneLine) || grepl("std",oneLine) || grepl("Mean",oneLine)))
   oneLine <- readLines(con, n=1, warn=FALSE)
} 
close(con)
colstouse<-which(dataList)

## Use only relevant columns of the merged data frame--use dplyr here
mdf<-select(mdf,colstouse)

## STEP 3:  Name activities.  "This means that we want the data represented by terms 
## like "Walking" and "Sitting" rather than code numbers."  

## Read all activity labels and store in 6-vector actNames
con<-file(afname, open = "r")
data<-read.table(con,header=FALSE,sep=" ",stringsAsFactors=FALSE)
close(con)
actNames<-data[,2]

## Get test and train indices to activity labels
con<-file(ststyname, open = "r")
data<-read.table(con,header=FALSE,sep=" ",stringsAsFactors=FALSE)
close(con)
tst_subj_act_num<-data[,1]
N_tst<-length(tst_subj_act_num)

con<-file(strnyname, open = "r")
data<-read.table(con,header=FALSE,sep=" ",stringsAsFactors=FALSE)
close(con)
trn_subj_act_num<-data[,1]
N_trn<-length(trn_subj_act_num)

## STEP 4:  Appropriately labels the data set with descriptive variable names 
## Add a subject # column as well as an activity column.  We don't use a 
## "kind of data" column because the subject numbers for the test and training 
## sets partition {1,2,...,30}.  The syntax to create it would be
## mdf$KindOfData<-c(rep("Test",N_tst),rep("Train",N_trn))

## Read in subject number info
con<-file(ststname, open = "r")
data<-read.table(con,header=FALSE,sep=" ",stringsAsFactors=FALSE)
close(con)
tst_subj_num<-data[,1]

con<-file(strnname, open = "r")
data<-read.table(con,header=FALSE,sep=" ",stringsAsFactors=FALSE)
close(con)
trn_subj_num<-data[,1]

## Add a column of subject number labels--leftmost
mdf$SubjectNumber<-c(tst_subj_num,trn_subj_num)

## Add column of activity names to data frame--second leftmost column
mdf$Activity<-actNames[c(tst_subj_act_num,trn_subj_act_num)]

## STEP 5:  Create a second tidy data set with the average of each variable 
## for each activity and each subject.  
##
## Ours (dftidy) is going to be 30*6+1 x (86+2) because we have 30 total
## participants between test and training data sets, there are 6 activities
## for each, we have 86 features of interest, and we add 2 columns.

## This computes the data but leaves the columns unchanged
dftidy<-summarise_each(group_by(mdf, SubjectNumber, Activity),funs(mean))

## Labels for columns of summary stats will be "AverageOf"[FeatureName] 
## We've opened this file before but we read it
## in a different way here for programming convenience.
con<-file(ffname, open = "r")
data<-read.table(con,header=FALSE,sep=" ",stringsAsFactors=FALSE)
close(con)
fnames<-data[,2]
MostColNames<-fnames[colstouse]
MostColNames<-paste(rep("AverageOf",length(colstouse)),MostColNames,sep="")
dftidycolnames<-c("SubjectNumber","Activity",MostColNames)

## Rename the columns for added clarity
colnames(dftidy)<-dftidycolnames

## STEP 6:  Write to a text file using write.table() with row.name=FALSE
## As used below, this command write over the file if it exists without prompts.
## To examine output effectively, drag and drop file into Excel, highlight
## column A, click on Text-To-Columns under the Data tab, and select the
## space-delimited option.  You'll get errors if have the file open in
## Excel and run this code!
write.table(dftidy,"TidyDataFrameOutput.txt",row.names=FALSE)

}
