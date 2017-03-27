ImportFitnessData <- function()
{
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "./Data.zip")
  unzip("./Data.zip", exdir = "./Data")
}

getCombinedFitnessData <- function()
{
  activity_label <- read.table("./Data/UCI HAR Dataset/activity_labels.txt",col.names = c("label","activity"), sep=" ", header=FALSE)
  
  features <- read.table("./Data/UCI HAR Dataset/features.txt", col.names = c("Id","feature"), header=FALSE)
  
  subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt",col.names = c("subject"), header=FALSE)
  
  subject_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"), header=FALSE)
  
  dataset_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", col.names = features$feature,header=FALSE)
  
  dataset_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", col.names = features$feature, header=FALSE)
  
  labels_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", col.names = c("label"), header=FALSE)
    
  labels_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", col.names = c("label"), header=FALSE)

  train_data <- cbind(subject_train,cbind(labels_train,dataset_train))
  
  test_data <- cbind(subject_test,cbind(labels_test,dataset_test))
  
  partialfulldata <- rbind(train_data,test_data)
  
  fulldata <- merge(partialfulldata,activity_label,by.x="label",by.y="label", all = TRUE)
  
  return(fulldata)
}

getMeanData <- function(fulldata = getCombinedFitnessData())
{
  meandata <- fulldata[,grep("mean\\.\\.|std\\.\\.|^subject|^activity",names(fulldata),value=TRUE)]
  return(meandata)
}

getFinalData <- function(meandata = getMeanData())
{
  library(reshape2)
  meandataMelt <- melt(meandata,id=grep("^subject|^activity",names(meandata),value=TRUE),measure.vars=grep("mean|std",names(meandata),value=TRUE))
  finaldata <- dcast(meandataMelt, subject + activity ~ variable,mean)
  colnames(finaldata) <- gsub("\\.","",names(finaldata))
  colnames(finaldata) <- gsub("BodyBody","Body",names(finaldata))
  colnames(finaldata) <- gsub("^t","time",names(finaldata))
  colnames(finaldata) <- gsub("^f","frequency",names(finaldata))
  colnames(finaldata) <- gsub("std","standarddeviation",names(finaldata))
  return(finaldata)
}