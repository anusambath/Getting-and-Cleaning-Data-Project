## Getting and Cleaning Data Project

Author: Anu Sambath

## Source of Data
The source data and a full description is available at 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Steps Taken to Clean the Data

# 1. Download the Dataset File from Source
   - Download the zip file to current working directory
   - Unzip the files. This unzips to a folder called "UCI HAR Dataset"
   
# 2. Read Activity Lables
activity_labels.txt has the mapping of activity code used in data files to the activity lable. Use factor function to replace the activity code with label in the process of tidying.

# 3. Read Features Datasets
features.txt list the 561 features measured. Extract only interested in mean and std measurements. Search for "mean|std" using grep function to determine the column numbers in test and training data to retain. Use this datasets to build the list of column names to apply to the datasets.

# 4. Read Training Datasets 
Read X_train.txt, y_train.txt and subject_train.txt from "UCI HAR Dataset\train"
Bind the three datasets by column

# 5. Read Test Datasets
Read X_test.txt, y_test.txt and subject_test.txt from "UCI HAR Dataset\test"
Bind the three datasets by column

# 6. Merge Training and Test Datasets
Merge Traing and Test datasets using row binding and apply the column labels.

# 7. Create a Dataset with Average of Each Variable
  - Gather the the merged dataset to obtain a skinny table. 
  - Group the merged data set by SubjectNum, Activity and Variable. 
  - Summerize to obtain the mean. 
  - Spread the dataset back to its original wide format.
 
## Tidy Data
Name of the Dataset is tidyData. The following are the columns:
 - SubjectNum - An identifier of the subject who carried out the experiment
 - Activity - Activity Label
 - 66 columns of different measurements taken during the experiment (the values in the columns represtnt the mean of all the values for the subject-activity-measurement combination from the raw data)
 tidyData contains 180 rows (30 subjects x 6 activities ) and 68 columns. 

