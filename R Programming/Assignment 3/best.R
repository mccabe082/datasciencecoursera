#print(best("TX", "heart attack")) #[1] "CYPRESS FAIRBANKS MEDICAL CENTER"


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



## Main Function

# find the best hospital in a state for a given cause of death
best <- function(state, outcome)
{
        # load data
        dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        # check for valid state
        if (!any(state==unique(dat$State))){stop("invalid state")}
        
        # get column name for cause of death stats.
        column<-getColumn(outcome,dat)
        
        # convert raw ailment stats to numeric
        dat[,column]<-as.numeric(dat[,column])
        
        # get good figures for state
        dat<-dat[ state==dat$State & !is.na(dat[,column]),]
        
        # hospital (row) index with lowest death rate
        iHospital<-which.min(dat[,column])
        
        ## Return hospital name in that state with lowest 30-day death ## rate
        return(dat[[iHospital,"Hospital.Name"]])
}