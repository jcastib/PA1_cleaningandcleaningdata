### PA1 -Getting and Cleaning Data
#  Data download
url1<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 

setwd("~/Desktop/coursera/R_courses/gettingandcelaningdata/Project1.Rmd")
download.file(url1, destfile="rawdata_pa1_getclean.zip", method="curl")
dataDownloaded_peerA1<-date()

unzip("rawdata_pa1_getclean.zip")

## Column Name change from Features downloaded files for the 561 columns

colnames<-read.table("./UCI HAR Dataset//features.txt") ### col names for the 561

############### Processing per each set

#### TEST SET 
#============================
# Data Frame with the total variable from the test set
test<-read.table("./UCI HAR Dataset/test//X_test.txt", header=T)
colnames(test)<-colnames$V2
dim(test)

# Dataframe with the Subject ID
testinv<-read.table("./UCI HAR Dataset//test/subject_test.txt", header=T)
dim(testinv)

# Dataframe with the Activity per row
testact<-read.table("./UCI HAR Dataset//test/y_test.txt", header=T)
colnames(testact)<-"Activity"
dim(testact)

# Column binding for 561 variable with Subject ID and Activity
cbind(test, testact, testinv)->testp2


#### TRAIN SET
#===========================
# Data Frame with the total variable from the train set
train<-read.table("./UCI HAR Dataset//train//X_train.txt", header=T) 
colnames(train)<-colnames$V2
dim(train)

# Dataframe with the Subject ID
traininv<-read.table("./UCI HAR Dataset//train/subject_train.txt", header=T)
str(traininv)
colnames(traininv)<-"Individual"
dim(traininv)

# Dataframe with the Activity per row
trainact<-read.table("./UCI HAR Dataset//train/y_train.txt", header=T)
colnames(trainact)<-"Activity"
dim(trainact)

# Column binding for 561 variable with Subject ID and Activity
cbind(train, trainact, traininv)->trainp2


#####--------MERGE OF TRAIN AND TEST DATA SETS

rbind(trainp2,testp2,deparse.level=1)->completeSet
dim(completeSet)


# Extraction of the measurements on the mean and standard deviation

grep("mean", colnames$V2)->meancol 
grep ("std", colnames$V2)->stdcol

names(completeSet [c(meancol, stdcol, 562, 563)])

completeSet[c(meancol, stdcol, 562, 563)]-> MeanStdSubset
dim(MeanStdSubset)

# Change descriptive activity names to name the activities in the data set

MeanStdSubset$Activity[MeanStdSubset$Activity == 1]<-"WALKING"
MeanStdSubset$Activity[MeanStdSubset$Activity == 2]<-"WALKING_UPSTAIRS"
MeanStdSubset$Activity[MeanStdSubset$Activity == 3]<-"WALKING_DOWNSTAIRS"
MeanStdSubset$Activity[MeanStdSubset$Activity == 4]<-"SITTING"
MeanStdSubset$Activity[MeanStdSubset$Activity == 5]<-"STANDING"
MeanStdSubset$Activity[MeanStdSubset$Activity == 6]<-"LAYING"

# Appropriately labels the data set with descriptive variable names. 

colnames(MeanStdSubset)<-tolower(names(MeanStdSubset))
colnames(MeanStdSubset)<-gsub("-","",names(MeanStdSubset))
MeanStdSubset$activity<-as.factor(MeanStdSubset$activity)
MeanStdSubset$individual<-as.factor(MeanStdSubset$individual)


### SECOND TIDY DATA SET USING ONLY THE FIRST 10 COLUMN FOR ESASE OF INPECTIONS WHEN AGGREGATION IS PERFORMED TAKING INTO ACCOUNT INDIVIDUAL AND ACTIVITY

settidy<-aggregate(MeanStdSubset[1:5],by=list(MeanStdSubset$individual,MeanStdSubset$activity),FUN=mean)
#head(settidy, n=60)

write.csv(settidy, file="settidy_1st5cols.csv", row.names=F)
