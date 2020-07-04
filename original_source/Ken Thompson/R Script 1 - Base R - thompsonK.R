###############################################################
## QMGT-4750/QMGT-677                                        ##
## Week 1                                                    ##
## Base R                                                    ##
##                                                           ##
## Wickham, H., & Grolemund, G. (2017). R for Data Science,  ##
## O'Reilly Media, Inc: Sebastopol, CA                       ##
##                                                           ##
## ISBN: 978-1-491-91039-9                                   ##
###############################################################

###############################################################
###############################################################
## Before you start, a few important reminders:
##
## 1. R is case-sensitive.  That is, Statistics is not the same 
##    as statistics.
##
## 2. Spelling matters.  
##         - If you misspell something, R doesn't know what you're 
##           asking for.
##         - R doesn't understand social media shortcuts.












###############################################################
###############################################################
## Comments
##
## 1. The comment character in R is #.  Each commented line must 
##    be preceded by a '#' symbol and nything following a # is
##    considered a comment.
##
## 2. There are no block comments in R.
##
## 3. Comments are not evaluted when you run your code.
##
## 4. Two important uses of comments:
##    a) Documenting your syntax.
##    b) Excluding problematic lines of code when debugging
##
##           When debugging, commenting out parts of your code, 
##           rather than deleting them, will save you tons of time
















###############################################################
###############################################################
## Set the working directory 
##
## Every R session is associated with a 'working directory'
## The working directory is the directory that R will use to 
## read or write data objects to or from disk.
##
## You mus to specify the directory where your files are 
## located.
## Use setwd() to do this.  
## Note:  Remember to change all \ to /.  Also, remember to 
## enclose in quotes.
##
# setwd("H:/Personal Folders - FacStaff/thompkl1/stats")
# setwd("M:/stats")
 setwd("C:/Spring20")
##
## You can check to see what your current working directory is 
## using getwd()
##
 getwd()
 
 

###############################################################
###############################################################
## EXPRESSIONS 
 
## The simplist expressions are constants  
 
 4
 "cat"
 10:89
 
 
## Expressions may include operators
 
 3 + 2
 3 - 2
 3 * 2
 3 / 2
 3^2
 
 
## The ":" is an operator
 2:6
 
## Anything that happens in R is a function
## Operators are functions
## `+`
## `-`
## `*`
## `/`
## `^`
## `:`
 
 
 
 
 
 
 
 
 




###############################################################
###############################################################
## Data Objects
##
## Expressions can be assigned to objects by using the ASSIGNMENT 
## operator and specifying a name for the object.
##
## Commands in R are made of two parts: Object and Functions.
## Objects and functions are separated by the 'assignment' o
## perator <-
##
## What is to the left of <- is "created from" whatever is on 
## the right.
##
## Commands take the form:
##
## Object <- Function
##
## To do anything useful in R, we need to create objects to hold 
## the data
 
 x1 <- 4
 x2 <- 4 + 5
 x3 <- "cat"
 x4 <- 2:6
 
## Use str() View() and summary() function to explore data objeccts
 str(x1)
 View(x3)
 summary(x2)
 summary(x3)

## Use typeof() and class() to learn more about objects
 typeof(x2)
 class(x2)
 
 typeof(x3)
 class(x3)
 
 typeof(str)
 class(View)
 
 help(typeof)
 
## R has some built-in data objects
 letters
 pi
 
## Object names must begin with a letter
 my1X <- pi
 my1X
 
#1X <- pi # Uh-oh :(
 
## The good, the bad, and the ugly
 y <- 7
 x = 33.33
 "Bob" -> z
 
## Everything that happens in R is a function
## The "default" function is print()
## The default location of print() is the screen
 
## Evaluating an object name without assignment passes the result 
## to the default print() function, so we see the value on the screen
 
 y
 x
 z
 
## Expressions can also include names of existing data objects
 w <- y
 w
 
 w <- y + 4
 w
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

###############################################################
###############################################################
## R's Mathematical Operators 
##
## Addition
 y + x  

## Subtraction
 y - x 

## Multiplication
 y * x 

## Division
 y / x 
 
 
## Powers - x^n will raise x to the nth power
 3^2
 y^2 # square y
 y^3 # cube y
 
## Roots
 sqrt(y) # function that returns square root of its argument
 y^.5
 y^(1/2)
 
## For nth roots with n > 2, use fractional exponents
 y^(1/3) # cube root of y
 y^(1/4) # quartic root of y
 
## Logarithms and anti-logs
 log(y)   # function for natural logarithm
 log10(y) # function for base 10 log
 log2(y)  # function for base 2 log
 
 exp(x) # function to exponentiate its argument
 
## Absolute value of the argument
 abs(y) 
 
## Modulo operator - remainder after dividing x by y
 x %% y 
 x/y
 
## Integer arithmetic - drops any decimal value
 7 %/% 3 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
############################################################### 
###############################################################
## Logical Comparisons 
 
 y <- 5
 x <- 7
 w <- 5
 
## Check equality
 y == x
 y == w
 
## Check relative size
 y >  x # greater than
 y >= x # greater than or equal to
 y <  x # less than
 y <= x # less than or equal to
 
 y >  w
 y >= w
 y <  w
 y <= w

 
## We can negate any logical condition by prepending 
## a '!' character
## ! is the NOT operator, != tests for not equal
 y
 !y
 
  y > x
 !y > x
 
## Is ! or > done first?
 !(y  > x)
 (!y) > x
 
 y == w
 y != w
 
## We can create more complex logical conditions with the AND and OR operators:
## '&' is the AND operator
## '|' is the OR operator
 y == w & y < x
 y == w & y > x
 y == w | y > x
 
## Logical operators also work with text
 "cat" == "cat"
 "cat" == "dog"
 
 c1 <- "cat"
 c1 == "cat"
 
 "dog" > "cat"
 
############################################################### 
###############################################################
## Order of Operations 
## 
## R will mostly follow the usual PEMDAS ordering for 
## mathematic operations
##
## PEMDAS - Parentheses, Exponents, Multiplication/Division, 
## Addition/Subtraction
## But when in doubt, use parentheses!
 
 y^(1/2)
 y^1/2
 
 y^(1/2) == sqrt(y)
 y^1/2   == y/2
 
 y * 3 / (11 - x)
 y * 3 / 11 - x
 
 z <- y * 3 / 11
 y * 3 / 11 - x == z - x
 
 y + x / w
 (y + x) / w
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Interacting with the Environment
##
## The global environment is the interactive workspace. This is 
## the environment in which you normally work. 
## The parent of the global environment is the last package that 
## you attached with library().
## 
## The base environment is the environment of the base package. 
## Its parent is the empty environment.
## 
## The empty environment is the ultimate ancestor of all 
## environments, and the only environment without a parent.
##
## The global environment is a loosely organized set of all 
## the objects that R currently has stored in memory
## 
## Several functions work with the environment.
## 
## Check the contents of the current environment:
 ls()
 
## Remove an object from the environment
 rm(x)
 ls()
 
## (Nearly) totally clear the enviroment
 rm(list = ls())
 ls()
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## R is VECTORIZED
 
 x1 <- 4
 x2 <- 2:6
 x3 <- c(1,5,9) # c() combines expressions given as arguments into vector or list
 x4 <- c(2,4,2)
 
 x3 + x4
 x3 * x4
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Data frames
##
## Combining vectors into a data frame is a fundamental bridge 
## between programming and statistical analysis.
 data.frame(x3,x4)
 
 df1 <- data.frame(x3, x4)
 df1
 View(df1)
 
## str() returns information about its argument
 
 str(x3)
 str(x3 + x4)
 
## Even objects with a single number/element are vectors
 str(x1)
 
 
## Explore df1
 str(df1)
 nrow(df1)
 length(df1)
 plot(df1)
 typeof(df1)
 class(df1)
 summary(df1)
 View(df1)
 
 edit(df1)
 df2 <- edit(df1)
 df1[2,2]<-6
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Getting help
## 
## Prepending the '?' character will access the help file for a function
 ?c
 
## We can also use the 'help' function
 help(c)
 help("c")
 
## Non-letter characters need to be quoted
# ?/
# help(/)
 ?"/"
 help("/")
 
 
## We can also open an interactive web-based help page
 help.start()
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise 
## Get help on rep() and seq()
##
## 1) Print out a sequence from 12 to 37 counting by 3
## 2) What happens when you run each of the following?
 x <- 23:334
 seq(along.with=x, by=10)
##
## 3) Print out a sequence "1 2 3 1 2 3 1 2 3 1 2 3"
## 4) What happens when you run each of the following?
 rep(seq(2,6,2),times=4)
 rep(c(1,5,9), times=4)
##
## 5) Print out a sequence "1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4"
## 6) What happens when you run each of the following?
 rep(seq(2,6,2),each=4)
 rep(c(1,5,9), each=4)
###############################################################
###############################################################
 
 
 
 
###############################################################
###############################################################
## Exercise Solution
## Get help on rep() and seq()
##
## 1) Print out a sequence from 12 to 37 counting by 3
##
 seq(12,37,by=3)
 seq(from=12,to=37,by=3)
##
## 2) What happens when you run each of the following?
##
 x <- 23:334
 seq(along.with=x, by=10)
##
## 
## 3) Print out a sequence "1 2 3 1 2 3 1 2 3 1 2 3"
##
 rep(1:3,times=4)
##
## 4) What happens when you run each of the following?
## 
 rep(seq(2,6,2),times=4)
##
 rep(c(1,5,9), times=4)
##
##
## 5) Print out a sequence "1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4"
##
 rep(1:3,each=4)
##
##
## What happens when you run each of the following?
##  
 rep(seq(2,6,2),each=4)
##
 rep(c(1,5,9), each=4)
 
###############################################################
###############################################################
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## A closer look at functions
 
## Function Arguments
 
## Four parts of a function
 
## 1. Name (e.g., "abs" or "paste")
##    Arguments have POSITION and NAME
##
 help(ls)
 
 
## 2. Arguments that go into function
 paste("cats","rule")
 paste("cats","rule",sep="--")
 paste("cats","rule",2:5,sep="--")
 
 
 ls()
 ls(pattern="x")
 
## 3 The body of the function that does the work
 paste
 
 ls
 
## 4 The return value that comes out of the function
 help(ls)
 help(c)
 help(str)
 help('+')
 
 
## ... 
 
## Some functions have '...' as an argument. 
## It means multiple/variable number of appropriate arguments.
 
 x3
 sum(x3)
 help(sum)
 
 sum(x3+x4)
 sum(x3,x4)
 
 print(x3 + x4)
 print(x3, x4)
 print(c(x3, x4))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## - concatenating characters or numbers and characters 
 
 paste(x3, x4, sep="with")
 paste(x3, x4, sep="with", collapse="--")
 
 str(paste(x3, x4, sep="with"))
 str(paste(x3, x4, sep="with", collapse="--"))
 
 
## Appearance of a named argument
## = stops the ... 
## Must have =
 
 mySep <- "fred"
 paste(x3, x4, mySep)
 paste(x3, x4, sep=mySep)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## RECYCLING
##   Handling vectors of unequal length
 x1
 x3
 x3 + x1
 
 2:7 + 5:7
 2:4 + 1
 
 2:4 + 1:2
 2:7 + 5:8
 
## Good practice to only recycle with shorter vector of length 1
 data.frame(1:3,2)
 data.frame(a=1:3,g=2)
 data.frame(1:3,2:3)
 
## other recycling can be useful
 data.frame(condition=c(0,1,0,1), sex=c("M","F"))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise
##
## 1) Create two expressions to add the 1st 3 odd numbers with 
##    the 1st 3 even numbers
##
## 2) Create two expressions that divides 10 by 1,2,3,4 respectively
##
###############################################################
###############################################################
 
 
 
 
 
 
 
 
 
 

 
###############################################################
###############################################################
## Exercise Solution
##
## 1) Create two expressions to add the 1st 3 odd numbers with 
## the 1st 3 even numbers
##
 c(1+2,3+4,5+6)
 seq(1,5,by=2) + seq(2,6,by=2)
 ##
 ## Create two expressions that divides 10 by 1,2,3,4 respectively
##
 c(10/1,10/2,10/3,10/4)
 data.frame(10/1:4)
 10/1:4
## 
###############################################################
###############################################################
 
 
 
 
 
 
###############################################################
###############################################################
## COMBINING TEXT - More with paste() 
 
 paste("cats", "and", "dogs")
 paste0("cats", "and", "dogs")
 
 paste(letters,"cat")
 paste0("x",11:20)
 df3 <- mtcars
 names(df3)
 names(df3) <- paste0("x",11:21)
 
 c("a","b","c")
 paste("a","b","c")
 
 str(c("a","b","c"))
 str(paste("a","b","c"))
 
 abc <- c("a","b","c")
 paste(abc, "cat")
 str(paste(abc, "cat"))
 
 paste(abc, "cat", collapse = " ")
 str(paste(abc, "cat", collapse = " "))
 
 paste(abc, "cat", collapse = "-")
 paste(abc, "cat", collapse = ", ")
 
## R will coerce when possible
 paste("cat",21)
 paste(abc,3:4)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
##  Exercise
##
## 1) Create an expression that generate a vector of text v1 v2 v3 v4 ... v9
##
## 2) Create a vector of 3 names, and a vector of 3 ages, and 
##    generate a vector of the form:
##
##  "John is 10 years old"  "Sally is 8 years old"  "Bob is 5 years old"
## 
###############################################################
###############################################################
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
##  Exercise Solution
##
## 1) Create an expression that generate a vector of text v1 v2 v3 v4 ... v9
##
 paste0("v",1:9)
##
## 2) Create a vector of 3 names, and a vector of 3 ages, and 
##    generate a vector of the form:
##
##  "John is 10 years old"  "Sally is 8 years old"  "Bob is 5 years old"
## 
## 
 names <- c("John", "Sally", "Bob")
 ages <- c("10 years old", "8 years old", "5 years old")
 mySep <- " is "
 
 paste(names, ages, sep=mySep)
##
##
## OR ##
##
##
 names <- c("John", "Sally", "Bob")
 ages <- c(10, 8, 5)
 text <- "years old"
 mySep <- " is "
 
 paste(paste(names, ages, sep=mySep), text)
##
###############################################################
###############################################################
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Packages 
##
## Although you can do some stuff using base R, you'll need to 
## use expanded capabilities you get from using "packages".  
## Packages are modules created for specific purposes.
## An R package is a collection of functions, data, and 
## documentation that extends the capabilities of base R. 
## Using packages is key to the successful use of R. 
## 
## To use packages, you need to do two things:
## 1.  Install them  -->> install.packages function
## 2.  Load them  -->> library function
##
## Two ways to install a package:
##
 install.packages("foreign") #Name in quotes
##
## RStudio provides a point-and-click option for installing
## packages
##
## The install.packages function only installs the package.  
## Before you can use it, you must load it.  You only need 
## to install it once, but you must load each time you start 
## an R session (if you plan to use it during that session).
##
## Loading packages
##
 library(foreign) #Name NOT in quotes
##
## Notice that to install the package, the name of the
## package is in quotes, but to initiate the package the
## name is NOT in quotes.


 



















###############################################################
###############################################################
## More on Basic Data Structures
 
## We can make a vector with type equal to any of the six basic vector types
 v1 <- vector("numeric", 3)
 v1
 
 v2 <- vector("integer", 3)
 v2
 
 v3 <- vector("double", 3)
 v3
 
 v4 <- vector("complex", 3)
 v4
 
 v5 <- vector("logical", 3)
 v5
 
 v6 <- vector("character", 3)
 v6
 
 v7 <- vector("raw", 3)
 v7
 
## Default mode for vectors is logical
 x <- vector(length = 5)
 x 
 
 
## More on the combine function.
 
## The combine function 'c()' returns a vector populated by its arguments
 y <- c(1, 2, 3)
 y

 y2 <- c("bob", "suzy", "danny")
 y2
 
 y3 <- c(TRUE, FALSE, TRUE, TRUE)
 y3
 
## We can check the length of a vector with 'length()'
 length(y)
 
## We can check the storage mode of an object with 'mode()'
 mode(y)
 mode(y2)
 mode(y3)
 
## We can check the type of an object with 'typeof()'
 typeof(y) # numeric data is assumed double
 y4 <- c(1L, 2L, 3L)
 y4
 typeof(y4)
 
## The L suffix is a way to designate the integer type.
 
## Clashes of integer and double-precision division result in a double
## Because of coercion
 
 y5 <- y4 / y
 typeof(y5)
 
 y5 + TRUE
 typeof(y5 + TRUE)
 
 
## Arithmetic with vectors works element-wise
 y <- c(1, 2, 3, 4)
 y
 
 x <- rep(2, 4)
 x
 
 x1 <- rep(x=2, times=4)
 x1
 
 x2 <- rep(times=4, x=2)
 x2
 
 x3 <- rep(x=c(1,5,8), times=4)
 x3
 
 
 y + x
 y - x
 y / x
 y * x
 
 y - 1
 y * 3
 y / 3
 
## Elements are recycled (silently) to make the vectors' lengths match
 z <- c(1, 2)
 y - z
 
## We can check logical conditions for each element in the vector by applying
## the logical test to the vector's name
 y == 4
 y == 4 | y == 2
 y == c(4, 2) # Hmm...that's weird. What's going on here?
 
## There are many ways to create vectors:
 y1 <- c(1, 2, 3)
 y1
 
 y2 <- c(1 : 5)
 y2
 
 y3 <- rep(33, 4)
 y3
 
 y4 <- seq(0, 1, 0.25)
 y4
 
## We can access and re-assign values to the vector entries with the '[]'
## operator
 y4[1] <- 77
 y4
 
 y4[3]
 
 y4[c(2, 4)] <- -22
 y4
 
 y4[2, 4] <- 33 # Oops :(
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise
##
##
 set.seed(235710)
 myVec <- sample(1:9, size=4)
 myVec
##
## TASK: Programatically create a logical vector that indicates 
##       which elements of myVec are strictly less than 3.
##
###############################################################
###############################################################
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise Solution
##
##
 set.seed(235710)
 myVec <- sample(1:9, size=4)
 myVec
##
## TASK: Programatically create a logical vector that indicates 
##       which elements of myVec are strictly less than 3.
##
 test <- myVec < 3
 test
##
###############################################################
###############################################################
 
 
 
 
 
 
 
###############################################################
###############################################################
## Matrices
## 
## Matrices are very similar to vectors, but they have two dimensions
 
 m1 <- matrix(1, 2, 3)
 m1
 
 m1 <- matrix(1, 3, 2)
 m1 
 
## matrix(data, # rows, # columns)
 m1 <- matrix(1, 3, 3)
 m1
 
## We can assign values with the '[]' operator here too
 m2 <- matrix(NA, 3, 3)
 m2
 m2[1, 2] <- 33
 m2
 m2[1, 3] <- 44
 m2
 
## Matrices are populated in column-major order, by default
 m3 <- matrix(1:9, 3, 3)
 m3
 
## The 'byrow' option allows us to swith the above to row-major order
 m4 <- matrix(1:9, 3, 3, byrow = TRUE)
 m4
 
## 'length()' of a matrix counts its elements
 length(m4)
 
## We use 'dim()' to get a more sensible measure of dimension
 dim(m4)
 
## Arthmetic is still assumed element-wise
 m4 + m3
 m4 - m3
 m4 / m3
 m4 * m3
 
 t(m5)     # Transpose
 
 y <- rnorm(4)
 y
 
 t(y)
 t(t(y))
 
 is.matrix(y)
 is.matrix(t(y))
 
## We can get a true column vector with 'matrix()'
 matrix(y)
 t(matrix(y))
 
 
 ## We can select a subset of a matrix with the '[]' operator
 m6 <- m5[1 : 2, 1 : 3]
 m7 <- m5[c(1, 3), 2]
 m6
 m7
 
 ## Arithmetic with matrices will also use recycling
 m6 + m7 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Lists
 
 l1 <- list(1, 2, 3)
 l1
 
 l2 <- list("bob", TRUE, 33, 42+3i)
 l2
 
## List elements have no defualt names, but we can include names
 l3 <- list(name = "bob",
            alive = TRUE,
            age = 33,
            relationshipStatus = 42+3i)
 l3
 
 l4 <- list()
 l4$grass   = "green"
 l4$money   = 0
 l4$logical = FALSE
 l4$trivial = function(x) x + 77 - 7 * 11
 l4
 
## The elements inside a list don't really know that they live in a list,
## they'll behave as normal (mostly)
 l4$trivial(32)
 
## We can also assign post hoc names via the 'names()' function
 names(l1) <- c("first", "second", "third")
 l1
 
## We can access and modify the elements of a list via the '$', '[]', and '[[]]'
## operators
 l3$name
 l3[2]
 l3["name"]
 l3[[2]]
 l3[["age"]]
 
 l3[["age"]] <- 57
 l3
 
 l3[["name"]] <- TRUE
 l3
 
 l3[[1]] <- "suzy"
 l3
 
## What's the difference between [] and [[]]?
 class(l3[1])
 class(l3[[1]])
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise
## 
## (a) Create a list to describe yourself. Include the following named
##     elements in your list:
##      (1) Your Name
##      (2) Your Eye Color
##      (3) Your Hair Color
##      (4) Your Favorite Color
##
## (b) Using a single command, test if your eyes OR your hair are your
##           favorite color.
##
###############################################################
############################################################### 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise Solution
## 
## (a) Create a list to describe yourself. Include the following named
##     elements in your list:
##      (1) Your Name
##      (2) Your Eye Color
##      (3) Your Hair Color
##      (4) Your Favorite Color
##
## (b) Using a single command, test if your eyes OR your hair are your
##           favorite color.
##
 me <- list()
 me$name     = "Ken"
 me$eyes     = "blue"
 me$hair     = "grey"
 me$favorite = "blue"
 
 me[2:3] == "blue"
## 
###############################################################
############################################################### 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
##  More on Data Frames
##
##
 d1 <- data.frame(c(1 : 20),
                  c(1, -1),
                  seq(2, 20, 2)
 )
## 
 d2 <- data.frame(x = c(1 : 20),
                  y = c(1, -1),
                  z = seq(2, 20, 2)
 )
## 
 d3 <- data.frame(a = sample(c(TRUE, FALSE), 20, replace = TRUE),
                  b = sample(c("foo", "bar"), 20, replace = TRUE),
                  c = runif(20)
 )
## 
## runif:  generate uniform randum numbers
 
 d4 <- data.frame(matrix(NA, 20, 3))
 
 d1
 d2
 d3
 d4
 
 
## We can extract columns of a data frame with the '$' operator
 d3$b
 str(d3$b)
 
## Data frames are actually lists of vectors (representing the columns)
 is.data.frame(d3)
 is.list(d3)
 
## Although they look like rectangular "matrices," from R's perspective, a data
## frame IS NOT a matrix
 is.matrix(d3)
 
## Transposition "works" but with some unanticipated side-effects
 d1
 t(d1)
 
 class(d1)
 class(t(d1))
 
 d3
 t(d3)
 
 class(d3)
 class(t(d3))
 
 
###############################################################
###############################################################
## Assigning Dimnames
 
## We can assign names to vector and list elements using the 'names()' function
## We can assign row and column names to matrices and data frames using the
## 'rownames()' and 'colnames()' functions, respectively.
 
 v1 <- c(1 : 3)
 v1
 names(v1) <- c("n1", "n2", "n3")
 v1
 
 m1 <- matrix(rnorm(6), 3, 2)
 m1
 colnames(m1) <- c("suzy", "timmy")
 m1
 rownames(m1) <- c("r1", "r2", "r3")
 m1
 
 d1 <- data.frame(matrix(rchisq(6, df = 1), 3, 2))
 d1
 colnames(d1) <- c("cat", "dog")
 d1
 rownames(d1) <- c("r1", "r2", "r3")
 d1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
###############################################################
###############################################################
## Exercise
##
## Create:
 x <- rep(c(TRUE, FALSE), 25)
 y <- rep(1, 50)
 z <- rep(2, 50)
## 
## Create a data frame with 50 rows and 4 columns
## Make the first column the logical negation of x
## Make the second and third columns y and z, respectivly
## Make the fourth column equal y/z (i.e., y divided by z)
## Give the fourth column a name of your choosing
##
###############################################################
###############################################################
 
###############################################################
###############################################################
## Exercise Solution
##
 x <- rep(c(TRUE, FALSE), 25)
 y <- rep(1, 50)
 z <- rep(2, 50)
##
## Create a data frame with 50 rows and 4 columns
## Make the first column the logical negation of x
## Make the second and third columns y and z, respectivly
## Make the fourth column equal y/z (i.e., y divided by z)
## Give the fourth column a name of your choosing
##
 xyz <- data.frame(!x, y, z, div=y/z)
##
###############################################################
###############################################################
 
## End of script ##