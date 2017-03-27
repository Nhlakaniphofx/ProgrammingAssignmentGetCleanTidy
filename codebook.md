ProgrammingAssignmentGetCleanTidy
Programming assignment for getting, cleaning and tidying data for Coursera Data Science Specialization

========================================================================================================

run_analysis.r

This is a script that processes data provided by Human Activity Recognition Using Smartphones Simarrized Dataset, link - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Please follow the below to get finaldatafile - sumsung_galaxy_s2_fitness_data.txt:

1. Download R (If you currently dont have it on your machine)

2. Download run_analysis.r script to a you desired working directory

3. Open R

4. Change you working directory using:
   setwd(directory_path)

5. Source the run_analysis.r script using
   source(r_analysis.r_directory_path)

6. The first function you need to run is ImportFitnessData using:
   ImportFitnessData()

   Details Of Function:
   		 This function requires no agurements to avoid mistake of user/tester entering incorrect url.
   		 This was to speed up the process of testing since getting data to clean is the priority.

   		 ContentOfFunction:
   		 1.  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" - assigns url to variable fileurl pointing to loation of files

   		 2.download.file(fileUrl, destfile = "./Data.zip") downloads the file to Data.zip in the working directory for ease of access

   		 3. unzip("./Data.zip", exdir = "./Data") unzips file to get the content of the data.


7. run createFinalFile() - uses data returned by "8" to created the final tidy data text file name : ./sumsung_galaxy_s2_fitness_data.txt. This can be found in your du=irectory after running this function


8. We then group/reshape data according to requirement of subject-activity-measure then we ensure our columns are named relavently using:

getFinalData ()
returns (finaldata which will be suppliered as the final tidy version of data)

Details of Function:
		This function default argument which it gets from the function listed at step "10".
		 This was to speed up the process of testing since getting data to clean state is the priority.

		 1. initiate reshape library for use to shape data in a form we require it in
		 	library(reshape2)

		 2. Melt data to get the variable measurements lined up to better make grouping accordinf to requirement easier 

		 meandataMelt <- melt(meandata,id=grep("^subject|^activity",names(meandata),value=TRUE),measure.vars=grep("mean|std",names(meandata),value=TRUE))

		 3. Dcast the data to group subject and activity getting the required average measurement per grouping 

		 finaldata <- dcast(meandataMelt, subject + activity ~ variable,mean)

		 4. The beloow id staright forward to substitute names until I get my designed naming convention. 

		 colnames(finaldata) <- gsub("\\.","",names(finaldata))
  		 colnames(finaldata) <- gsub("BodyBody","Body",names(finaldata))
  		 colnames(finaldata) <- gsub("^t","time",names(finaldata))
  		 colnames(finaldata) <- gsub("^f","frequency",names(finaldata))
  		 colnames(finaldata) <- gsub("std","standarddeviation",names(finaldata))

9. We will now be getting the averages and standard deviations of the measures as required, it will be used by "8"

getMeanData()
returns (meandata which is the means and standard diviations of the measurements we are interested in)

Details of Function:
		 This function default argument which it gets from the function listed at step "11".
		 This was to speed up the process of testing since getting data to clean state is the priority.
		 
		 1. grep to find all column names that match the critiria of mean and std(abbr. used for standard deviation in data). Please note _ and () was replaced by . and .. at time of import and I had to use \\. to not mistake . for the build in identifier for any charactor. I then used the filters column names to subset the columns I needed from the data.

		 I had to included activity and subject becuase these are other metrics I am interested in that didnt include mean() or std() in my dataset.

		 meandata <- fulldata[,grep("mean\\.\\.|std\\.\\.|^subject|^activity",names(fulldata),value=TRUE)]


10. For this step I had to try figure our what the question wanted to know which data to pull and how using the README.txt file provided in the Data file you got from above.

		I am interested in the following datasets from the provided data:

		1. test set - (./Data/UCI HAR Dataset/train/X_test.txt)
		2. train set - (./Data/UCI HAR Dataset/train/X_train.txt)
		3. test subjects - (./Data/UCI HAR Dataset/train/subject_test.txt)
		4. train subjects - (./Data/UCI HAR Dataset/train/subject_train.txt)
		5. activity_labels - (./Data/UCI HAR Dataset/activity_labels.txt)
		6. features - (./Data/UCI HAR Dataset/features.txt)
		7. train labels - (./Data/UCI HAR Dataset/train/y_train.txt)
		8. test labels - (./Data/UCI HAR Dataset/train/y_train.txt)

11.  "10" led me to the creation of the function getCombinedFitnessData which should be executed next used by "9"

getCombinedFitnessData()
returns (fulldata merged and ready to be used for further cleansing)

Details of Function:
		 This function requires no agurements to avoid mistake of user/tester entering incorrect fileNames.
   		 This was to speed up the process of testing since getting data to clean state is the priority.
		
		 1. The following lines just reads the data vectors to a variable to be manipulated at a later stage. Each set has been given specific column names according to the content of the data needed.

		 activity_label <- read.table("./Data/UCI HAR Dataset/activity_labels.txt",col.names = c("label","activity"), sep=" ", header=FALSE)
  
  		 features <- read.table("./Data/UCI HAR Dataset/features.txt", col.names = c("Id","feature"), header=FALSE)
  
  		 subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt",col.names = c("subject"), header=FALSE)
  
  		 subject_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"), header=FALSE)
  
  		 dataset_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", col.names = features$feature,header=FALSE)
  
  		 dataset_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", col.names = features$feature, header=FALSE)
  
  		 labels_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt", col.names = c("label"), header=FALSE)
    
  		 labels_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt", col.names = c("label"), header=FALSE)

  		 2. Column bind the separated columns to get unique set of data for both test and train data. I choice subject to be the left most data then labels to easily identify datasets' variable (measure) from subjects and activitities

  		 train_data <- cbind(subject_train,cbind(labels_train,dataset_train))
  
 		 test_data <- cbind(subject_test,cbind(labels_test,dataset_test))

 		 3. Row bind the train set and test set to get a single fitness data set

 		 partialfulldata <- rbind(train_data,test_data)

 		 4. Merged the activity_label and partialfulldata (single fitness data set) to be able to extract the activities by name rather than by label. I prefered to do this step at the add to avoid messing up my data with the merge function sorting and scattered data I need to combine in some way.

 		 fulldata <- merge(partialfulldata,activity_label,by.x="label",by.y="label", all = TRUE)

=================================================================================================

sumsung_galaxy_s2_fitness_data.txt


 subject    (Integer)
       - Number represeenting the subjects

 activity   (Factor, 6 levels, WALKING WALKING_UPSTAIRS WALKING_DOWNSTAIRS SITTING STANDING LAYING)
 	   -  Activity purformed by each subject

 timeBodyAccmeanX   (Numeric)
 	   - Average Subject-Activity measure for X-axis TimeBodyAcc Average

 timeBodyAccmeanY   (Numeric)
 	   - Average Subject-Activity measure Y-axis TimeBodyAcc Average

 timeBodyAccmeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis TimeBodyAcc Average

 timeBodyAccstandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-axis TimeBodyAcc Standard Deviation
 	   
 timeBodyAccstandarddeviationY   (Numeric)
 	   - Average Subject-Activity measure Y-axis TimeBodyAcc Standard Deviation
 	   
 timeBodyAccstandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis TimeBodyAcc Standard Deviation
 	   
 timeGravityAccmeanX   (Numeric)
 	   - Average Subject-Activity measure X-axis TimeGravityAcc Average
 	   
 timeGravityAccmeanY   (Numeric)
 	   - Average Subject-Activity measure Y-axis TimeGravityAcc Average
 	   
 timeGravityAccmeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis TimeGravityAcc Average
 	   
 timeGravityAccstandarddeviationX   (Numeric) 
 	   - Average Subject-Activity measure X-axis TimeGravityAcc Standard Deviation 
 	   
 timeGravityAccstandarddeviationY   (Numeric) Y-axis TimeGravityAcc Standard Deviation 
 	   - Average Subject-Activity measure
 	   
 timeGravityAccstandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis TimeGravityAcc Standard Deviation 
 	   
 timeBodyAccJerkmeanX   (Numeric)
 	   - Average Subject-Activity measure X-axis TimeBodyAccJerk Average 
 	   
 timeBodyAccJerkmeanY   (Numeric)
 	   - Average Subject-Activity measure Y-axis TimeBodyAccJerk Average 
 	   
 timeBodyAccJerkmeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis TimeBodyAccJerk Average 
 	   
 timeBodyAccJerkstandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-axis TimeBodyAccJerk Standard Deviation 
 	   
 timeBodyAccJerkstandarddeviationY   (Numeric)
 	   - Average Subject-Activity measure Y-axis TimeBodyAccJerk Standard Deviation
 	   
 timeBodyAccJerkstandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis TimeBodyAccJerk Standard Deviation
 	   
 timeBodyGyromeanX   (Numeric)
 	   - Average Subject-Activity measure X-Axis TimeBodyGyro Average
 	   
 timeBodyGyromeanY   (Numeric)
 	   - Average Subject-Activity measure Y-Axis TimeBodyGyro Average
 	   
 timeBodyGyromeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-Axis TimeBodyGyro Average
 	   
 timeBodyGyrostandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-Axis TimeBodyGyro Standard Deviation
 	   
 timeBodyGyrostandarddeviationY   (Numeric)
 	   - Average Subject-Activity measure Y-Axis TimeBodyGyro Standard Deviation
 	   
 timeBodyGyrostandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-Axis TimeBodyGyro Standard Deviation
 	   
 timeBodyGyroJerkmeanX   (Numeric)
 	   - Average Subject-Activity measure X-Axis TimeBodyGyroJerk Average
 	   
 timeBodyGyroJerkmeanY   (Numeric)
 	   - Average Subject-Activity measure Y-Axis TimeBodyGyroJerk Average
 	   
 timeBodyGyroJerkmeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-Axis TimeBodyGyroJerk Average
 	   
 timeBodyGyroJerkstandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-Axis TimeBodyGyroJerk Standard Deviation
 	   
 timeBodyGyroJerkstandarddeviationY    (Numeric)
 	   - Average Subject-Activity measure Y-Axis TimeBodyGyroJerk Standard Deviation
 	   
 timeBodyGyroJerkstandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-Axis TimeBodyGyroJerk Standard Deviation
 	   
 timeBodyAccMagmean   (Numeric)
 	   - Average Subject-Activity measure TimeBodyAccMag Average
 	   
 timeBodyAccMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure TimeBodyAccMag Standard Deviation
 	   
 timeGravityAccMagmean   (Numeric)
 	   - Average Subject-Activity measure TimeGravityAccMag Average
 	   
 timeGravityAccMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure TimeGravityAccMag Standard Deviation
 	   
 timeBodyAccJerkMagmean    (Numeric)
 	   - Average Subject-Activity measure TimeBodyAccJerkMag Average
 	   
 timeBodyAccJerkMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure TimeBodyAccJerkMag Standard Deviation
 	   
 timeBodyGyroMagmean   (Numeric)
 	   - Average Subject-Activity measure TimeBodyGyroMag Average
 	   
 timeBodyGyroMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure TimeBodyGyroMag Standard Deviation 
 	   
 timeBodyGyroJerkMagmean   (Numeric)
 	   - Average Subject-Activity measure TimeBodyGyroJerkMag Averaage
 	   
 timeBodyGyroJerkMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure TimeBodyGyroJerkMag Standard Deviation 
 	   
 frequencyBodyAccmeanX    (Numeric) 
 	   - Average Subject-Activity measure X-axis FrequencyBodyAcc Average
 	   
 frequencyBodyAccmeanY   (Numeric)
 	   - Average Subject-Activity measure Y-axis FrequencyBodyAcc Average
 	   
 frequencyBodyAccmeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis FrequencyBodyAcc Average
 	   
 frequencyBodyAccstandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-axis FrequencyBodyAcc Standard Deviation
 	   
 frequencyBodyAccstandarddeviationY   (Numeric)
 	   - Average Subject-Activity measure Y-axis FrequencyBodyAcc Standard Deviation
 	   
 frequencyBodyAccstandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis FrequencyBodyAcc Standard Deviation
 	   
 frequencyBodyAccJerkmeanX   (Numeric)
 	   - Average Subject-Activity measure  X-axis FrequencyBodyAccJerk Average
 	   
 frequencyBodyAccJerkmeanY   (Numeric)
 	   - Average Subject-Activity measure Y-axis FrequencyBodyAccJerk Average
 	   
 frequencyBodyAccJerkmeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis FrequencyBodyAccJerk Average
 	   
 frequencyBodyAccJerkstandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-axis FrequencyBodyAccJerk Standard Deviation
 	   
 frequencyBodyAccJerkstandarddeviationY   (Numeric)
 	   - Average Subject-Activity measure Y-axis FrequencyBodyAccJerk Standard Deviation
 	   
 frequencyBodyAccJerkstandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis FrequencyBodyAccJerk Standard Deviation
 	   
 frequencyBodyGyromeanX   (Numeric)
 	   - Average Subject-Activity measure X-axis FrequencyBodyGyro Average
 	   
 frequencyBodyGyromeanY   (Numeric)
 	   - Average Subject-Activity measure Y-axis FrequencyBodyGyro Average
 	   
 frequencyBodyGyromeanZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis FrequencyBodyGyro Average
 	   
 frequencyBodyGyrostandarddeviationX   (Numeric)
 	   - Average Subject-Activity measure X-axis FrequencyBodyGyro Standard Deviation
 	   
 frequencyBodyGyrostandarddeviationY   (Numeric)
 	   - Average Subject-Activity measure Y-axis FrequencyBodyGyro Standard Deviation
 	   
 frequencyBodyGyrostandarddeviationZ   (Numeric)
 	   - Average Subject-Activity measure Z-axis FrequencyBodyGyro Standard Deviation
 	   
 frequencyBodyAccMagmean   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyAccMag Average
 	   
 frequencyBodyAccMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyAccMag Standard Deviation
 	   
 frequencyBodyAccJerkMagmean   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyAccJerkMag Average
 	   
 frequencyBodyAccJerkMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measur FerequencyBodyAccJerkMag Standard Deviation
 	   
 frequencyBodyGyroMagmean   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyGyroMag Average
 	   
 frequencyBodyGyroMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyGyroMag Standard Deviation
 	   
 frequencyBodyGyroJerkMagmean   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyGyroJerkMag Average
 	   
 frequencyBodyGyroJerkMagstandarddeviation   (Numeric)
 	   - Average Subject-Activity measure FrequencyBodyGyroJerkMag Standard Deviation
 	   








