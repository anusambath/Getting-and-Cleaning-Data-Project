#### Housekeeping
#setwd("C:\\Anu\\Data Science\\Coursera - Data Science by JHU\\000-Code\\03-Getting and Cleaning Data\\week4")
library(data.table)
library(dplyr)
library(tidyr)
#curdir = getwd()


 
# 
# You should create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Getting and Cleaning Data - Course Project
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "datafiles.zip")
unzip(zipfile = "datafiles.zip")

## Load activity labels
tbl_ActivityLabels <- tbl_df(read.table("UCI HAR Dataset\\activity_labels.txt", col.name= c("id", 'activity_name')))

## Load features/measurements
allfeatures <- tbl_df(read.table("UCI HAR Dataset\\features.txt", 
                              col.name= c("id", 'feature_name')))
colNumbersToKeep <- grep("(mean|std)\\(\\)", allfeatures$feature_name )
measurementsToKeep <- filter(allfeatures, id %in% colNumbersToKeep )
measurementsToKeep <- mutate (measurementsToKeep, feature_name = gsub("[()]", "", feature_name))$feature_name  

## Load Training datasets
tbl_training  <-tbl_df(fread("UCI HAR Dataset/train/X_train.txt")[, colNumbersToKeep, with = FALSE])
tbl_trainingActivities <- tbl_df(fread("UCI HAR Dataset/train/Y_train.txt"))
tbl_trainingSubjects <- tbl_df(fread("UCI HAR Dataset/train/subject_train.txt"))
tbl_training <- cbind(tbl_trainingSubjects, tbl_trainingActivities, tbl_training)

colnames(tbl_training) <-
    c( "SubjectNum", "Activity" ,measurementsToKeep)

## Load Test datasets
tbl_test  <-
    tbl_df(fread("UCI HAR Dataset/test/X_test.txt")[, colNumbersToKeep, with = FALSE])
tbl_testActivities <- tbl_df(fread("UCI HAR Dataset/test/Y_test.txt"))
tbl_testSubjects <- tbl_df(fread( "UCI HAR Dataset/test/subject_test.txt" ))
tbl_test <- cbind(tbl_testSubjects, tbl_testActivities, tbl_test) 
colnames(tbl_test) <- c( "SubjectNum", "Activity" , measurementsToKeep)

#Merge Test and Train
tbl_Merged <- rbind(tbl_training, tbl_test)

#Convert Activity ids to descriptive activity names
tbl_Merged <- mutate(tbl_Merged, Activity = factor(Activity, levels = tbl_ActivityLabels$id, labels = tbl_ActivityLabels$activity_name))

#Make Subject Number a factor so we can group by it
tbl_Merged <- mutate(tbl_Merged , SubjectNum = as.factor(SubjectNum))

# Gather the the merged dataset to obtain a skinny table. 
# Group the merged data set by SubjectNum, Activity and Variable. 
# Summerize to obtain the mean. 
# Spread the dataset back to its original wide format.
tbl_tidy <-
            tbl_Merged  %>%
            gather(key = "Variable", value = "Value", measurementsToKeep) %>%
            group_by(SubjectNum, Activity, Variable) %>%
            summarize(Aggregate = mean(Value)) %>%
            spread(key = "Variable", value = "Aggregate", fill = NA)

# Wite the tidy data as txt file without rownumbers
fwrite(tbl_tidy, file="tidyData.csv", quote=FALSE)
write.table(tbl_tidy ,file="tidyData.txt", quote=FALSE, row.names = FALSE )
