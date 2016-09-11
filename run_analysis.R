# Load required libraries
library(dplyr)
library(reshape2)

# Read training data
trainingDS       <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
trainingLabels   <- read.table(file = "UCI HAR Dataset/train/y_train.txt")
trainingSubjects <- read.table(file = "UCI HAR Dataset/train/subject_train.txt")

#Read test data
testDS       <- read.table(file = "UCI HAR Dataset/test/X_test.txt")
testLabels   <- read.table(file = "UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table(file = "UCI HAR Dataset/test/subject_test.txt")

# Read column names and activity labels
features   <- read.table(file = "UCI HAR Dataset/features.txt", sep = "\r")
activities <- read.table(file = "UCI HAR Dataset/activity_labels.txt")

# 1. Merge the training and test datasets to create one dataset.
mergedDS <- rbind(trainingDS, testDS)

# 2. Extract only measurements on the mean and standard deviation of each measurement.
colnames(mergedDS) <- features$V1
mean_std_measurements <- select(mergedDS, matches("mean\\(\\)|std\\(\\)"))

# 3. Use descriptive activity names to name the activities in the data set
mergedLabels <- rbind(trainingLabels, testLabels)
mergedLabels <- mutate(mergedLabels, activityNames = activities$V2[V1])

# 4. Appropriately label the data set with descriptive variable names.
mergedSubjects <- rbind(trainingSubjects, testSubjects)
mean_std_measurements <- cbind(mean_std_measurements, Activity = mergedLabels$activityNames, 
                               Subject = mergedSubjects$V1)

# 5. creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject.
mean_std_measurements_melted <- melt(mean_std_measurements, id = c("Activity", "Subject"))
tidyDataSet <- dcast(mean_std_measurements_melted, Activity + Subject ~ variable, mean)

# Save result in CSV format
write.csv(tidyDataSet, "tidy_activity_recognition_data_set.csv")