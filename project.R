# reading raw data
test_data=read.table("./UCI HAR Dataset/test/X_test.txt")
training_data=read.table("./UCI HAR Dataset/train/X_train.txt")
features=read.table("./UCI HAR Dataset/features.txt")
test_labels=read.table("./UCI HAR Dataset/test/y_test.txt")
training_labels=read.table("./UCI HAR Dataset/train/y_train.txt")
test_subjects=read.table("./UCI HAR Dataset/test/subject_test.txt")
training_subjects=read.table("./UCI HAR Dataset/train/subject_train.txt")

# merging data sets
total_data=rbind(test_data, training_data)
total_labels=rbind(test_labels, training_labels)
total_subjects=rbind(test_subjects, training_subjects)
colnames(total_subjects)<-"subject_num"
colnames(total_labels)<-"activity_num"

library("dplyr")
mean_or_standard<-filter(features,(grepl("-mean()",features[,2],fixed = TRUE)|grepl("-std()",features[,2],fixed = TRUE)))

#filtrovani totaldata tak, aby to obsahovalo jen sloupce s mean nebo std
totalData_mean_orstd<-total_data[,mean_or_standard[,1]]

# adding column names
colnames(totalData_mean_orstd)<-mean_or_standard[,2]

# creating proper activity names:

# replacing number by string

activity_labels<-total_labels[,1]

activity_labels[activity_labels==1]<-"WALKING"
activity_labels[activity_labels==2]<-"WALKING_UPSTAIRS"
activity_labels[activity_labels==3]<-"WALKING_DOWNSTAIRS"
activity_labels[activity_labels==4]<-"SITTING"
activity_labels[activity_labels==5]<-"STANDING"
activity_labels[activity_labels==6]<-"LAYING"

total_data_tidy=cbind(activity_labels,total_subjects,totalData_mean_orstd)

# funguje, ale ne dokonale. Rozsirit na vsechny sloupce
byActivity<- total_data_tidy %>% group_by(activity_labels, subject_num)%>%summarise_each(funs(mean))

write.table(byActivity, file="activity_averages.txt", row.names=FALSE)
