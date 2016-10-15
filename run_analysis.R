# https://www.coursera.org
# Getting and Clearning Data, Data Science Specialization, Johns Hopkins University
# Week 4 Course Project by Hao Wu
# 
# PROJECT DESCRIPTION:
# One of the most exciting areas in all of data science right now is wearable computing.
# Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced 
# algorithms to attract new users. The data linked to from the course website represent 
# data collected from the accelerometers from the Samsung Galaxy S smartphone. A full 
# description is available at the site where the data was obtained:
#     
#     http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
#
# STEP.0 - Download zip file from web URL. Extract data files.
writeLines( paste( "run_analysis.R working in", getwd(), sep = " " ) )
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipName <- "UCI_HAR_Dataset.zip"
writeLines( paste( "\nDownloading", zipUrl, "...", sep=" " ) )
download.file( url=zipUrl, destfile=zipName, method="curl", quiet=FALSE )

zipPath <- file.path( getwd(), zipName )
if( file.exists( zipPath ) ) {
    writeLines( paste( "\nExtracting", zipPath, sep=" " ) )
    unzip( zipfile=zipPath, overwrite=TRUE )
} else {
    writeLines( paste("\nFile", zipName, "not found in", getwd(), "\nQuit.", sep=" " ) )
    return( NULL )
}
#
# STEP.1 - Read activity labels and feature names.
#        - Read train data and test data, then merge them into one dataset.
dataPath <- file.path( getwd(), "UCI HAR Dataset" )
writeLines( paste( "\nReading activity labels from", 
                   file.path( dataPath, "activity_labels.txt" ), 
                   sep="\n" ) )
activityLabels <- read.table( file.path( dataPath, "activity_labels.txt" ), 
                              col.names=c("activityID", "activityName"), 
                              stringsAsFactors=FALSE )
writeLines( paste( "\nReading feature names from", 
                   file.path( dataPath, "features.txt" ), 
                   sep="\n" ) )
features <- read.table( file.path( dataPath, "features.txt"), 
                                   col.names=c("featureID", "featureName"), 
                                   stringsAsFactors=FALSE )

writeLines( paste( "\nReading and combining main measures data from", 
                   file.path(dataPath, "train"), 
                   file.path(dataPath, "test"),
                   sep="\n" ) )
subjectTrain <- read.table( file.path( dataPath, "train", "subject_train.txt" ),
                            col.names=c("subject"),
                            stringsAsFactors=FALSE )
subjectTest <- read.table( file.path( dataPath, "test", "subject_test.txt" ),
                           col.names=c("subject"),
                           stringsAsFactors=FALSE )
measureDataAllOriginal <- rbind( subjectTrain, subjectTest )
rm( subjectTrain, subjectTest )

yTrain <- read.table( file.path( dataPath, "train", "y_train.txt" ),
                      col.names=c("activity"),
                      stringsAsFactors=FALSE )
yTest <- read.table( file.path( dataPath, "test", "y_test.txt" ),
                     col.names=c("activity"),
                     stringsAsFactors=FALSE )
measureDataAllOriginal <- cbind( measureDataAllOriginal, rbind( yTrain, yTest ) )
rm( yTrain, yTest )

xTrain <- read.table( file.path( dataPath, "train", "X_train.txt" ),
                      col.names=features$featureName,
                      stringsAsFactors=FALSE )
xTest <- read.table( file.path( dataPath, "test", "X_test.txt" ),
                     col.names=features$featureName,
                     stringsAsFactors=FALSE )
measureDataAllOriginal <- cbind( measureDataAllOriginal, rbind( xTrain, xTest ) )
rm( xTrain, xTest )

writeLines( paste( "\nReading and combining inertial signals data from", 
                   file.path( dataPath, "train", "Inertial Signals" ), 
                   file.path( dataPath, "test", "Inertial Signals" ),
                   sep="\n" ) )
filesTrain <- list.files( path=file.path( dataPath, "train", "Inertial Signals" ), 
                          pattern="\\.txt", 
                          full.names=TRUE, recursive=FALSE )
filesTest <- list.files( path=file.path( dataPath, "test", "Inertial Signals" ), 
                         pattern="\\.txt", 
                         full.names=TRUE, recursive=FALSE )
signalLabels <- sub( "_train[.]txt", "", basename( filesTrain ) )
for ( i in 1:length( filesTrain ) ) {
    tmpTrain <- read.table( filesTrain[i], stringsAsFactors=FALSE )
    tmpTest <- read.table( filesTest[i], stringsAsFactors=FALSE )
    assign( signalLabels[i], rbind( tmpTrain, tmpTest ) )
}
rm( tmpTrain, tmpTest )
#
# STEP.2 - Extract only mean and standard deviation of measurements
try( library(dplyr), stop("\nSTOP: package dplyr is required for subsequent processing!" ) )
columns <- grep( "subject|activity|mean|std", colnames(measureDataAllOriginal), ignore.case=TRUE )
measureDataMeanStd <- dplyr::select( measureDataAllOriginal, columns )
#
# STEP.3 - Use descriptive activity names
measureDataMeanStd$activity <- factor( measureDataMeanStd$activity, labels=activityLabels$activityName )
#
# STEP.4 - Use descriptive variable names
colnames(measureDataMeanStd) <- gsub( "mean", "Mean", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "std", "Std", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "Acc[.]*", "Acceleration.", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "Mag", "Magnitude.", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "Gyro", "Gyroscope.", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "gravity", "Gravity", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "[.]+", "_", colnames(measureDataMeanStd), ignore.case=TRUE )
colnames(measureDataMeanStd) <- gsub( "_$", "", colnames(measureDataMeanStd), ignore.case=TRUE )
#
# STEP.5 - Create an independent tidy data set with the average of each variable for each 
#          activity and each subject
measureDataMeanStdTidyAverage <- measureDataMeanStd %>% 
                                 dplyr::group_by(subject, activity) %>% 
                                 summarize_all(mean)

outDirName <- "UCI-HAR-Dataset-Combined-and-Tidied"
if ( !dir.exists(outDirName) ) {
    dir.create( file.path( getwd(), outDirName ) )
}

outFile <- file.path( getwd(), outDirName, "UCI_HAR_Dataset-Combined_and_Tidied.RData" )
listDataFramesToSave <- Filter( function(x) is.data.frame( get(x) ), ls() )
save( list=listDataFramesToSave, file=outFile )

for ( i in 1:length(listDataFramesToSave) ) {
    outFile <- file.path( getwd(), outDirName, 
                          paste( listDataFramesToSave[i], ".csv", sep="" ) )
    write.table( get( listDataFramesToSave[i] ), 
                 outFile,
                 append=FALSE, quote=FALSE, sep=" ", eol="\n", na="NA", dec=".",
                 row.names=FALSE, col.names=TRUE )
}
writeLines( paste( "\nThe following data frames have been saved under", outDirName, "\n", sep=" " ) )
writeLines( paste( listDataFramesToSave, sep="\n"))
#
# END OF SCRIPT
