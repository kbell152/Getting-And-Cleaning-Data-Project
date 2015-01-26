The function run_analysis.R is for the Getting and Cleaning Data course and will do the following:

       Adds descriptive activity names to name the subject activities in the data set
       
       Appropriately labels the data with descriptive variable names. 
       
       Merges the training and the test sets to create one data set.
       
       And then extracts only the measurements on the mean and standard deviation. 
       
      
It first imports the required modules, then creates a varable for the poject data folder path

      library(dplyr)
      
      data.folder <- "./data_project/"

Next we download the data files from
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" and extracts 
the files to the data folder

       fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
       
       download.file(fileUrl,destfile="getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",method="curl")
      
Extract the files to the data folder

       unzip(paste0(data.folder, "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"), overwrite = TRUE, exdir = data.folder)
       
We then add columns ‘Subjects’ (subject_test.txt) and ‘Activities’ (y_test.txt) to test and train results variables.

      test_results <- read.table(paste0(data.folder, "UCI HAR Dataset/test/X_test.txt"))
      
      test_activity <- read.table(paste0(data.folder, "UCI HAR Dataset/test/y_test.txt"))
      
      test_subject <- read.table(paste0(data.folder, "UCI HAR Dataset/test/subject_test.txt"))
      
      ..........


We then convert the test_activity number to meaniful text
      
      for(i in seq_along(test_activity[,1])) {
      
      train_activity[i,1] <- as.character(activity_labels[train_activity[i,1],2])
      
      }
      

Next we combine the subject and activity columns to TEST results file with:

      test_results <- cbind(test_activity, test_results)

      test_results <- cbind(test_subject, test_results)
      

Next we do the same thing for the TRAIN data:     

      train_results <- read.table(paste0(data.folder, "UCI HAR Dataset/train/X_train.txt"))

      train_activity <- read.table(paste0(data.folder, "UCI HAR Dataset/train/y_train.txt"))

      train_subject <- read.table(paste0(data.folder, "UCI HAR Dataset/train/subject_train.txt"))


Then convert the test_activity number to meaniful text

      for(i in seq_along(test_activity[,1])) {

      train_activity[i,1] <- as.character(activity_labels[train_activity[i,1],2])

      }


Next combine the subject and activity columns to TRAIN results file

      train_results <- cbind(train_activity, train_results)

      train_results <- cbind(train_subject, train_results)
      

Add tests header row from the features.txt file (column 1) to test_results and train_results

      tests_performed <- read.table(paste0(data.folder, "UCI HAR Dataset/features.txt"))
      

Get just the test descriptive names

      tests_performed_vector <- tests_performed[,2]
      

Add 'subject' and 'activity' to the vector

      results_header <- c("Subject", "Activity", as.character(tests_performed_vector))
      

Combine the tests performed info to the first row of the test results and train results
 
     test_results <- rbind(results_header,test_results)

      train_results <- rbind(results_header,train_results)      
      

Combine test_results and train_results 

      total_results <- rbind(test_results, train_results)


Create a DF with only the measurements on the mean and standard deviation. and get the column number of each column with std or mean in the name

      extract_cols <- c(1, 2, grep("mean", total_results[1,]), grep("std", total_results[1,]))
      

Create the new DF with only the mean and std results

      mean_std_results <- total_results[,extract_cols]
      

Create a second data set with the average of each variable for each activity and each subject.
save column header

      mean_std_results_header <- mean_std_results[1,]


Remove mean_std_results header for sorting

      mean_std_results_no_header <- mean_std_results[-1,]


Order mean_std_results by subject and activity      

      mean_std_results_no_header <- arrange(mean_std_results_no_header, V1, V1.1)


Add the header back

      mean_std_results <- rbind(mean_std_results_header, mean_std_results_no_header)


And finally write the file for submission

      write.table(mean_std_results, file="mean_std_results.txt", row.name=FALSE)
