##Getting and Cleaning Data Course Project Analysis Steps

##downloading file from coursera link
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "C:/Users/jenna/Desktop/Getting-and-Cleaning-Data/data.zip")

##unzipping file
unzip("C:/Users/jenna/Desktop/Getting-and-Cleaning-Data/data.zip")

##setting work directory so I can use relative paths
setwd("C:/Users/jenna/Desktop/Getting-and-Cleaning-Data/UCI_HAR_Dataset")

##reading data in 
xtest<-read.table("./test/X_test.txt")
ytest<-read.table("./test/y_test.txt")
subtest<-read.table("./test/subject_test.txt")
xtrain<-read.table("./train/X_train.txt")
ytrain<-read.table("./train/y_train.txt")
subtrain<-read.table("./train/subject_train.txt")
activity<-read.table("./activity_labels.txt")

##merging train and test data
data<-rbind(xtest, xtrain)
labels<-rbind(ytest, ytrain)
subjects<-rbind(subtest, subtrain)

##subsetting the data for mean/std, changing column names
feat<-read.table("./features.txt")
list_b<-feat$V2
mtext<-grepl("mean()", list_b, fixed = TRUE)
stext<-grepl("std()", list_b, fixed = TRUE)
wanted_feats<-mtext|stext
feat_names<-list_b[wanted_feats]
dat_sub<-data[,wanted_feats]
colnames(dat_sub)<-feat_names
names(labels)<-"activity"
names(subjects)<-"subjects"

##tidy dataset with melt/cast
fulldata<-cbind(subjects, labels, dat_sub)
install.packages("reshape2")
library(reshape2)
melted<-melt(fulldata, id=c("subjects", "activity"))
casted<-dcast(melted, subjects + activity ~variable, mean)

##assigning meaningful activity labels
casted$activity<-factor(casted$activity, levels = c(1,2,3,4,5,6), labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))

##write.table of tidy dataset
write.table(tidydata, file = "C:/Users/jenna/Desktop/tidydata.txt", row.name=FALSE)

