# D.McCabe 28/02/2017

## Functions which help avoid unessesary repeat calculations of the
## inverse of a matrix.
## A CacheMatrix object is is a data structure (list) for holding
##  a matrix along with it's cached inverse.
## The two functions below are used for construction of
##  CacheMatrix objects and the solving of the inverse.
##
## Usage:
##  rMat <- matrix(rnorm(4*4),nrow = 4,ncol = 4) # generate an R matrix
##  myMat <- makeCacheMatrix(rMat) # assigns a Casche Object to myMat
##  print( cacheSolve(myMat) )     # get & print the inverse of rMat
##

## constructs a new CacheMatrix (list) object from an R matrix
makeCacheMatrix <- function(x = matrix())
{
        i <- NULL
        set <- function(mat)
        {
                if(class(mat)!="matrix")
                {
                        # ugly R style behaviour on error
                        warning("'makeCacheMatrix$set' expecting matrix!")
                        x<<-matrix()
                }
                else
                {
                        x<<-mat
                }
                i <<- NULL
        }
        get <- function(){ return(x) }
        setinverse <- function(inv){ i<<-inv }
        getinverse <- function(){ return(i) }
        
        # return the CacheMatrix object
        list(set = set, get = get,
             setinverse = setinverse,
             getinverse = getinverse)
}


## returns the inverse of the matrix in a CacheMatrix list object.
## - returns a cached inverse when available,
## - otherwise returns a calaculated inverse which gets cached
cacheSolve <- function(x, ...)
{
        i <- x$getinverse()
        if(!is.null(i))
        {
                message("getting cached data")
                return(i)
        }
        rMat<-x$get()
        i<-solve(rMat,...)
        x$setinverse(i)
        return(i)
}
