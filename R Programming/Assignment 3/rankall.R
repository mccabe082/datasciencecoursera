#print(rankhospital("TX", "heart failure", 4)) #[1] "DETAR HOSPITAL NAVARRO"

## Helper Functions

# returns the appropriate column index for given cause of death
getColumn<-function(ailment,dat)
{
        # get the ailment index
        ailIndex <- if(ailment=="heart attack")
        {
                11 # Hospital 30-Day Death (Mortality) Rates from Heart Attack
        }
        else if (ailment=="heart failure")
        {
                17 # Hospital 30-Day Death (Mortality) Rates from Heart Failure
        } 
        else if (ailment=="pneumonia")
        {
                23 # Hospital 30-Day Death (Mortality) Rates from Pneumonia
        } 
        else
        {
                stop("invalid outcome")
        }
        
        return(names(dat)[ailIndex])
}

sortData<-function(dat,num)
{
        # sort rows by stats then name & drop stat column

        dat<-dat[order(dat[,3],dat[,1]),c(1,2)]
        
        # get desired row
        if(num=="best"){num<-1}
        if(num=="worst"){num<-nrow(dat)}
        if(num>nrow(dat))
        {
                # use the first row (hopefully a there is a state there)
                return(data.frame(Hospital.Name="NA", State=dat[[1,2]]))
        }
        else
        {
                return(dat[num,])
        }
}
## Main Function

# find the best hospital in a state for a given cause of death
rankall <- function(outcome, num = "best")
{
        # load data
        dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        # get column name for cause of death stats.
        column<-getColumn(outcome,dat)
        
        # convert raw ailment stats to numeric
        dat[,column]<-as.numeric(dat[,column])
        
        # take just stats and name columns
        dat<-dat[,c(2,match("State",names(dat)),match(column,names(dat)))]
        
        # get good figures
        dat<-dat[!is.na(dat[,column]),]
        
        # split data by state
        ldata<-split(dat,dat$State)
        ldata<-lapply(ldata,sortData,num)
        
        results<-data.frame(Hospital.Name=character(), State=character())
        for(el in ldata)
        {
                newRow <- data.frame(Hospital.Name=el$Hospital.Name, State=el$State)
                results<-merge(results,newRow,all.x=T,all.y=T,sort = FALSE)
        }
        return(results)
}

print(rankall("heart attack", 20))
