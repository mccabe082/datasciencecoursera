# Load Dependancies
{
  
  library(data.table)
  library(plyr)
  
}

# Define helper functions
{
  
  # Unfortunately we have to address some duplicate names for the features
  # This function takes a main vector of strings and a vector of n unique tags
  # any instances of exactly n matching string in the main vector recieve
  # trailing tags.  Tagging is sequential e.g.
  #  > tagMatches(c('a','p','p','l','e'),tags=c('1','2'))
  #  [1] "a" "p 1" "p 2" "l" "e" 
  tagMatches<-function(strings,tags=c("X","Y","Z"),sep=" ")
  {
    taggedStrings<-strings; nStr<-length(taggedStrings)
    
    if(any(duplicated(tags)))
    {
      warning("tags are not unique")
      return(strings)
    }
    
    for (i in seq(nStr))
    {
      matched<-taggedStrings[i]==taggedStrings
      if (sum(matched)==length(tags))
        taggedStrings[matched]<-paste(taggedStrings[matched],tags,sep=sep)
    }
    
    return(taggedStrings)
  }
  
}


#1. Merge the training and the test sets to create one data set called d
#3. Ensure descriptive activity names in the data set
{
  # Read in testing and training activity classification data
  # concatenate the two datasets 
  {
    activityKey<-read.table(
      file = "./UCI HAR Dataset/activity_labels.txt",
      stringsAsFactors = FALSE,
      col.names = c("level","label")
    )
    ytest<-fread(
      input = "./UCI HAR Dataset/test/y_test.txt",
      col.names = c("activity")
    )
    ytrain<-fread(
      input = "./UCI HAR Dataset/train/y_train.txt",
      col.names = c("activity")
    )
    y<-rbind(ytest,ytrain)
    y$activity<-factor(
      x = y$activity
      ,levels = activityKey$level
      ,labels = activityKey$label
    )
    rm(activityKey,ytest,ytrain)
  }
  
  # Read in testing and training feature data
  # concatenate the two datasets 
  {
    featureKey<-read.table(
      file = "./UCI HAR Dataset/features.txt"
      ,stringsAsFactors = FALSE
      ,col.names = c("level","label")
    )
    
    # addressing duplicate column name issue:
    # tag trios with X',Y' & Z' trailing tags - distinct from X,Y & Z axis?
    featureKey$label<-tagMatches(featureKey$label,tags=c("X'","Y'","Z'"))
    
    xtest<-fread(
      input = "./UCI HAR Dataset/test/X_test.txt"
      ,col.names = featureKey$label
    )
    subjectTest<-fread(
            "./UCI HAR Dataset/test/subject_test.txt"
            ,col.names = c("subject")
    )
    xtest<-cbind(subjectTest,xtest)
    
    xtrain<-fread(
      input = "./UCI HAR Dataset/train/X_train.txt"
      ,col.names = featureKey$label
    )
    subjectTrain<-fread(
            "./UCI HAR Dataset/train/subject_train.txt"
            ,col.names = c("subject")
    )
    xtrain<-cbind(subjectTrain,xtrain)
    x<-rbind(xtest,xtrain)
    
    rm(featureKey,tagMatches,xtest,xtrain,subjectTrain,subjectTest)
    
  }
  
  
  # Merge activity classification labels with the feature data
  {
    d<-cbind(y,x)
    rm(x,y)
  }
}




# Produce a suplementary summary dataset
{
  #2. Extracts only the measurements on the mean and standard deviation for each measurement
  {
    surplusColumns<-names(d)[!grepl("(activity|subject|mean|std)", names(d), perl=TRUE)]
    d[,(surplusColumns) := NULL]
    rm(surplusColumns)
  }
  
  #5.creates a secondindependent tidy data set showing each variables average for each activity
  id_labels = c("subject", "activity")
  data_labels = setdiff(colnames(d), id_labels)
  melt_d = melt(d, id.vars = id_labels, measure.vars = data_labels)
  meanSummary <- dcast(melt_d, subject + activity ~ variable, mean)
  
}

write.table(meanSummary,file="meanSummary.txt",col.names = FALSE, row.names = FALSE)