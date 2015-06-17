## run_analysis.R
##
# run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.


run_analysis <- function() {
    ## Load libraries reshape2 for melt and plyr for ddply
    library(reshape2)
    library(plyr)
    
    ## First read the features list and retrieve the column  names
    features_list <- read.table("./UCI HAR Dataset/features.txt",sep = "")
    col_names<-features_list[,2]
    
    ## Then read x and y values from the test and train files
    x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",sep = "",col.names=col_names)
    x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",sep = "",col.names=col_names)
    
    y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt",sep = "",col.names=c("activity_id"))
    y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt",sep = "",col.names=c("activity_id"))
    
    ## Now bind the x and y values using cbine
    test_comb <- cbind(x_test,y_test)
    train_comb <- cbind(x_train,y_train)
    
    ## Now read the volunteer id from the subject files
    sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",sep = "",col.names=c("volunteer_id"))
    sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",sep = "",col.names=c("volunteer_id"))
    
    ## Now bind them to the test and train combine data frames
    test_comb <- cbind(test_comb,sub_test)
    train_comb <- cbind(train_comb,sub_train)
    
    ## Now to the all important step of merging both of the train and test dataframes
    x_merged <- merge(test_comb,train_comb,all=TRUE)
    
    ### Now to step 2 to retrieve only mean and std columns from the merged data frame
    ### Since we added activity id and volunteer id as well while cbinding, adding that as well 
    srch <- c("mean\\.","std\\.","activity_id","volunteer_id")
    
    ## Get the modified column names from the merged data frame
    mod_col_names <- names(x_merged)
    
    ### Now retrieve using grepl function which returns a logical vector
    res<-grepl(paste(srch,collapse="|"),mod_col_names)
    
    ### From the modified column names vector get only those which match
    vars <- mod_col_names[res]
    x_extracted <- x_merged[,vars]
    ##ncol(x_extracted)
    
    ## Now to the next step to introduce a new column of equating activity id to activity label
    #x_extracted$activity_label[x_extracted$activity_id == 1]<-"WALKING"
    #x_extracted$activity_label[x_extracted$activity_id == 2]<-"WALKING_UPSTAIRS"
    #x_extracted$activity_label[x_extracted$activity_id == 3]<-"WALKING_DOWNSTAIRS"
    #x_extracted$activity_label[x_extracted$activity_id == 4]<-"SITTING"
    #x_extracted$activity_label[x_extracted$activity_id == 5]<-"STANDING"
    #x_extracted$activity_label[x_extracted$activity_id == 6]<-"LAYING"
    
    ### Reading the lables from activity_labels file and loading to labels data frame
    ### And adding a new col lable and equating with the activity id
    labels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c("id","label"))
    x_extracted$activity_label[x_extracted$activity_id == 1]<-as.character(labels[1,2])
    x_extracted$activity_label[x_extracted$activity_id == 2]<-as.character(labels[2,2])
    x_extracted$activity_label[x_extracted$activity_id == 3]<-as.character(labels[3,2])
    x_extracted$activity_label[x_extracted$activity_id == 4]<-as.character(labels[4,2])
    x_extracted$activity_label[x_extracted$activity_id == 5]<-as.character(labels[5,2])
    x_extracted$activity_label[x_extracted$activity_id == 6]<-as.character(labels[6,2])
    
    ### Now to the final part of computing average of each activity for each volunteer for each variable
    ### This is done by using melt function from reshape2 package and ddply from plyr package
    ### First melt to include the three required columns 
    ### Then to use ddply to summarize and get average of each variable for volunteer id and activity combination
    ### Lastly casting them into single row for one volunteer id and one activity combo, resulting in 180 rows
    a0 <- melt(x_extracted,id=c("volunteer_id","activity_label","activity_id"))
    a1<- ddply(a0,.(volunteer_id,activity_label,variable),summarize,mean=mean(value))
    a3 <- dcast(a1,volunteer_id + activity_label ~ variable,value.var="mean")
    
    ### Now return a3 the tidy data set
    a3
}