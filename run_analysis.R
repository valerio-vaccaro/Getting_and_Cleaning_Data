# Getting_and_Cleaning_Data: project 
# 
# The purpose of this project is to demonstrate your ability to collect, work
# with, and clean a data set. The goal is to prepare tidy data that can be used
# for later analysis. You will be graded by your peers on a series of yes/no
# questions related to the project. You will be required to submit: 1) a tidy
# data set as described below, 2) a link to a Github repository with your script
# for performing the analysis, and 3) a code book that describes the variables,
# the data, and any transformations or work that you performed to clean up the
# data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are
# connected.
# 
# One of the most exciting areas in all of data science right now is wearable
# computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new
# users. The data linked to from the course website represent data collected
# from the accelerometers from the Samsung Galaxy S smartphone. A full
# description is available at the site where the data was obtained: 
#
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Here are the data for the project: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Merges the training and the test sets to create one data set.
# 1.a. Read variables in the train dataset
record_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
# 1.b. Read variables in the test dataset
record_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
# 1.c. Bind train and test set rows 
record_complete <- rbind(record_train, record_test)
# 1.d. Free memory
rm(record_train)
rm(record_test)

# 1.e. Read subjects in the train dataset
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
# 1.f. Read subjects in the test dataset
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
# 1.g. Bind train and test set rows 
subject_complete <- rbind(subject_train, subject_test)
names(subject_complete) <- c("subject")
# 1.h. Free memory
rm(subject_train)
rm(subject_test)

# 1.i. Read features in the train dataset
feature_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
# 1.l. Read features in the test dataset
feature_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
# 1.m. Bind train and test set rows 
feature_complete <- rbind(feature_train, feature_test)
names(feature_complete) <- c("feature")
# 1.n. Free memory
rm(feature_test)
rm(feature_train)
# So acturally I have three datasets:
# * record_complete 10299x561
# * subject_complete 10299x1
# * feature_complete 10299x1
# 1.o. Paste all together in a unique  dataset 10299x563 
data_complete <- cbind(subject_complete,feature_complete,record_complete)
# 1.p. Free memory
rm(subject_complete)
rm(feature_complete)
rm(record_complete)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# It's means reduce the column deleting all the collumns dont contain mean or standard deviation in name,
# unfortunately column name in contained in another file (features.txt)
# 2.a. Read column name from the file features.txt (561x2)
col_names <- read.table("./UCI HAR Dataset/features.txt")
# 2.b. Flags for filter for columns with mean "-mean()" or standard "-std()" deviation values
col_flags <- regexpr("-mean\\(\\)|-std\\(\\)", col_names[, 2]) != -1
# 2.d. Add two first columns 
flags <- c(TRUE,TRUE,col_flags)
# 2.e. Filter columns on data_complete based on flags - actually return 10299 observations for 68 variables
filtered_data <- data_complete[ ,flags] 
# 2.f. Free memory
rm(flags)
rm(data_complete)

# 3. Uses descriptive activity names to name the activities in the data set.
# 3.a. Read activity labels from the file activity_labels.txt - 6x2
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
# 3.b. Convert first column to factors
filtered_data[,1]<-factor(filtered_data[,1])
# 3.c. Covert second column to factors with defined labels
filtered_data[,2]<-factor(filtered_data[,2], labels=activities[,2])
# 3.d. Free memory
rm(activities)

# 4. Appropriately labels the data set with descriptive variable names. 
# 4.a. Filter column names based on flags (remember to add subject and activity on first and second columns)
names <- col_names[col_flags,2]
# 4.b. Updates column data names
names(filtered_data) <- c("subject","activity", as.character(names) )
# 4.c. Free memory
rm(names)
rm(col_names)
rm(col_flags)
# 4.d. Intermediate export
write.table(filtered_data,"filtered_data.txt",row.name=FALSE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable f
# for each activity and each subject.
# 5.a. Order filtered_data using activity and subject columns (remember they are factors)
filtered_data <- filtered_data[order(filtered_data$activity,filtered_data$subject),]
# 5.b. Aggregare all columns (3:end) using the groups on columns 1:2 with the function mean (it compute the 
# mean of aggregated rows)
result_data <- aggregate(filtered_data[,3:ncol(filtered_data)],by=filtered_data[,1:2],FUN=mean)
# 5.c. Saving result in the local file result_data.txt
write.table(result_data,"result_data.txt",row.name=FALSE)