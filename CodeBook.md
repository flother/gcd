# Data description

A summarised form of the original [Human Activity Recognition Using Smartphones dataset] [ods] provided by Reyes-Ortiz et al.  The training and test sets are merged, all but the mean and standard deviation measurements are removed, subjects and activities are included, and the dataset has been "tidied" so it has one value per column and one observation per line.

# Variable description

The CSV is made up of nine columns, each of which is described below.

* *subject*: id of the volunteer subject, between 1 and 30
* *activity*: subject's activity at the time of the observation; one of
    - `laying`: lying down
    - `sitting`: sitting down
    - `standing`: standing still
    - `walking`: walking along a flat surface
    - `walking_downstairs`: walking upstairs
    - `walking_upstairs`: walking downstairs
* *domain*: `time` if the captured signal was a time domain signal, `frequency` if the captured signal had a Fast Fourier Transform applied
* *acceleration_signal*: whether the captured signal was a body (value `body`) or gravity (value `gravity`) acceleration signal
* *signal_type*: whether the sensor signal was an accelerometer (value `accelerometer`) or gyroscope (value `gyroscope`) signal
* *signal_dimension*:
    - `jerk`: the observation is a jerk signal
    - `magnitude`: the observation is the magnitude of the three-dimensional signal
    - `jerk magnitude`: the observation is the magnitude of the three-dimensional jerk signal
    - `NA`: jerk/magnitude data not available
* *function*: the function applied to the observations was either mean average (value `mean`) or standard deviation (value `std`)
* *axis*: the axis on which the observation occurred (`X`, `Y`, or `Z`); value is `NA` if no axis was recorded
* *avg_value*: observation value, either a mean average or a standard deviation depending on the value of the *function* column

# Transformations

From the [original data set] [ods] the following transformations were performed to create a tidy dataset:

1. X_* datasets read using the features dataset as headers
2. X_* datasets merged with subject and activity datasets
3. All measurements except mean and standard deviation measurements removed
4. Dataset reshaped to use *subject* and *activity* as id variables
5. Feature split into its component parts and the lower-case values are added as five columns — e.g. `tGravityAcc-mean()-Z` becomes column values, `t`, `Gravity`, `Acc`, `mean`, and `mean`; these values correspond to the *domain*, *acceleration_signal*, *signal_type*, *signal_dimension*, *function*, and *axis* columns in the tidy dataset
6. Values were made human-readable — e.g. `acc` becomes `accelerometer`
7. The dataset is summarised by averaging the observation value according to the *function* column, so that there's only one observation for each combination of subject, activity, domain, acceleration signal, signal type, signal dimension, function, and axis.


[ods]: https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip
