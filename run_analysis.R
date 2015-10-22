# Take the data provided in Reyes-Ortiz et al's smartphone-based human activity
# recognition dataset and merge the training and test sets, extract only mean
# and standard deviation measurements, add subject and activity columns, and
# tidy the data so it has one value per column and one observation per line.
#
# Note: this script assumes you have a copy of the dataset in your working
# directory. To get it, download and unzip the data from:
#
#     https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip
#
# Make the resulting "UCI HAR Dataset" directory your working directory.

library(dplyr)
library(readr)
library(reshape2)
library(stringr)


# Read a fixed-width file that contains columns each of length 16, where all
# values are doubles.
read.x <- function(file, col_names) {
  read_fwf(file,
           fwf_widths(rep(16, length(col_names)), col_names),
           col_types=paste(rep("d", length(col_names)), collapse=""))
}


# Read a CSV with no headers and only a single column containing integers.
read.col <- function(file) {
  read_csv(file, col_names=FALSE, col_types="i")
}


# Load the feature names as a data frame with a single column. They'll be used
# as column names when loading the X_* data.
features <- read_delim("features.txt", " ",
                       col_names=FALSE,
                       col_types="_c")[[1]]
# Load the X_* training and testing data and combine them into a single data
# frame.
x <- rbind(read.x("train/X_train.txt", features),
           read.x("test/X_test.txt", features))[, !duplicated(features)]
# Load the subject training and testing data and combine them into a single data
# frame.
subjects <- rbind(read.col("train/subject_train.txt"),
                  read.col("test/subject_test.txt"))

# Load the activities. First the raw numbers are collected from the training and
# testing data, then they're matched against the labels given in
# activity_labels.txt. We're left with a two-column data frame.
activities <- rbind(read.col("train/y_train.txt"),
                    read.col("test/y_test.txt")) %>%
              merge(read_delim("activity_labels.txt", " ",
                               col_names=F,
                               col_types="ic"))

# Create a single data frame from the x and subject data. The subject data
# becomes the first column. The x data is reduced down to only those columns
# containing means or standard deviations (defined by the column names taken
# from the features). The data frame's then melted so that each row contains a
# single observation.
dataset <- x %>%
  mutate(subject=subjects[[1]]) %>%
  mutate(activity=tolower(activities[[2]])) %>%
  select(subject, activity, matches("-(std|mean)\\(\\)")) %>%
  melt(id.vars=c("subject", "activity"), variable.name="feature")

# Split the feature out into its component parts and make the result a data
# frame. Clean up all the column values (make them tidy and human-readable).
features.df <- str_match(dataset$feature,
                         paste0("^(t|f)(Body|Gravity)(?:Body)?",
                                "(Acc|Gyro)(JerkMag|Jerk|Mag)?-(mean|std)",
                                "\\(\\)(?:-(X))?")) %>%
  data.frame() %>%
  mutate(original=X1,
         domain=ifelse(X2 == "t", "time", "frequency"),
         acceleration_signal=tolower(X3),
         signal_type=X4,
         signal_dimension=X5,
         `function`=X6,
         axis=tolower(X7)) %>%
  select(original, domain, acceleration_signal, signal_type, signal_dimension,
         `function`, axis)
levels(features.df$signal_type) <- c("acceleration", "gyroscope")
levels(features.df$signal_dimension) <- c("jerk", "jerk magnitude", "magnitude")

# Merge the clean features back into the main dataset and remove the now-unused
# feature and original columns.
dataset <- dataset %>%
  cbind(features.df) %>%
  select(subject, activity, domain, acceleration_signal, signal_type,
         signal_dimension, `function`, axis, value)

# Now save the summarised dataset by calculating the mean average for each
# combination of subject, activity, measurement, func, and axis.
write_csv(dataset %>%
            group_by(subject, activity, domain, acceleration_signal,
                     signal_type, signal_dimension, `function`, axis) %>%
            summarise(avg_value=mean(value)) %>%
            ungroup(),
          "har_tidy.csv")
