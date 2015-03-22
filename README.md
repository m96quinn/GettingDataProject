# GettingDataProject
Getting Data Course Project
This repo contains one script run_Analysis.R which reads in training and test data sets containing accelerometer data.  The data are from thirty test subjects performing six different activities (Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, Laying).

The script merges the training and test data sets. They initially contain 561 colums of measurement, but this number is reduced by selecting only parameters that contain a mean or standard deviation of a measured parameter.

The script then summarizes the new, smaller data set by averaging over each Activity and each participant.  This new data set is written out to a text file, "TidyData.txt".  The names of each parameter in the data set is written in the file "TidyNames.txt".