## run_analysis.R

run_analysis <- function() {
    ## Read outcome data
    library(reshape2)
    library(plyr)
    message("sss")
    features_list <- read.table("./UCI HAR Dataset/features.txt",sep = "")
    col_names<-features_list[,2]
    
    x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",sep = "",col.names=col_names)
    ##head(x_test,3)
    x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",sep = "",col.names=col_names)
    y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt",sep = "",col.names=c("activity_id"))
    y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt",sep = "",col.names=c("activity_id"))
    test_comb <- cbind(x_test,y_test)
    train_comb <- cbind(x_train,y_train)
    sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",sep = "",col.names=c("volunteer_id"))
    sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",sep = "",col.names=c("volunteer_id"))
    test_comb <- cbind(test_comb,sub_test)
    train_comb <- cbind(train_comb,sub_train)
    x_merged <- merge(test_comb,train_comb,all=TRUE)
    ##vars <- c("V1","V2","V3","V4","V5","V6","V41","V42","V43","V44","V45","V46","V81","V82","V83","V84","V85","V86","V121","V122","V123","V124","V125","V126","V161","V162","V163","V164","V165","V166","V201","V202","V214","V215","V227","V228","V240","V241","V253","V254","V266","V267","V268","V269","V270","V271","V345","V346","V347","V348","V349","V350","V424","V425","V426","V427","V428","V429","V503","V504","V516","V517","V529","V530","V542","V543","activity_id","volunteer_id" )
    srch <- c("mean\\.","std\\.","activity_id","volunteer_id")
    mod_col_names <- names(x_merged)
    res<-grepl(paste(srch,collapse="|"),mod_col_names)
    vars <- mod_col_names[res]
    x_extracted <- x_merged[,vars]
    ncol(x_extracted)
    x_extracted$activity_label[x_extracted$activity_id == 1]<-"WALKING"
    x_extracted$activity_label[x_extracted$activity_id == 2]<-"WALKING_UPSTAIRS"
    x_extracted$activity_label[x_extracted$activity_id == 3]<-"WALKING_DOWNSTAIRS"
    x_extracted$activity_label[x_extracted$activity_id == 4]<-"SITTING"
    x_extracted$activity_label[x_extracted$activity_id == 5]<-"STANDING"
    x_extracted$activity_label[x_extracted$activity_id == 6]<-"LAYING"

    a0 <- melt(x_extracted,id=c("volunteer_id","activity_label","activity_id"))
    a1<- ddply(a0,.(volunteer_id,activity_label,variable),summarize,mean=mean(value))
    a3 <- dcast(a1,volunteer_id + activity_label ~ variable,value.var="mean")
    
    a3
}