Course project for Johns Hopkins University's Getting and Cleaning Data course on Coursera, run during October 2015.

# Assignment

Take [data collected from smartphone accelerometers] [1] ([described here] [2]) and write a script that does the following:

1. Merges the training and the test sets to create one dataset
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the dataset
4. Appropriately labels the data set with descriptive variable names
5. Creates a second independent tidy dataset with the average of each variable for each activity and each subject

[1]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
[2]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


# Solution

The script `run_analysis.R` completes all five steps listed above. The dataset created after step 4 is stored in the `dataset` variable. The dataset created after step 5 is output to a file name `har_tidy.csv` in the working directory (and [an example is included in the repo] [3]).

[3]: https://github.com/flother/gcd/blob/master/har_tidy.csv


# Running the R script

For the script to run you need the course's copy of the source data in your working directory. To do that on a Unix system:

    cd gcd
    curl "https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip" > dataset.zip
    unzip dataset.zip

From within the `gcd` directory (the root of this repo) you can then run:

    Rscript run_analysis.R


# Codebook

The columns and variables contained within the `dataset` data frame and `har_tidy.csv` are described in [the codebook included in this repo] [4] (`CodeBook.md`). The codebook also contains a description of transformations that were made to the original data.

[4]: https://github.com/flother/gcd/blob/master/CodeBook.md


# Licence

The script is licensed under the MIT licence, as described in the `LICENCE` file.