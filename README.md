# Course Project for Getting and Cleaning Data
## from Jonhs Hopkins University at [Coursera.org] (https://www.coursera.org)
### by Hao Wu

### Top Level Directory Tree

* `README.md`: This file. Describes the project structure.
* `codebool.md`: Describes the combined and tidied data sets.
* `run_analysis.R`: The R scripts that combines and tidies the data sets.
* `UCI-HAR-Dataset-Combined-and-Tidied`: Contains the data files for combined and tidied data sets.
* `LICENSE`: The copyright license for this project.

```
├── README.md
├── codebook.md
└── run_analysis.R
├── UCI-HAR-Dataset-Combined-and-Tidied
│   ├── measureDataMeanStd.csv
│   ├── measureDataMeanStdTidyAverage.csv
├── LICENSE
```

### The Script `run_analysis.R`

- **How to run**

  - Option 1: Create a new folder in your current work directory. Set the new folder to be the work directory. Download the script into the new folder. Open it in RStudio and source it, or run `source ./run_analysis.R` from the RStudio console.
  - Option 2: In a Shell, for example the Bash shell on a Ubuntu system or Mac OSX, make sure you are in the new folder, run `Rscript ./run_analysis.R`

- **What it does**

  - *Step 0:* Download the original zipped data files from [This Link] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
  - *Step 1:* Read in activity labels and feature names. Combine train data sets and test data sets by merging them.
  - *Step 2:* Extract only mean and standard deviation measurement variables into a new data frame.
  - *Step 3:* Use descriptive activity names on the new data frame.
  - *Step 4:* Use descriptive variable names by replacing period `.` with underscore `_`, `Mag` with `Magnitude`, `gravity` with `Gravity` etc. 
  - *Step 5:* Save all data sets into a `.RData` file as well as separate `.csv` files.  

