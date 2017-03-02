#D.McCabe 2017-02-28
#source("complete.R"); complete("specdata", 1) # 1  1  117
#source("corr.R");source("complete.R");cr<-corr("specdata",150); head(cr) ## [1] -0.01896 -0.14051 -0.04390 -0.06816 -0.12351 -0.07589
corr<-function(directory, threshold=0)
{
        # ensure directory has no trailing back slash
        dir_str = gsub(pattern = "\\\\$",replacement="",directory)
        
        # get the file name
        files<-paste(dir_str,list.files(directory),sep = "\\\\")
        
        # prep results
        pollutant_correlations<-numeric()

        # get pollutant correlations
        for (i in 1:length(files))
        {
                # cycle over missing files?!
                if(!file.exists(files[i])){ next }
                
                # load data into dataframe/memory
                data<-read.csv(files[i])
                
                # Append pollutant correlation
                mask<-complete.cases(data)
                completeCase<-data[mask,]
                if (threshold==0 | nrow(completeCase)>threshold)
                {
                        pCor<-cor(completeCase$sulfate,completeCase$nitrate)
                        pollutant_correlations<-append(pollutant_correlations,pCor)
                }
                
        }
        pollutant_correlations
}
