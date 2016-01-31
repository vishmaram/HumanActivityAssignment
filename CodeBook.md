#Human Activity Code Book
------------------------------------

This is a code book for the analysis code that is written. There are two main files that are written in 
order to tidy the data provided and create data objects that can be used for further analysis. Below are 
the two main script files:

- **run_analysis.R**: This is the main file of the program
- **UtilityFunctions.R**: This is a supporting file with resuable methods

The data from the link is downloaded into the **data/** folder of the project and unzipped in the same
folder. The folder structure inside the zip file is still retained.

In **run_analysis.R** file is divided into below 7 major sections:

- Download the files
- List the files
- Read and tidy the data
- Create combined master Data of test and training
- Add variable names and descriptive activity variables
- Create data subset with only mean and std measurements
- Create mean data by subject and activity

#### Download the files

In this section we download the zip file from the provided link and store the data in the *data/* folder.
This file is later extracted using unzip folder and stored in the same directory.The folder structure is
retained.

#### Get the list of relevant files

In this section we fetch the list of files in the project and get rid of all the unnecessary files that are
not need for this assignment. We use grepl method to remove all the unnecessary files. Also we use a method from UtilityFunction.R called **getObjNames**, which returns returns the vector of file names and it is assigned to the *objNames* object.


#### Read and tidy the data

In this section we read all the files in the fileList and eash file is assigned as an object in the *workingList* object. These object are named using *objNames* the previously created section. We use 
custom *trimSpaces* method to remove any unnecessary spaces. Finally we convert each of the objects in the working list as dataframe using custom method *convertToDataFrame*. Both **trimSpaces** and **converToDataFrame** methods are present in *UtilityFunctions.R*

#### Create combined master Data of test and training

In this section to start with master test data is created by combining the columns of subject, activity, type and *X_test*. Similarly we also create master training data by combining the columns of subject, activity, type and *X_train*. Finally we combine these two master data set into one final master data and remove these temporary master data variables.

#### Add variable names and descriptive activity variables

In this section we add column names to the **masterData** and **activity_lables** (in workingList) objects. We merger **masterData** and **activity_lables** to update **masterData** with descriptive activity names as an additional columns.

#### Create data subset with only mean and std measurements

In this section we create a logical object that gives true when col name contains Mean or Std (Standard Deviation) or if column name contains Subject and Activity column Names. We also set this logical to false for the *ActivityId* column as we do not need this column. Finally, we use this logical object to subset the data that contains the relevant variables.

#### Create mean data by subject and activity

In this final section we coerce the measurement columns to numeric and use *aggregate* method to create a **SummarySubSet** object which contains mean of measurement values in dataSubSet and that are grouped by Activity and Subject.

