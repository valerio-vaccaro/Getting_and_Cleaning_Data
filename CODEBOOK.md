# "Getting and Cleaning Data" course project
Code Book

## Introduction
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data used in the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Original dataset
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

The original dataset contains:
+ `README.txt` Readme file
+ `features_info.txt` Contain information about the variables used on the feature vector
+ `features.txt` List of all features recorded (561 record for two columns: variable numbers and variable names), the name is composed in this way A-B-C (-C is optional) where:
    + A is one of the following:
        * tBodyAcc
        * tGravityAcc
        * tBodyAccJerk
        * tBodyGyro
        * tBodyGyroJerk
        * tBodyAccMag 
        * tGravityAccMag
        * tBodyAccJerkMag
        * tBodyGyroMag
        * tBodyGyroJerkMag
        * fBodyAcc-XYZ
        * fBodyAccJerk-XYZ
        * fBodyGyro-XYZ
        * fBodyAccMag
        * fBodyAccJerkMag
        * fBodyGyroMag
        * fBodyGyroJerkMag
    + B is the kind of elaboration:
        * mean() mean value
        * std() standard deviation
        * mad() median absolute deviation 
        * max() largest value in array
        * min() smallest value in array
        * sma() signal magnitude area
        * energy() energy measure. Sum of the squares divided by the number of values
        * iqr() interquartile range 
        * entropy() signal entropy
        * arCoeff() autorregresion coefficients with Burg order equal to 4
        * correlation() correlation coefficient between two signals
        * maxInds() index of the frequency component with largest magnitude
        * meanFreq() weighted average of the frequency components to obtain a mean frequency
        * skewness() skewness of the frequency domain signal 
        * kurtosis() kurtosis of the frequency domain signal 
        * bandsEnergy() energy of a frequency interval within the 64 bins of the FFT of each window
        * angle() angle between to vectors
    + C is the (optional) axis:
        * X
        * Y
        * Z
    + Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:
        * gravityMean
        * tBodyAccMean
        * tBodyAccJerkMean
        * tBodyGyroMean
+ `activity_labels.txt` - contains the connection between activity number and activity name (6 rows of 2 variables: number and name), the know activities are:
    * WALKING
    * WALKING_UPSTAIR
    * WALKING_DOWNSTAIR
    * SITTING
    * STANDING
    * LAYING
+ Observations:
    + `train/X_train.txt` observation from the training set (7352 observations of 561 variables)
    + `test/X_test.txt` observation from the test set (2947 observations of 561 variables)
+ Activities:
    + `train/y_train.txt` Activity label for the training set (activity name available with join with activity_labels.txt) (7352 observations of 1 variables)
    + `test/y_test.txt` Activity label for the test set (2947 observations of 1 variables)
+ Subjects:       
    + `train/subject_train.txt` The subject (range 1:30) who performed the activity for each window sample in train subset (7352 observations of 1 variables)
    + `test/subject_test.txt` The subject (range 1:30) who performed the activity for each window sample in test subset (2947 observations of 1 variables)
+ Raw datas:
    + `train/Inertial Signals/*` Raw training data set
    + `test/Inertial Signals/*` Raw test data set

## Analisys performed
1. Merges the training and the test sets to create one data set.
    - Merget record dataset:
        * Read variables in the train dataset from the file `./UCI HAR Dataset/train/X_train.txt` and save in the var `record_train` (7352x561)
        * Read variables in the test dataset from the file `./UCI HAR Dataset/test/X_test.txt` and save in the var `record_test` (2947x561)
        * Bind train and test set rows in a unique dataset called `record_complete` (10299x561)
    - Merge subject dataset:
        * Read subjects in the train dataset from the file `./UCI HAR Dataset/train/subjects_train.txt` and save in the var `subjects_train` (7352x1)
        * Read subjects in the test dataset from the file `./UCI HAR Dataset/test/subjects_test.txt` and save in the var `subjects_test` (2947x1)
        * Bind train and test set rows in a unique dataset called `subjects_complete` (10299x1)
        * Add the name "subject" to the column 
    - Merge activity dataset:
        * Read features in the train dataset from the file `./UCI HAR Dataset/train/y_train.txt` and save in the var `features_train` (7352x1)
        * Read features in the test dataset from the file `./UCI HAR Dataset/test/y_test.txt` and save in the var `features_test` (2947x1)
        * Bind train and test set rows in a unique dataset called `features_complete` (10299x1)
        * Add the name "features" to the column 
    - Paste all together in a unique dataset (10299x563) called `data_complete`, first column will contain subjects, second will contain activities and others columns will be the same like in record_complete dataset
2. Extracts only the measurements on the mean and standard deviation for each measurement.
It's means reduce the column deleting all the collumns dont contain mean or standard deviation in name, unfortunately column name in contained in another file (`features.txt`) so we can procede as follow:
    - Read column name from the file `./UCI HAR Dataset/features.txt` and store in the variable `col_names` (561x2)
    - Create a flags array with TRUE if the name contain "-mean()" or "-std()" substrings and save on `col_flags` (561x1)
    - Add TRUE, TRUE on top of array for maintain subject and activity columns and save on `flags` array (563x1)
    - Filter columns on `data_complete` based on `flags` calculated and store result on `filtered_data` (10299 observations for 68 variables, 66 variables with mean/std + subject column + activity column)
3. Uses descriptive activity names to name the activities in the data set.
Labels are stored in another file (`./UCI HAR Dataset/activity_labels.txt`) so we can procede in this way:
    - Read activity labels from the file `activity_labels.txt` and store in on `activities` variable (6x2)
    - Convert first column of `filtered_data` to factors
    - Covert second column of `filtered_data` to factors with defined labels taken from second column of `activities` variable
4. Appropriately labels the data set with descriptive variable names. 
    - Filter column names based on `flags` and store on `names` variable (66x1)
    - Updates column data names using "subject" and "activity" for first and second columns, for other columns use labels stored on `names` array
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    - Order `filtered_data` using activity and subject columns (remember they are factors) and update `filtered data` (10299x68, same size like before)
    - Aggregate all columns (3:end) using the groups on columns 1:2 with the function mean (it compute the mean of aggregated rows) and store on `result_data` variable (180 observations for 68 variables)
    -Saving result in the local file `result_data.txt`

## Results
The result object called `result_data` contain 180 rows, for each of the 30 diffent subjects (1:30) there are 6 different records one for each activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
Each row cointains 68 variable:
    1. subject                     
    2. activity                  
    3. tBodyAcc-mean()-X
    4. tBodyAcc-mean()-Y
    5. tBodyAcc-mean()-Z
    6. tBodyAcc-std()-X       
    7. tBodyAcc-std()-Y
    8. tBodyAcc-std()-Z
    9. tGravityAcc-mean()-X     
    10. tGravityAcc-mean()-Y        
    11. tGravityAcc-mean()-Z
    12. tGravityAcc-std()-X        
    13] tGravityAcc-std()-Y
    14. tGravityAcc-std()-Z
    15. tBodyAccJerk-mean()-X     
    16. tBodyAccJerk-mean()-Y
    17. tBodyAccJerk-mean()-Z
    18. tBodyAccJerk-std()-X       
    19. tBodyAccJerk-std()-Y
    20. tBodyAccJerk-std()-Z
    21. tBodyGyro-mean()-X        
    22. tBodyGyro-mean()-Y
    23. tBodyGyro-mean()-Z
    24. tBodyGyro-std()-X          
    25. tBodyGyro-std()-Y
    26. tBodyGyro-std()-Z
    27. tBodyGyroJerk-mean()-X
    28. tBodyGyroJerk-mean()-Y
    29. tBodyGyroJerk-mean()-Z
    30. tBodyGyroJerk-std()-X      
    31. tBodyGyroJerk-std()-Y
    32. tBodyGyroJerk-std()-Z
    33. tBodyAccMag-mean()       
    34. tBodyAccMag-std()
    35. tGravityAccMag-mean()
    36. tGravityAccMag-std()       
    37. tBodyAccJerkMag-mean()
    38. tBodyAccJerkMag-std()
    39. tBodyGyroMag-mean()       
    40. tBodyGyroMag-std()
    41. tBodyGyroJerkMag-mean()    
    42. tBodyGyroJerkMag-std()     
    43. fBodyAcc-mean()-X
    44. fBodyAcc-mean()-Y
    45. fBodyAcc-mean()-Z          
    46. fBodyAcc-std()-X
    47. fBodyAcc-std()-Y
    48. fBodyAcc-std()-Z           
    49. fBodyAccJerk-mean()-X
    50. fBodyAccJerk-mean()-Y
    51. fBodyAccJerk-mean()-Z      
    52. fBodyAccJerk-std()-X
    53. fBodyAccJerk-std()-Y
    54. fBodyAccJerk-std()-Z       
    55. fBodyGyro-mean()-X
    56. fBodyGyro-mean()-Y
    57. fBodyGyro-mean()-Z  
    58. fBodyGyro-std()-X
    59. fBodyGyro-std()-Y
    60. fBodyGyro-std()-Z          
    61. fBodyAccMag-mean()
    62. fBodyAccMag-std()
    63. fBodyBodyAccJerkMag-mean() 
    64. fBodyBodyAccJerkMag-std()
    65. fBodyBodyGyroMag-mean()
    66. fBodyBodyGyroMag-std()     
    67. fBodyBodyGyroJerkMag-mean()
    68. fBodyBodyGyroJerkMag-std()
For each combination of subject and activity (different rows) the columns 3:68 store the mean value for the variable idientified from the column name.
 
The variable `filtered_data` contain the same rows and all the observation (10299) recorded in the original dataset before appy the mean function.

