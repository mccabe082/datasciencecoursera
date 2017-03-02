#D.McCabe 2017-02-28
#source("complete.R"); complete("specdata", 1) # 1  1  117
complete<-function(directory, id = 1:332)
{
        completeCaseReport<-data.frame(id=integer(),nobs=integer())
        
        # read files sequentially
        for (i in 1:length(id))
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
                file_path<-paste0(dir_str,"\\\\",get_id_str(id[i]),".csv")
                
                # cycle over missing files?!
                if(!file.exists(file_path)){ next }
                
                # load data into dataframe/memory
                data<-read.csv(file_path)
                
                # Append entry
                mask<-complete.cases(data)
                new_row<-data.frame(id=id[i],nobs=sum(mask))
                completeCaseReport[[i,"id"]]<-id[i]
                completeCaseReport[[i,"nobs"]]<-sum(mask)
        }
        completeCaseReport
}