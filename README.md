# *Getting and Cleaning Data*

### Informations

This repository contains the following files:

- `README.md`, Informations about this repo. (current file)
- `data.txt`, which contains the data set.
- `CodeBook.md`, the code book, which describes the contents of the data set (data, variables and transformations used to generate the data).
- `run_analysis.R`, the R script that was used to create the data set.


### Running the script

The R script `run_analysis.R` can be used to create the data set. It retrieves the source data set and transforms it to produce the final data set by implementing the following steps (more informations in the code book):

- Download and unzip source data if it doesn't exist.
- Read data.
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Use descriptive activity names to name the activities in the data set.
- Appropriately label the data set with descriptive variable names.
- Create a second, independent tidy set with the average of each variable for each activity and each subject.
- Write the data set to the `data.txt` file.

The `data.txt` in this repository was created by running the `run_analysis.R` script using R version 3.5.3 (2019-03-11) on apple-darwin15.6.0 x86_64 edition.

This script requires the `dplyr` package.
