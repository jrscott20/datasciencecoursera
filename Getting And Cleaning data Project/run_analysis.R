## Course Project Getting and Cleaning Data
## Coursera.com 
## 03/11/2015
## Jason Scott


# check to see if there is already the UCI HAR Datset directory in your working directory. If not, make one
# and download the data
if (!file.exists("./UCI HAR Dataset")) {
  temp<-tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp,mode="wb")

  
  #get all names of data set. After reading Readme.txt which is saved in the directory below I know that 
  # /UCI HAR Dataset/train/X_train.txt is the training set and /UCI HAR Dataset/test/X_test.txt is the 
  #test set
  fname<-unzip(temp,list=TRUE)$Name
  
  #Unzips files and saves them in your working directory. I wanted copies of the files
  #on my computer, but it is not necessary to do this.  Could read from temporary file.
  unzip(temp,exdir=getwd())
  }
setwd("./UCI HAR Dataset")

##paste together test files
x_test<-read.table("./test/X_test.txt") # test data
y_test<-read.table("./test/y_test.txt", colClasses="factor") # test activity labels
subject_test<-read.table("./test/subject_test.txt") ## test subject label
test<-cbind(x_test,y_test,subject_test) #paste together

##paste together train files
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt",colClasses="factor")
subject_train<-read.table("./train/subject_train.txt")
train<-cbind(x_train,y_train,subject_train) 



##paste test to train files
pasted<-rbind(test,train)

##give columns names
features<-read.table("./features.txt")
colnames(pasted)<-c(as.character(features[,2]), "Activity Code", "Subject") 

##Keep only measurements on the mean and standard deviation for each measurement
##Keep everything with "mean" or "Mean" in title
## Keep everything with "std"
## Keep Subject and Activity Code
vars<-colnames(pasted)
smallData<-pasted[,grepl("mean",vars) | grepl("Mean",vars) | grepl("std",vars)
                  | grepl("Subject",vars) | grepl("Activity Code",vars)]

##Replace activity factor levels, coded as numers, with their text value
activity_labels<-read.table("./activity_labels.txt",col.names=c("Activity Code","Activity"))
cleanData<-merge(smallData,activity_labels,by.x="Activity Code", by.y="Activity.Code",sort=FALSE)

## Calculate means of all the numeric variables for each subject and each activity
tidyMeans<-aggregate(cleanData,by=list(cleanData$Activity,cleanData$Subject),FUN=mean)
drops<-c("Subject","Activity","Activity Code")
tidyMeans<-tidyMeans[,!(names(tidyMeans) %in% drops)]
colnames(tidyMeans)[1:2]<-c("Activity","Subject")

##Write tidyMeans to txt file
write.table(tidyMeans, file="tidyMeans.txt",row.name=FALSE)
View(tidyMeans)

