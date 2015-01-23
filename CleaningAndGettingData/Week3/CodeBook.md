# Code Book

This document describes the code inside `run_analysis.R`.

## functions

run analysis consists of 4 functions

run:
  * loads data (expects by default unzipped data in de working directory)
  * returns dataframe combining test and train data, with average mean and std measurments per subject per activity

loadData:
  * takes a directory where the data is ( by default UCI HAR Dataset/UCI HAR Dataset in working dir)
  * loads test and train data and merges it

loadOneFile:
  * takes directory and file names for DataFile, LabelsFile, SubjectFile, FeaturesFile and ActivityFile
  * returns combined data frame (data + features + activities + subjects with only std and mean measurments)  

calcResult:
  * takes combined data frame (data + features + activities + subjects with only std and mean measurments)  
  * returns data frame with averages for mean and std measurments for every subject and every activity

## Data Manipulation

NOTE 1: the script expects the unzipped data in the working directory by default in getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset folder

NOTE 2: the script writes the result to the file (by default result.csv). If the output file exists, the script returns error. Rename/Remove output file or pass different output file to the run() function

1. it loads the train data as fixed width format file with 561 columns of 16 chars long fields
2. it loads features from the file and sets the column names
3. adjusts the dataframe and leaves only std and mean measurments
4. reads labels and activities and adds activities names to the data.frame
5. reads subjects and adds it to the data.frame
6. repeats steps 1-6 for test dataset
7. merges train and test data
8. melts the data.frame so the subject and activity can be used as a key
9. calculates averages of all the variables in the melted data.frame and set it to the result data.frame
10. writes the result data.frame to csv file and returns it
