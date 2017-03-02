#D.McCabe 2017-02-27
#source("pollutantmean.R");pollutantmean("specdata", "sulfate", 1:10) # [1] 4.064
#source("pollutantmean.R");pollutantmean("specdata", "nitrate", 70:72) ## [1] 1.706
#source("pollutantmean.R");pollutantmean("specdata", "nitrate", 23) # [1] 1.281

pollutantmean<-function(directory,pollutant, id = 1:332)
{
        nData = 0L      # number of readings
        total = 0       # pollutant accumulator [micrograms per cubic meter]
        
        for (iFile in id)
        {
                # ensure directory has no trailing back slash
                dir_str = gsub(pattern = "\\\\$",replacement="",directory)
                
                # helper function - get three digit ID string
                get_id_str<-function(x,pad_to=3)
                {
                        c<-as.character(x)
                        nZero<-max(0,pad_to-nchar(c))
                        lead_0s<-paste0(rep("0",nZero),collapse ='')
                        paste0(lead_0s,c)
                }
                
                # get the file name
                file_path<-paste0(dir_str,"\\\\",get_id_str(iFile),".csv")
                
                # cycle over missing files?!
                if(!file.exists(file_path)){ next }
                
                # load data into memory
                data<-read.csv(file_path)
                
                # accumulate any good monitor pollutant values
                mask<-!is.na(data[[pollutant]])
                nData<-nData + sum(mask)
                total<-total + sum(data[[pollutant]][mask])
        }
        total/nData
}