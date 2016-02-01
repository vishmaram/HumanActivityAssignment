rm(list=ls())
source("UtilityFunctions.R")

getwd();

######################## DOWNLOAD THE FILES ##############

# Below we downloaded the file and unzipped it to the data folder

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=url, destfile = "data/projectFilesDataSet.zip",method="auto")
unzip("data/projectFilesDataSet.zip", exdir = "data", overwrite = TRUE)


####################### LIST OF FILES ########################

#Below we fetch the list of files in the project and get rid of all the unnecessary files that are
 # not need for this assignment

#Also we a method from UtilityFunction.R called getObjNames, which returns returns the the files names
# in the fileList as obj Names

fileList <- list.files( recursive = TRUE)
fileList <- fileList[grepl("*.txt",fileList)]
fileList <- fileList[grepl("(activity|/X_|/y_|subject|features.txt|activity)",fileList)]
objNames <- sapply(fileList,getObjectNames,USE.NAMES = FALSE)

###################### READ AND TIDY THE DATA ##################

# Read all the files in the fileList and assign it as an object in the working List
workingList <- sapply(fileList,readLines,USE.NAMES = FALSE)

#Name all the object with the respective file Names
names(workingList) <- objNames

# Trim spaces- This method will remove all empty spaces and creates the data points separated by " "
workingList$X_test <- trimSpaces(workingList$X_test)
workingList$X_train <- trimSpaces(workingList$X_train)

#Convert to DataFrame method converts each one of the objects in workingList to data frame
workingList <- sapply(workingList,convertToDataFrame)


###################### CREATE COMBINED DATA ##################

# master test data is created by combining the columns of subject, activity, type and X_test
masterDataTest <- cbind(subject = workingList$subject_test,
                        activity = workingList$y_test,
                        type = c("Test"),
                        workingList$X_test)

# master training data is created by combining the columns of subject, activity, type and X_train
masterDataTrain <- cbind(subject = workingList$subject_train,
                        activity = workingList$y_train,
                        type = c("Training"),
                        workingList$X_train)

# Combine master data sets of test and training and remove the temp masterdata object
masterData <- rbind(masterDataTest,masterDataTrain)
rm(masterDataTest,masterDataTrain)

###################### ADD VARIABLE NAMES AND DESCRIPTIVE ACTIVITY VARIABLES ##################

# Add column names to the masterData object
colNames          <- c("Subject","ActivityId","Type",workingList$features[[2]])
names(masterData) <- colNames

# assign variable names to the activity_labels object
names(workingList$activity_labels)<- c("ActivityId","Activity")

# Merge masterData and activity_labels in order to create descriptive activity variables
masterData <- merge(workingList$activity_labels,masterData,by.x="ActivityId",
                    by.y="ActivityId",all=TRUE)

###################### CREATE DATA SUBSET WITH ONLY MEAN AND STD MEASUREMENTS ##################

# create a logical object that gives true when col name contains Mean or Std (Standard Deviation) or
# Subject and Activity column Names
colNames <- names(masterData)
columnLogical <- grepl("-[Mm]ean|-[Ss]td|Subject|Activity",colNames)

# Set False for the "ActivityId" column as we do not need this column
columnLogical[1] <- FALSE 

# Using above logical create data subset
dataSubSet <- masterData[,columnLogical]

###################### CREATE MEAN DATA BY SUBJECT AND ACTIVITY ##################

# coerce the measurement columns to numeric
dataSubSet[,-(1:2)] <- sapply(dataSubSet[,-(1:2)],as.numeric)

#Agreegate the measurement columns by Activity and Subject and store in summarysubset, which is final result
summarySubSet <- aggregate(dataSubSet[,-(1:2)],dataSubSet[,1:2],mean)

names(summarySubSet)
