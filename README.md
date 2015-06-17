# Getting-and-Cleaning-Data-peer-assignment
Repo for Getting and Cleaning Data coursera course peer assignment

This repo contains the following:-
1. run_analysis.R the main R script
2. The tidy data set output
3. The CodeBook.md
4. And this README

The R script main purpose is to do the following:-

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

First steps is to load the test and train file contents into the respective data frames
The following three files needs to be combine
X_test.txt
Y_train.txt
subject_test.txt

Then create a combined data frame by cbinding the entries from train and subject files. This introduces two new columns - activity id and volunteer id

Now pick only those colums which matches to mean to std and extract them into a different data frame

Once this is done, next step to calculate average of each variable for each volunteer for each activity and store in a a new tidy data set.

The coding is done taking into consideration the format of the input files. Any change in the format of the files may require changes in the script

