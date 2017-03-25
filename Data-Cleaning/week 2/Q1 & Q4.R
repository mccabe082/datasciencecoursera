#Q1
{
        library(httr)
        library(httpuv)
        
        # 1. Find OAuth settings for github:
        #    http://developer.github.com/v3/oauth/
        oauth_endpoints("github")
        
        # 2. To make your own application, register at at
        #    https://github.com/settings/applications. Use any URL for the homepage URL
        #    (http://github.com is fine) and  http://localhost:1410 as the callback url
        #
        #    Replace your key and secret below.
        myapp <- oauth_app("github",
                           key = "303870c3e6ba6cfb72ab",
                           secret = "f331377f891319b5a6ccde0db67baa87a6be0c37")
        
        # 3. Get OAuth credentials
        github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
        
        # 4. Use API
        
        gtoken <- config(token = github_token)
        req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
        stop_for_status(req)
        content(req)
        
        
        ## OR:
        #req <- with_config(gtoken, GET("https://api.github.com/users/jtleek/repos"))
        #stop_for_status(req)
        #content(req)
        
        content<-content(req)
        for (i in 1:length(content))
        {
                print(paste(i, content[[i]]$name)) #11
        }
        
        print(dataSharingShizzle<-content[[11]]$created_at) # "2013-11-07T13:25:07Z"
}

#Q4.
{
        library(httr)
        library(XML)
        
        url<-"http://biostat.jhsph.edu/~jleek/contact.html"
        dat<-htmlTreeParse(url, useInternalNodes = T)
}
