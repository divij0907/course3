#getting activity names
library("data.table")
activity_labels<-fread("./UCI HAR Dataset/activity_labels.txt",col.names = c("classLabels", "activityName"))

#extracting only std deviation and mean features
features<-fread("./UCI HAR Dataset/features.txt",col.names = c("index", "featureNames"))
featuresWanted<-grep("(mean|std)\\(\\)",features[,featureNames])
measurements <- features[featuresWanted, featureNames]
#remove () from the names
measurements<- gsub('[()]', '', measurements)

#getting training data
x_train<-fread("./UCI HAR Dataset/train/X_train.txt")[, featuresWanted,with=FALSE]
colnames(x_train)<-measurements
trainActivities <- fread("./UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))
trainSubjects <- fread("./UCI HAR Dataset/train/subject_train.txt", col.names = c("SubjectNum"))
trainfinal<-cbind(x_train,trainActivities,trainSubjects)


#getting test data
x_test<-fread("./UCI HAR Dataset/test/X_test.txt")[, featuresWanted,with=FALSE]
colnames(x_test)<-measurements
testActivities <- fread("./UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
testSubjects <- fread("./UCI HAR Dataset/test/subject_test.txt", col.names = c("SubjectNum"))
testfinal<-cbind(x_test,testActivities,testSubjects)

merged=rbind(trainfinal,testfinal)
#change class label to activity name
merged[["Activity"]] <- factor(merged[, Activity]
                                 , levels = activity_labels[["classLabels"]]
                                 , labels = activity_labels[["activityName"]])


merged[["SubjectNum"]] <- as.factor(merged[, SubjectNum])
merged <-melt(data = merged, id = c("SubjectNum", "Activity"))
merged <- dcast(data = merged, SubjectNum + Activity ~ variable, fun.aggregate = mean)



