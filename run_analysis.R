## You should create one R script called run_analysis.R that does the following.
## 	1	Merges the training and the test sets to create one data set.
##	2	Extracts only the measurements on the mean and standard deviation for each measurement.
##	3	Uses descriptive activity names to name the activities in the data set
##	4	Appropriately labels the data set with descriptive variable names.
##	5	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## Good luck!

#########

# Make sure the current directory is in folder "UCI HAR Dataset"
dir()

# Expected result below
#[1] "README.txt"          "activity_labels.txt" "features.txt"       
#[4] "features_info.txt"   "test"                "train"  

# Otherwise, set directory using setwd() command.

# read activity labels, feature labels
act <- read.table("activity_labels.txt",header=FALSE)
feat <- read.table("features.txt", header=FALSE)

# read training dataset
xtrain <- read.table("train/X_train.txt",header=FALSE)
subjecttrain <- read.table("train/subject_train.txt",header=FALSE)
ytrain <- read.table("train/y_train.txt",header=FALSE)

# read testing dataset
xtest <- read.table("test/X_test.txt",header=FALSE)
subjecttest <- read.table("test/subject_test.txt",header=FALSE)
ytest <- read.table("test/y_test.txt",header=FALSE)

# Give descriptive variable names to both datasets
names(xtrain) <- feat[,2]
names(subjecttrain) <- "subjectid"
names(ytrain) <- "activityid"
names(xtest) <- feat[,2]
names(subjecttest) <- "subjectid"
names(ytest) <- "activityid"

# combine columns on training and testing data
trainset <- cbind(subjecttrain,ytrain,xtrain)
testset <- cbind(subjecttest,ytest,xtest)

# merge 2 sets together
alldata <- rbind(trainset,testset)

# Extract only the measurements on the mean and standard deviation for each measurement.
data <- alldata[,grepl("subjectid|activityid|[Mm]ean|[Ss]td",names(alldata))]

# Use descriptive activity names to name the activities in the data set
names(act) <- c("activityid","activitylabel")
data <- merge(data,act)

# creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
id <- c(names(data)[1:2],names(data)[89])
labels <- setdiff(names(data),id)
meltdata <- melt(data,id=id,measure.vars=labels)
tidydata <- dcast(meltdata,subjectid+activitylabel ~ variable,mean)

# write data to file
write.table(tidydata,file="../tidydata.txt",row.names=FALSE)
