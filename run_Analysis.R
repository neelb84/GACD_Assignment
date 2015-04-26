
#Moved all the required datasets to the working directory
# Working Directory now includes all the train and test datasets, subject and activity datasets

#Read train and test accelerometers data 
train<-read.table("X_train.txt")
test<-read.table("X_test.txt")

#Read train and test labels data 
train_labels<-read.table("y_train.txt")
test_labels<-read.table("y_test.txt")

#Read features data and just the features name
features<-read.table("features.txt")
features2<-features[,2]

#Naming the variables using the features data
names(train)<-features2

#Pull the training subjects data and name the variables properly
train_subjects<-read.table("subject_train.txt")
names(train_subjects)<-"Subjects"
names(train_labels)<-"Activity"

#First version of training data created with all required variables
train.v1<-cbind(train_subjects,train_labels,train)
dim(train.v1)           #[1] 7352  563


#Similar steps for the test data done
test_subjects<-read.table("subject_test.txt")
names(test_subjects)<-"Subjects"
names(test_labels)<-"Activity"
names(test)<-features2
test.v1<-cbind(test_subjects,test_labels,test)
dim(test.v1)                     #[1] 2947  563


#First version of training +testing data created

##First step of the assignment complete

all_data<-rbind(train.v1,test.v1)


#Using grep to select the columns which have mean or std

##Second step of the assignment complete

all_data.v2<-all_data[,c(1,2,grep("mean|std",tolower(names(all_data))))]


#Reading the activity labels
activitylabels<-read.table("activity_labels.txt")

# Merged descriptive activity names to name the activities in the data set - activitynames

##Step3 of assignment complete
names(activitylabels)<-c("Activity","activitynames")
all_data.v3<-merge(x = all_data.v2, y = activitylabels, by = "Activity", all.x=TRUE)


#Initializing the reshape2 library to use melt function to create long tidy data

#Melting the data to create 4 columns subjects, activitynames, features, measurements
#Features were the mean and std variables which are melted into rows using melt function
library(reshape2)
all_data.v4<-melt(all_data.v3,id=c("Subjects","activitynames"),measure.vars=c(names(all_data.v3[,3:(ncol(all_data.v3)-1)])))

#Appropriately labeling the variables

##Step 4 of assignment complete

names(all_data.v4)<-c("subjects","activitynames","features","measurements")

#Optional step just ordering to see how it is
all_data.v5<-all_data.v4[order(all_data.v4$subjects,all_data.v4$activitynames,all_data.v4$features),]

#initialize plyr library to use ddply for the data summary
library(plyr)

#Final tidy LONG form of data created

##Tidy  long data set with the average of each feature for each activity and each subject

accelerometer_tidydata<-ddply(all_data.v5, names(all_data.v5)[1:3], summarize, average=mean(measurements))

##Writing table for submission
write.table(accelerometer_tidydata, "./accelerometer_tidydata1.txt", sep="\t",row.name=FALSE)
