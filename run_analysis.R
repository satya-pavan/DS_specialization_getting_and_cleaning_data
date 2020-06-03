########################################################################################################################################
# This script does the following for the smart watch dataset available here - 
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# 1. Merges the training and the test sets to create one data set
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
########################################################################################################################################


setwd("C:/Users/Satya/Desktop/R Learning/Material - Data Science Specialization/3. Getting & Cleaning Data/Assignment/UCI HAR Dataset/")

#Load test data into the dataframe - test_df
test_df <- read.table("test/X_test.txt", header = FALSE,sep="")

#Load train data into the dataframe - train_df
train_df <- read.table("train/X_train.txt", header = FALSE, sep="")

#Combine train data and test data to create a dataframe that contains both
total_df <- rbind(test_df,train_df)


#Load features data into the dataframe - features
features = read.table("features.txt")

#Getting the list of columns that contain mean or std in them
features_with_mean_std <- features[grep("mean|std", features[,2]), ]


#Filtering out the total_df to retain only the columns with mean or std in their names
total_df <- total_df[,unlist(features_with_mean_std["V1"])]


#Removing/cleaning out the column names that have junk characters - [,(,),-
clean_col_names = gsub("[()-]","",features_with_mean_std[,2])
colnames(total_df) <- clean_col_names


#Load activity test data into the dataframe - activity_test_df
activity_test_df <- read.table("test/y_test.txt", header = FALSE,sep="")

#Load activity train data into the dataframe - activity_train_df
activity_train_df <- read.table("train/y_train.txt", header = FALSE, sep="")

#Combine activity train and test data to create a dataframe that contains both
total_activity_data <- rbind(activity_test_df,activity_train_df)

#Load activity label info into the dataframe - activity_labels
activity_labels <- read.table("activity_labels.txt", header = FALSE, sep="")

#Create a dataset that contains descriptive labels instead of numbers
activity <- activity_labels[match(total_activity_data[,1],activity_labels[,1]),2]


#Load subject test data into the dataframe - subj_test_df
subj_test_df <- read.table("test/subject_test.txt", header = FALSE,sep="")

#Load subject train data into the dataframe - subj_train_df
subj_train_df <- read.table("train/subject_train.txt", header = FALSE, sep="")

#Combine subject train and test data to create a dataframe that contains both
subject <- rbind(subj_test_df,subj_train_df)


#Combining subject and activity data to the total dataframe column wise
total_df <- cbind(subject,activity,total_df)

#Appropriately naming the first column
names(total_df)[names(total_df) == "V1"] <- "subject"

#Finding the mean of the total dataframe for each variable grouped by subject & activity
mean_per_subject_activity <- aggregate(total_df[, 3:81], list(total_df$subject,total_df$activity), mean)
View(mean_per_subject_activity)
