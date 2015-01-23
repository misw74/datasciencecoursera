library(reshape2)

#
# loadOneFile - loads one single data file
# it combines it with labels, features, and activities
# returns dataframe with subject, activity, std and mean featues
#
loadOneFile <- function( aDir, aDataFile, aLabelsFile, aSubjectFile, aFeaturesFile, anActivityFile ) {    
  #first let's check of we have all those files    
  myDataFile <- file.path(aDir, aDataFile)    
  print( sprintf("%s loading %s", Sys.time(), myDataFile) )
  if ( !file.exists(myDataFile) ) {
    stop( sprintf("%s data file not found", myDataFile ) )
  }
  
  myLabelsFile <- file.path(aDir, aLabelsFile)
  if ( !file.exists(myLabelsFile) ) {
    stop( sprintf("%s labels file not found", myLabelsFile ) )
  }
  
  
  mySubjectsFile <- file.path(aDir, aSubjectFile)
  if ( !file.exists(mySubjectsFile) ) {
    stop( sprintf("%s subject file not found", mySubjectsFile ) )
  }
  
  myFeaturesFile <- file.path(aDir, aFeaturesFile)  
  if ( !file.exists(myFeaturesFile) ) {
    stop( sprintf("%s features file not found", myFeaturesFile ) )
  }
    
  myActivityFile <- file.path(aDir, anActivityFile)
  if ( !file.exists(myActivityFile) ) {
    stop( sprintf("%s activity file not found", myActivityFile ) )
  }
  
  # all data seems to be in place
  # let's read the data
  myWidth <- rep(16, 561) # 561 columns of 16 chars each
  
  # on pc with 8GB memory, default 2000 lines buffer gives error
  myRetVal <- read.fwf(myDataFile, widths = myWidth, buffersize = 1000 ) 
  
  # read feature names from the file
  myFeatures <- read.table( myFeaturesFile, sep=" ")
  
  # set the colum names in de dataset
  names(myRetVal) <- myFeatures[,2]
  
  # take only std and mean measurments
  mySelectedCols <- grep( "std", names(myRetVal) )
  mySelectedCols <- c( mySelectedCols, grep( "mean", names(myRetVal) ) )  
  myRetVal <- myRetVal[, mySelectedCols ]
  
  # read labels names from file
  myLabels <- read.table( myLabelsFile, sep=" ")
  
  # read activity labels from file
  myActivities <- read.table( myActivityFile, sep=" ")
  
  # add readable names of activities
  myLabels$name <- myActivities[ (myLabels$V1 %% 7), ]$V2
  
  # add activity labels to the DF
  myRetVal <- cbind( myLabels[,2], myRetVal)  
  colnames(myRetVal)[1] <- "activity"

  # read subjects from file
  mySubjects <- read.table( mySubjectsFile, sep=" ")
  
  # merge subjects with the data
  myRetVal <- cbind( mySubjects, myRetVal)
  colnames(myRetVal)[1] <- "subject"
  
  myRetVal
}

#
# loadData - 
# loads test and train data and returns combined data.frame
#
loadData <- function( aDir ) {   
  if ( !file.exists(aDir) ) {
    stop( sprintf("%s not found", aDir) )
  }
  
  if ( !file.info(aDir)$isdir ) {
    stop( sprintf("%s is not a directory", aDir) )
  }  
  
  # global 
  FEATURES <-  "features.txt"
  ACTIVITY_LABELS <- "activity_labels.txt"
  
  # load train set
  TRAIN_DATA <- "train/X_train.txt"
  TRAIN_LABELS <- "train/y_train.txt"
  TRAIN_SUBJECTS <- "train/subject_train.txt"
  myTrainData <- loadOneFile( aDir, TRAIN_DATA, TRAIN_LABELS, TRAIN_SUBJECTS, FEATURES, ACTIVITY_LABELS)

  
  #load test set
  TEST_DATA <- "test/X_test.txt"
  TEST_LABELS <- "test/y_test.txt"
  TEST_SUBJECTS <- "test/subject_test.txt"
  myTestData <- loadOneFile( aDir, TEST_DATA, TEST_LABELS, TEST_SUBJECTS, FEATURES, ACTIVITY_LABELS)
  
  # merge
  myRetVal <- rbind( myTrainData, myTestData )    
}

#
# calcResult - returns result dataframe averages of all mean and std measurments per subject per activity
#
calcResult <- function( aDF ) {
  print( sprintf("calculating result") )
  
  # calculate mean per subject per activity
  # 1. melt the data set per ids subject, activity
  myPerSubjectPerActivityDF <- melt( aDF, id=c( "subject", "activity") )
  
  # 2. run mean on it and cast it
  myRetVal <- dcast( subject + activity ~ variable, data = myPerSubjectPerActivityDF, fun = mean )    
}

run <- function( aDir = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset", destcsv = "result.txt") {  
  if( file.exists(destcsv) )
  {
    stop( sprintf( "%s already exists, provide other destination", destcsv ) )
  }
  
  print( sprintf("%s import started", Sys.time()) )
  myCombinedDF <- loadData(aDir)      
  
  print( sprintf("%s import completed", Sys.time()) )  
  myRetVal <- calcResult(myCombinedDF)
  
  print( sprintf("%s saving results", Sys.time()) )
  write.table( myRetVal, file=destcsv )
  
  myRetVal
}

