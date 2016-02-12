##Script to download data file, merge and clean the data into a tidy dataset.


##Install the library to run the script.
require("plyr",character.only = TRUE)
require("dplyr",character.only = TRUE)
require("tidyr",character.only = TRUE)
library(plyr)
library(dplyr)
library(tidyr)

##Download the data from source website.######################################################

##Verify if there a data directory in the working directory, if no, create a new directory.
if(!file.exists("./data")){dir.create("./data")}

##download the data files from the source
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, dest="./data/dataset.zip", mode="wb") 

##Extract the data file from the zip file
unzip ("./data/dataset.zip", exdir = "./data")


##Step 1 - Merges the training and the test sets to create one data set#######################

##Load data from X_train.txt, activity id and subject information and append 
##into one single data set. 
dataTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainlabel <-  read.table("./data/UCI HAR Dataset/train/y_train.txt")
names(trainlabel) <- c("ActID")
trainsubject <-  read.table("./data/UCI HAR Dataset/train/subject_train.txt")
names(trainsubject) <- c("SubjectID")
dataTrain <- cbind(dataTrain, trainlabel, trainsubject)


##Repite the same for Test dataset.


dataTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testlabel <-  read.table("./data/UCI HAR Dataset/test/y_test.txt")
names(testlabel) <- c("ActID")
testsubject <-  read.table("./data/UCI HAR Dataset/test/subject_test.txt")
names(testsubject) <- c("SubjectID")
dataTest <- cbind(dataTest, testlabel, testsubject)


##Merge (append) the Test and Train data sets into one dataset.
mergedData <- rbind(dataTest, dataTrain)



##Step 2 - Extracts only the measurements on the mean and standard 
           ##deviation for each measurement. #################################################

##Load the field names
features <- read.table("./data/UCI HAR Dataset/features.txt")

##Create a vector of field names
dataFielsNames <- as.vector(features[,2])

##Select all the field in the data.frame that contains
##standard deviation  or mean measurements
dataStep2 <- select(mergedData, grep("std()", dataFielsNames),grep("mean()", dataFielsNames), ActID, SubjectID)

##Rename the fields according to the features.txt data
names(dataStep2) <- paste(c(dataFielsNames[grep("std()", dataFielsNames)], 
                            dataFielsNames[grep("mean()", dataFielsNames)], 
                            "ActID", "SubjectID"))



##Step 3 - Uses descriptive activity names to name the activities in the data set. ###########

##Load the activity name data
actlabel <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
names(actlabel) <- c("ActID", "ActName")

##Merge the activity name with the dataset
dataStep3 <- merge(dataStep2,actlabel, by.x = "ActID", by.y = "ActID")



##Step 4 - Appropriately labels the data set with descriptive variable names. ################

##Split the column name and populate fields with the column name
dataStep4 <- dataStep3 %>% 
  gather(key = "Measure-Stat-Axis", value = observation, -c(ActID, SubjectID, ActName)) %>%
  separate(col = "Measure-Stat-Axis", into = c("Measure", "Stat", "Axis"))

  

##Step 5 - From the data set in step 4, creates a second, independent tidy data set 
           ##with the average of each variable for each activity and each subject.###########

##Summarize the dataset calculating mean
dataStep5 <- tbl_df(dataStep4) %>%
  select(SubjectID:observation) %>%
  group_by(SubjectID, ActName, Measure, Stat, Axis)

##Calculate the mean considering subject, activity name and each variable (measurement, Stat and Axis)
result <- summarise(dataStep5, mean(observation)) %>%
  filter(Stat == "mean"| Stat == "std")

##Save the dataset into a text file.

write.table(result, file = "./data/dataStep5.txt", sep="\t", row.name=FALSE)

############################################## END ##########################################
