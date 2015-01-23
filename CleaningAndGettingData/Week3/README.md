# Getting And Cleaning Data - Course Project

## Introduction

This repo contains my Getting and Cleaning Data Coursera project ["Getting And Cleaning Data"](https://class.coursera.org/getdata-002)

Scripts:

`run_analysis.R`. 

Functions:

run:
  * loads data (expects by default unzipped data in de working directory)
  * returns dataframe combining test and train data, with average mean and std measurments per subject per activity
    and saves it in txt file

loadData:
  * takes a directory where the data is ( by default UCI HAR Dataset/UCI HAR Dataset in working dir)
  * loads test and train data and merges it

loadOneFile:
  * takes directory and file names for DataFile, LabelsFile, SubjectFile, FeaturesFile and ActivityFile
  * returns combined data frame (data + features + activities + subjects with only std and mean measurments)  

calcResult:
  * takes combined data frame (data + features + activities + subjects with only std and mean measurments)  
  * returns data frame with averages for mean and std measurments for every subject and every activity

The `CodeBook.md` explains the flow more in detail.

## Run from command line

1. Download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. unzip it in the working directory

3. source the script in R studio

4. execute function run()

5. wait... on my PC it takes 7 minutes

the final dataset is to be found in the working directory. By default the result is saved as result.txt  
