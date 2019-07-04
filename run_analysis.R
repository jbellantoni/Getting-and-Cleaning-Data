##Getting and Cleaning Data Course Project Analysis Steps

##downloading folder/file
folder<-"UCI_HAR_Dataset"
file<-"data.zip"
if(!file.exists(folder)) {
      if(!file.exists(file)) {
            download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                          file
            )
      }
      unzip(file)
}
      

##reading data in 
xtest<-read.table("UCI_HAR_Dataset/test/X_test.txt")
ytest<-read.table("UCI_HAR_Dataset/test/y_test.txt")
subtest<-read.table("UCI_HAR_Dataset/test/subject_test.txt")
xtrain<-read.table("UCI_HAR_Dataset/train/X_train.txt")
ytrain<-read.table("UCI_HAR_Dataset/train/y_train.txt")
subtrain<-read.table("UCI_HAR_Dataset/train/subject_train.txt")
activity<-read.table("UCI_HAR_Dataset/activity_labels.txt")

##merging train and test data
data<-rbind(xtest, xtrain)
labels<-rbind(ytest, ytrain)
subjects<-rbind(subtest, subtrain)

##subsetting the data for mean/std, changing column names
feat<-read.table("UCI_HAR_Dataset/features.txt")
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
write.table(casted, file = "tidydata.txt", row.name=FALSE)

