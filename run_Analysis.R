run_Analysis <- function(){

	##library(dplyr)

	## Read in training data set
	trainingFile <- read.csv("train/X_train.txt", head= FALSE, sep="")

	##Read in the training subject and activity files and name the data frame columns 
	subjectTrain <- read.csv("train/subject_train.txt", head= FALSE, sep="")
	activityTrain <- read.csv("train/y_train.txt", head= FALSE, sep="")
	colnames(subjectTrain) <- "Subject"
	colnames(activityTrain) <- "Activity"
	
	##Replace activity numbers with labels
	activityTrain[activityTrain =="1"]<-"WALKING"
	activityTrain[activityTrain =="2"]<-"WALKING_UPSTAIRS"
	activityTrain[activityTrain =="3"]<-"WALKING_DOWNSTAIRS"
	activityTrain[activityTrain =="4"]<-"SITTING"
	activityTrain[activityTrain =="5"]<-"STANDING"
	activityTrain[activityTrain =="6"]<-"LAYING"

	## Add subject and activity as columns
	trainingFile <- cbind(trainingFile, activityTrain)
	trainingFile <- cbind(trainingFile, subjectTrain)

	##Read in the test data set
	testFile <- read.csv("test/X_test.txt", head= FALSE, sep="")
	
	##Read in the test subject and activity files and name the data frame columns 
	subjectTest <- read.csv("test/subject_test.txt", head= FALSE, sep="")
	activityTest <- read.csv("test/y_test.txt", head= FALSE, sep="")
	colnames(subjectTest) <- "Subject"
	colnames(activityTest) <- "Activity"

	##Replace activity numbers with labels
	activityTest[activityTest =="1"]<-"WALKING"
	activityTest[activityTest =="2"]<-"WALKING_UPSTAIRS"
	activityTest[activityTest =="3"]<-"WALKING_DOWNSTAIRS"
	activityTest[activityTest =="4"]<-"SITTING"
	activityTest[activityTest =="5"]<-"STANDING"
	activityTest[activityTest =="6"]<-"LAYING"

	## Add subject and activity as columns
	testFile <- cbind(testFile, activityTest)
	testFile <- cbind(testFile, subjectTest)
	
	## Merge the test and training data sets by row binding them
	MergedData <- rbind(trainingFile, testFile)
	
	## Open features.txt to get the names of the colums in the data frame
	Features <- read.csv("features.txt", head= FALSE, sep="", stringsAsFactors = FALSE)
	
	##Get all the columns in MergedData with Mean, mean, STD, or std in the feature name
	MeanSTD <- grep("Mean|mean|std|STD", Features$V2)
	
	## Also get the Activity and Subject columns too
	MeanSTD <- c(MeanSTD, 562, 563)
	
	##Get all the actual names that include Mean, mean, STD, or std.
	SubFeatures <- Features[MeanSTD,]
	FeatVec <- SubFeatures[,2]
	##Have to add in Activity and Subject since they are not in features.txt	
	FeatVec[87] <- "Activity"
	FeatVec[88] <- "Subject"
	
	
	##Subset MergedData, keeping only the columns in MeanSTD.
	##This uses the 'select' command in the dplyr package.
	SubMergedData <- select(MergedData, MeanSTD)
	
	##Put in the correct variable names for our tidy data set. 
	colnames(SubMergedData) <- FeatVec

	##Create two data frames with the means of the variables in the combined test and training data sets
	##These are sorted by Activity in the first and Subject in the second
	tidy <- as.data.frame(SubMergedData %>% group_by(Activity) %>% summarise_each(funs(mean)))
	
	##This sort gives warnings because it tries to take the mean of the strings of Activity
	##which makes no sense.  We drop this column anyway, so we just ignore the warnings.
	tidy2 <- SubMergedData %>% group_by(Subject) %>% summarise_each(funs(mean))
	
	##Row bind the two data frames to combine into one tidy data set
	tidy <- rbind(tidy,tidy2)
	##Get rid of the colums with Subject and Activity since we aren't supposed to average over these.
	tidy <- tidy[,2:87]	

	##Write the output to a file.
	##I did it without row names as instructed, but also without column names
	##in order to make it similar to the original tidy data files in the assignment. 
	write.table(tidy, file = "TidyData.txt", row.name =FALSE, col.name=FALSE)	
}