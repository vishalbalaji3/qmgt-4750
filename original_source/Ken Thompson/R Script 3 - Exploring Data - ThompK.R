###############################################################
## QMGT-4750/QMGT-677                                        ##
## Week 3                                                    ##
## Exploring Data                                            ##
##                                                           ##
## Wickham, H., & Grolemund, G. (2017). R for Data Science,  ##
## O'Reilly Media, Inc: Sebastopol, CA                       ##
##                                                           ##
## ISBN: 978-1-491-91039-9                                   ##
###############################################################

###############################################################
## Check working directory and, if needed, set working directory

getwd()

setwd("C:/Spring20")

rm(list = ls())

###############################################################
###############################################################
## Importing files

## Recall that we can import files of different types.

amazonData<-read.csv("Data/Amazon_Stock_Prices.csv", header = TRUE)
datAmazon<-read.delim("Data/Amazon_Stock_Prices.dat", header = TRUE)
txtAmazon<-read.delim("Data/Amazon_Stock_Prices.txt", header = TRUE)

###############################################################
###############################################################
## Importing files with tidyverse

tidyAmazonData<-read_csv("Data/Amazon_Stock_Prices.csv")
tidyTxtAmazon<-read_delim("Data/Amazon_Stock_Prices.txt", delim = ",")

## The tidyverse has similar functions but with _ rather than .
## within the function name.
##
## When you run read_csv() it prints out a column specification 
## that gives the name and type of each column. 
## This will be useful down the line.

## Advantages:
##    a) read_csv and read_delim are ~10 times faster to run
##       than Base R counterparts
##    b) They produce tibbles (What the heck is a tibble?)
##       - they don't convert character vectors to factors
##       - they don't use row names
##       - they don't munge the column names
##    c) They are more reproducible


###############################################################
###############################################################
## Tibbles
##
## Tibbles are data frames, but they tweak some older behaviours 
## to make life a little easier. R is an old language, and some 
## things that were useful now get in your way. It's difficult 
## to change base R without breaking existing code, so most 
## innovation occurs in packages. The tibble package provides 
## opinionated data frames that make working in the tidyverse a 
## little easier. The tibble package is part of the core tidyverse.
##
## Almost all tidyverse functions (that we'll use) produce tibbles,
## as tibbles are one of the unifying features of the tidyverse. 
## Most other R packages use regular data frames, so you can 
## coerce a data frame to a tibble using as_tibble()

tblAmazon<-as_tibble(amazonData)

## You can create a new tibble from individual vectors with tibble(). 
## tibble() will automatically recycle inputs of length 1, and 
## allows you to refer to variables that you just created.

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

## Some reasons we like tibbles...
## tibble() never changes the type of the inputs 
##    (e.g. it never converts strings to factors!)
## tibble() never changes the names of variables
## tibble() never creates row names

## tibble can have column names that are not valid R variable 
## names, aka non-syntactic names. For example, they might 
## not start with a letter, or they might contain unusual 
## characters like a space. To refer to these variables, 
## you need to surround them with backticks, `

tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb

## Another way to create a tibble is with tribble(), short 
## for transposed tibble. tribble() is customized for data 
## entry in code: column headings are defined by formulas 
## (i.e. they start with ~), and entries are separated 
## by commas. This makes it possible to lay out small 
## amounts of data in easy to read form.


tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)

## What we would have gotten with tibble()

tibble(
  "a", 2, 3.6,
  "b", 1, 8.5
)

## To get the same results with tibble()

tibble(
  x=c("a","b"),
  y=c(2, 1),
  z=c(3.6, 8.5)
)
###############################################################
## Two main differences in the usage of a tibble vs. a classic 
## data.frame: printing and subsetting.  We'll deal more with
## subsetting in a bit.
##
## Tibbles have a refined print method that shows only the first 
## 10 rows, and all the columns that fit on screen. This makes it 
## much easier to work with large data. In addition to its name, 
## each column reports its type.

tidyAmazonData

## To print more (or less) rows:

print(tidyAmazonData, n=20)

print(tidyAmazonData, n=5)

## The abbreviations under the column names describe the type of 
## each variable:
##  
##    int  stands for integers.
##    dbl  stands for doubles, or real numbers.
##    chr  stands for character vectors, or strings.
##    dttm stands for date-times (a date + a time).
##    lgl  stands for logical, vectors that contain only TRUE or FALSE.
##    fctr stands for factors, which R uses to represent 
##          categorical variables with fixed possible values.
##    date stands for dates.

## Interacting with older code
## Some older functions don't work with tibbles. If you encounter 
## one of these functions, use as.data.frame() to turn a tibble 
## back to a data.frame

###############################################################
###############################################################
## dplyr
##
## The dplyr package is another core member of the tidyverse.
##
## The five key dplyr functions that allow you to solve the vast 
## majority of your data manipulation challenges:
##
##    filter():    Pick observations by their values.
##    arrange():   Reorder the rows.
##    select():    Pick variables by their names.
##    mutate():    Create new variables with functions of 
##                   existing variables.
##    summarize(): Collapse many values down to a single summary.

## Each can be used in conjunction with group_by() which changes 
## the scope of each function from operating on the entire dataset 
## to operating on it group-by-group.

###############################################################
## Filter rows with filter()
##
## filter() allows you to subset observations based on their values. 
## The first argument is the name of the data frame. The second and 
## subsequent arguments are the expressions that filter the data frame.

homeSales<-read_csv("Data/2011_Home_Sales.csv")

filter(homeSales, Region == "S")

filter(homeSales, Region == "S",  `Sale Price` > 118000)

filter(homeSales, `Inventory` > 999999)

## If you want to save the result, you'll need to assign it to
## an object.
##
southHighEnd <- filter(homeSales, Region == "S",  `Sale Price` > 118000)

## To use filtering effectively, you have to know how to 
## select the observations that you want using the comparison 
## operators. 
##     >  (greater than)
##     >= (greater than or equal)
##     <  (less than)
##     <= (less than or equal)
##     != (not equal)
##     == (equal)
##
## Do not use = instead of == for comparisons.
filter(homeSales, Region = "S")

## Floating point numbers
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1

## Computers use finite precision arithmetic so remember that 
## every number you see is an approximation. Instead of relying 
## on ==, use near()
near(sqrt(2) ^ 2, 2)
near(1 / 49 * 49, 1)

## Multiple arguments to filter() are combined with "and": 
## every expression must be true in order for a row to be 
## included in the output. For other types of combinations, 
## you'll need to use Boolean operators yourself: 
##     & is "and"
##     | is "or"
##     ! is "not" 

## The following figure shows the complete set of 
## Boolean operations.

library(png) ## Not tidyverse, but useful
boolean<-readPNG('C:/Spring20/Images/Boolean Operations.png')
grid::grid.raster(boolean)

## filters out any homes sold in the NE or MW
regions <- filter(homeSales, Region == "NE" | Region == "MW")

## A useful short-hand for this problem is x %in% y. 
## This will select every row where x is one of the values in y.

NE_MW <- filter(homeSales, Region %in% c("NE", "MW"))

## Remember De Morgan's law: 
## 
## !(x & y) is the same as !x | !y
## !(x | y) is the same as !x & !y


###############################################################
## Arrange rows with arrange()
##
## arrange() works similarly to filter() except that instead of 
## selecting rows, it changes their order. It takes a data frame 
## and a set of column names (or more complicated expressions) 
## to order by. If you provide more than one column name, each 
## additional column will be used to break ties in the values 
## of preceding columns.

homeSales
arrange(homeSales, Region)
arrange(homeSales, Region, `Sale Price`)

## Use desc() to re-order by a column in descending order
arrange(homeSales, desc(Region), `Sale Price`)
arrange(homeSales, Region, desc(`Sale Price`))

###############################################################
## Select columns with select()
##
## You can narrow in on the variables you're actually interested 
## in. select() allows you to rapidly zoom in on a useful 
## subset using operations based on the names of the variables.

companies<-read_csv("Data/crunchbase_monthly_export.csv")

select(companies, name, market, region, funding_total_usd)

select(companies, country_code:city)

select(companies, -(country_code:city))

select(companies, starts_with("f"))

select(companies, ends_with("code"))

select(companies, contains("_"))

## rename() is a variant of select()
rename(companies, stateCode=state_code)

## Another option is to use select() in conjunction with the 
## everything() helper. This is useful if you have a handful of 
## variables you'd like to move to the start of the data frame.

select(companies, city, state_code, country_code, everything())

###############################################################
## Add new variables with mutate()
##
## It is often useful to add new columns that are functions of 
## existing columns. That's the job of mutate().
##
## mutate() always adds new columns at the end of your dataset. 

view(homeSales)

mutate(homeSales, profit = `Sale Price` - Inventory)

## If you only want to keep the new variables, use transmute()

transmute(homeSales, profit = `Sale Price` - Inventory)

###############################################################
## Ranking
##
y <- c(100, 101, 102, 103, 104, 105)
y
min_rank(y)

y <- c(100, 105, 102, 103, 104, 101)
y
min_rank(y)

y <- c(1, 2, 2, 3, 3, 4)
y
min_rank(y)
min_rank(desc(y))

y <- c(100, 101, 102, 103, 104, 105)
y
row_number(y)
         
y <- c(100, 105, 102, 103, 104, 101)
y
row_number(y)

y <- c(1, 2, 3, 4, 5, 6)
y
percent_rank(y)
cume_dist(y)

y <- c(1, 2, 2, 3, 3, 4)
y
percent_rank(y)
cume_dist(y)

###############################################################
## Grouped summaries with summarize()
##
## summarise() collapses a data frame to a single row

summarize(homeSales, price = mean(`Sale Price`, na.rm = TRUE))

summarize(group_by(homeSales, Region), price = mean(`Sale Price`, na.rm = TRUE))

summarize(group_by(homeSales, Region, `Home Type`), price = mean(`Sale Price`, na.rm = TRUE))

summarize(group_by(homeSales, `Home Type`, Region), price = mean(`Sale Price`, na.rm = TRUE))


###############################################################
## Combining multiple operations with the pipe
##
##
library(nycflights13)

View(flights)

## Let's say we want to explore the relationship between the 
## distance and average delay for each location in the flights
## data.

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")


ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

###############################################################
## There were three steps to prepare this data:
##  
##   1) Group flights by destination.
## 
##   2) Summarize to compute distance, average delay, and number 
##      of flights.
## 
##   3) Filter to remove noisy points and Honolulu airport, 
##      which is almost twice as far away as the next closest 
##      airport.
##
## This code is a little frustrating to write because we have to 
## give each intermediate data frame a name, even though we don't 
## care about it. Naming things is time consuming, so this slows 
## down our analysis.
##
## Another way to tackle the same problem with the pipe, %>%
## Pipes are a powerful tool for clearly expressing a sequence 
## of multiple operations. 
##
## The pipe operator %>% will forward the results of one step
## on to the next step.
##
## Pipes allow us to group and then pass that on to be
## summarized, which can then be passed on to be filtered.
## All without having to do each individually.

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

## This focuses on the transformations, not what's being 
## transformed, which makes the code easier to read. You can 
## read it as a series of imperative statements: group, then 
## summarize, then filter. 
## As suggested by this reading, a good way to pronounce %>% 
## when reading code is "then".
##
## The na.rm = TRUE argument removes all missing values 
## prior to computation. All aggregation functions have an 
## na.rm argument. 
##
## If we leave it out, we get a lot of missing values. That's 
## because aggregation functions obey the usual rule of 
## missing values: if there's any missing value in the input, 
## the output will be a missing value. 

flights %>% 
group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))

## By including the na.rm = TRUE argument, all missing values 
## are not included in the calculation.

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

## In this case, where missing values represent cancelled  
## flights, we could also tackle the problem by first 
## removing the cancelled flights. 

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

###############################################################
## Counts
## Whenever you do any aggregation, it's always a good idea 
## to include either a count (n()), or a count of non-missing 
## values (sum(!is.na(x))). That way you can check that you're 
## not drawing conclusions based on very small amounts of data. 
## For example, consider the planes (identified by their tail
## number) that have the highest average delays.

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

## There are some planes that have an average delay of 5 hours 
## (300 minutes), but the plot is misleading. We can get more 
## insight using a scatterplot of number of flights vs. average 
## delay.

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

## There is much greater variation in the average delay when there 
## are few flights. The shape of this plot is very characteristic: 
## whenever you plot a mean (or other summary) vs. group size, 
## the variation decreases as the sample size increases.

## It's often useful to filter out the groups with the smallest 
## numbers of observations, so you can see more of the pattern and 
## less of the extreme variation in the smallest groups. The 
## following code does just that and shows a handy way to
## integrate ggplot2 into dplyr flows (ggplot2 doesn't integrate
## pipes).

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

## Because ggplot doesn't acknowledge pipes, we have to revert 
## to "+".

###############################################################
## Useful summary functions
##
## Measures of location:
##   mean(x) 
##   median(x)
##
## Measures of spread: 
##   sd(x)
##   IQR(x)
##
## Measures of rank: 
##   min(x)
##   quantile(x, 0.25)
##   max(x)
##
## Measures of position: 
##   first(x)
##   nth(x, 2)
##   last(x)
##
## Counts: 
##   n()              #size of the current group 
##   sum(!is.na(x))   #number of non-missing values
##   n_distinct(x)    #number of distinct (unique) values
##   count(x)         #provides a simple count
not_cancelled %>% 
  count(dest)
##   count(x, wt = y) #sums y for each x
not_cancelled %>% 
  count(tailnum, wt = distance)
##
## Counts and proportions of logical values:
##   sum(x > 10)
##   mean(y == 0)
##
## When used with numeric functions, TRUE is converted to 1 
## and FALSE to 0. This makes sum() and mean() very useful: 
## sum(x) gives the number of TRUEs in x, and mean(x) gives 
## the proportion.
##
## How many flights left before 5am? 
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))
# What proportion of flights are delayed by more than an hour?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))


###############################################################
## Grouping by multiple variables
##
## When you group by multiple variables, each summary peels off 
## one level of the grouping. That makes it easy to progressively 
## roll up a dataset.

daily <- group_by(flights, year, month, day)

  (per_day   <- summarise(daily, flights = n()))

     (per_month <- summarise(per_day, flights = sum(flights)))

        (per_year  <- summarise(per_month, flights = sum(flights)))

##################################################################
## !!!!! CAUTION !!!!!                                          ##
## Be careful when progressively rolling up summaries: it's OK  ## 
## for sums and counts, but you need to think about weighting   ##
## means and variances, and it's not possible to do it exactly  ## 
## for rank-based statistics like the median. In other words,   ##
## the sum of groupwise sums is the overall sum, but the median ## 
## of groupwise medians is not the overall median.              ##
##################################################################

## If you need to remove grouping, and return to operations on 
## ungrouped data, use ungroup().

daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights

###############################################################
## Grouped mutates (and filters)
##
## Grouping is most useful in conjunction with summarise(), 
## but you can also do convenient operations with mutate() and 
## filter().

summarize(flights)

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

## Find the worst members of each group
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) <= 10)

## Find all groups bigger than a threshold
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

## Standardize to compute per group metrics
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

## End of script ##
