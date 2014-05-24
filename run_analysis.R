# DESCRIPTION:
# 
# Script for preparing data for Wearables project using UCI HAR dataset
# See: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Requires data to be downloaded and unzipped into working directory.
#
# Acknowledgments:
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
# R global community contributions

# Load libraries 
library(dplyr)
library(plyr)

# 1. Merge the training and the test sets to create one data set.
# Load Feature labels
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c("Features")
# Load Activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("ID", "Activity")

# Load Test Data
message("Loading Test Data...")
# Features
xTest <- read.table(file="UCI HAR Dataset/test/X_test.txt")
names(xTest) <- features[,2]
# Activity
yTest <- read.table(file="UCI HAR Dataset/test/y_test.txt")
names(yTest) <- c("Activity")
# Subject 
subjectTest <- read.table(file="UCI HAR Dataset/test/subject_test.txt")
names(subjectTest) <- c("Subject")
# Combine 
testData <- cbind(subjectTest, yTest, xTest)

# Load Train Data
message("Loading Train Data...")
# Features
xTrain <- read.table(file="UCI HAR Dataset/train/X_train.txt")
names(xTrain) <- features[,2]
# Activity
yTrain <- read.table(file="UCI HAR Dataset/train/y_train.txt")
names(yTrain) <- c("Activity")
# Subject
subjectTrain <- read.table(file="UCI HAR Dataset/train/subject_train.txt")
names(subjectTrain) <- c("Subject")
# Combine 
trainData <- cbind(subjectTrain, yTrain, xTrain)

# Finally, merge test and train data
message("Merging Test and Train Data...")
allData <- rbind(testData, trainData)
message("Created Merged Data Set")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanStdDev <- dplyr::select(allData, Subject, Activity, ends_with("-mean()"), ends_with("-std()"))
message("Extracted Mean and Standard Dev Columns")

# 3. Uses descriptive activity names to name the activities in the data set
meanStdDev <- plyr::mutate(meanStdDev, Activity=activities$Activity[Activity])
message("Renamed Activity IDs with Labels")

# 4. Appropriately label the data set with descriptive names
# substitute column names ending in -mean() and -std() with Mean and Std
names(meanStdDev) <- sub("-mean\\(\\)", "Mean", names(meanStdDev))
names(meanStdDev) <- sub("-std\\(\\)", "Std", names(meanStdDev))
message("Renamed -mean() and -std() columns as Mean and Std respectively")

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
agMeanBySubAct <- aggregate(meanStdDev[3:20], list(meanStdDev$Subject,meanStdDev$Activity), mean)
names(agMeanBySubAct)[1:2] <- c("Subject","Activity")
message("Aggregate Mean by Subject and Activity calculated")

# Display tidy data set
View(agMeanBySubAct)