install.packages("dplyr")

library(dplyr)


#
# Step 1 => Download Data
#
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <- "UCI HAR Dataset.zip"

if (!file.exists(file_name)) {
  download.file(url, file_name, mode = "wb")
}


#
# Step 2 => Extract Data from downloaded zip file
#
dir_path <- "UCI HAR Dataset"
if (!file.exists(dir_path)) {
  unzip(file_name)
}


#
# Step 3 => Load data to memory
#
# Test set
test_subjects <- read.table(file.path(dir_path, "test", "subject_test.txt"))
test_values <- read.table(file.path(dir_path, "test", "X_test.txt"))
test_activities <- read.table(file.path(dir_path, "test", "y_test.txt"))

# Training set
training_subjects <- read.table(file.path(dir_path, "train", "subject_train.txt"))
training_values <- read.table(file.path(dir_path, "train", "X_train.txt"))
training_activities <- read.table(file.path(dir_path, "train", "y_train.txt"))

features <- read.table(file.path(dir_path, "features.txt"), as.is = TRUE)

activities_label <- read.table(file.path(dir_path, "activity_labels.txt"))
colnames(activities_label) <- c("activityId", "activityLabel")


#
# Step 4 => Merge training set and test set into one set
#
complete_activities <- rbind(
  cbind(training_subjects, training_values, training_activities),
  cbind(test_subjects, test_values, test_activities)
)

# Releasing old data stored in memory
rm(training_subjects, training_values, training_activities, 
   test_subjects, test_values, test_activities)

# assign column names
colnames(complete_activities) <- c("subject", features[, 2], "activity")


#
# Step 5 => Extract mean & SD
#
needed_cols <- grepl("subject|activity|mean|std", colnames(complete_activities))
complete_activities <- complete_activities[, needed_cols]


#
# Step 6 => Add Activity descriptive name (instead of numeric value)
#
complete_activities$activity <- factor(complete_activities$activity, 
                                 levels = activities_label[, 1], labels = activities_label[, 2])


#
# Step 7 => Tidy the dataset
#
columns_names <- colnames(complete_activities)
columns_names <- gsub("[\\(\\)-]", "", columns_names)

columns_names <- gsub("^f", "frequencyDomain", columns_names)
columns_names <- gsub("^t", "timeDomain", columns_names)
columns_names <- gsub("Acc", "accelerometer", columns_names)
columns_names <- gsub("Mag", "magnitude", columns_names)
columns_names <- gsub("Freq", "frequency", columns_names)

colnames(complete_activities) <- columns_names


#
# Step 8 => Second tidy set for avergages
#
complete_activities_means <- complete_activities %>% 
  group_by(subject, activity) %>%
  summarise_each(list(mean))

write.table(complete_activities_means, "data.txt", row.names = FALSE, quote = FALSE)
