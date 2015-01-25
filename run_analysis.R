run_analysis <- function(){
      ## This function is for Getting and Cleaning Data course and will do the following: 
      ## Adds descriptive activity names to name the subject activities in the data set
      ## Appropriately labels the data with descriptive variable names. 
      ## Merges the training and the test sets to create one data set.
      ## And then extracts only the measurements on the mean and standard deviation. 
      
      ## import required modules
      library(dplyr)
      
      ## create varable for the poject data folder path
      data.folder <- "./data_project/"
      
       ## download the data files
       fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
       
       download.file(fileUrl,destfile="getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",method="curl")
       
       ## extract the files to the data folder
       unzip(paste0(data.folder, "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"), overwrite = TRUE, exdir = data.folder)
      
      ## Add columns ‘Subjects’ (subject_test.txt) and ‘Activities’ (y_test.txt) 
      ## to test and train results variables.
      ##
      ## First, get the "test" test results, test activities and test subjects files.
      test_results <- read.table(paste0(data.folder, "UCI HAR Dataset/test/X_test.txt"))
      test_activity <- read.table(paste0(data.folder, "UCI HAR Dataset/test/y_test.txt"))
      test_subject <- read.table(paste0(data.folder, "UCI HAR Dataset/test/subject_test.txt"))
      
      ## expand test_activity to descriptive text. 
      ##Get the activity labels
      activity_labels <- read.table(paste0(data.folder, "UCI HAR Dataset/activity_labels.txt"))
  
      ## convert the test_activity number to meaniful text
      for(i in seq_along(test_activity[,1])) {
            test_activity[i,1] <- as.character(activity_labels[test_activity[i,1],2])
      }
      
      
      ## combine the subject and activity columns to TEST results file
      test_results <- cbind(test_activity, test_results)
      test_results <- cbind(test_subject, test_results)
      
      ## now do the same thing for the TRAIN data     
      
      ## First, get the "train" test results, train activities and train subjects files.
      train_results <- read.table(paste0(data.folder, "UCI HAR Dataset/train/X_train.txt"))
      train_activity <- read.table(paste0(data.folder, "UCI HAR Dataset/train/y_train.txt"))
      train_subject <- read.table(paste0(data.folder, "UCI HAR Dataset/train/subject_train.txt"))

      ## convert the test_activity number to meaniful text
      for(i in seq_along(test_activity[,1])) {
      train_activity[i,1] <- as.character(activity_labels[train_activity[i,1],2])
      }

      ## combine the subject and activity columns to TRAIN results file
      train_results <- cbind(train_activity, train_results)
      train_results <- cbind(train_subject, train_results)
      
      ## Add tests header row from the features.txt file (column 1) to test_results and train_results
      tests_performed <- read.table(paste0(data.folder, "UCI HAR Dataset/features.txt"))
      
      # get just the test descriptive names
      tests_performed_vector <- tests_performed[,2]
      
      # add 'subject' and 'activity' to the vector
      results_header <- c("Subject", "Activity", as.character(tests_performed_vector))
      
      ## combine the tests performed info to the first row of the test results and train results
      test_results <- rbind(results_header,test_results)
      train_results <- rbind(results_header,train_results)      
      
      ## combine test_results and train_results 
      total_results <- rbind(test_results, train_results)

      ## Create a DF with only the measurements on the mean and standard deviation.
      ## get the column number of each column with std or mean in the name
      extract_cols <- c(1, 2, grep("mean", total_results[1,]), grep("std", total_results[1,]))
      
      ## Create the new DF with only the mean and std results
      mean_std_results <- total_results[,extract_cols]
      
      ## Create a second data set with the average of each variable for each activity and each subject.
      ## save column header
      mean_std_results_header <- mean_std_results[1,]

      #remove mean_std_results header for sorting
      mean_std_results_no_header <- mean_std_results[-1,]

      ## Order mean_std_results by subject and activity      
      mean_std_results_no_header <- arrange(mean_std_results_no_header, V1, V1.1)

      ## add the header back
      mean_std_results <- rbind(mean_std_results_header, mean_std_results_no_header)

      write.table(mean_std_results, file="mean_std_results.txt", row.name=FALSE)
      
}
