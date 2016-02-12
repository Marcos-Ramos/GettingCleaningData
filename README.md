## GettingCleaningData

#run_analysis.R

The **run_analysis.R** is an R script to join train and test data from Human Activity Recognition Using Smartphones Dataset (Version 1.0), select measurements related to mean and standard deviation and summarize it according to the activity and subject who performed the activity as well as the measurement detail.
**Codebook.md** explain the data origin and transformation, and the content of each column in dataStep5.txt.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Features are normalized and bounded within [-1,1].

The raw datasets are available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

And a full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script:
* Installs and loads all packages required to run, if necessary
* Verifies if there is a data folder in the Working Directory and, if not, creates it
* Downloads the data from source and unzip it
* Loads and merges the train and test dataset
* Selects the measurements on the mean and standard deviation though a logical vector of field names from features.txt
* Renames the fields according to features.txt
* Loads the activity name from file data and joins the activity name
* Gathers the field labels and separates the information that is in the field labels, measurement, statistic and axis
* Transforms the data.frame, groups the dataset and calculates the mean summarized by subject, activity name and measurement infos.
* Saves the data into a txt file in data directory.

