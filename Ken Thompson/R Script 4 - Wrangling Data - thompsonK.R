###############################################################
## QMGT-4750/QMGT-677                                        ##
## Week 4                                                    ##
## Wrangling Data                                            ##
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
## Wrangling Data
##
## Data wrangling is the art of getting your data into R in a 
## useful form for visualization and modelling. Data wrangling 
## is very important: without it you can't work with your own 
## data! There are three main parts to data wrangling:
##
##    1.  Importing the data
##    2.  Tidying the data
##    3.  Transforming the data
##
###############################################################


###############################################################
## Diving deeper into importing files with tidyverse
##
## Recall that importing files through the tidverse there are
## some advantages:
##    a) read_csv and read_delim are ~10 times faster to run
##       than Base R counterparts
##    b) They produce tibbles 
##       - they don't convert character vectors to factors
##       - they don't use row names
##       - they don't munge the column names
##    c) They are more reproducible

tidyAmazonData<-read_csv("Data/Amazon_Stock_Prices.csv")
tidyTxtAmazon<-read_delim("Data/Amazon_Stock_Prices.txt", delim = ",")

## You can also supply an inline csv file. This is useful for 
## creating reproducible examples to share with others.

read_csv("a,b,c
1,2,3
4,5,6")

## The first line of the data for the column names, which is a 
## very common convention.

## Sometimes there are a few lines of metadata at the top of 
## the file. You can use skip = n to skip the first n lines; 
## or, use comment = "#" to drop all lines that start with 
## (e.g.) #.

read_csv("The first line of metadata
          The second line of metadata
  x,y,z
  1,2,3", skip = 2)

## Sometimes, the data might not have column names. You can 
## use col_names = FALSE to tell read_csv() not to treat the 
## first row as headings, and instead label them sequentially 
## from X1 to Xn.

read_csv("1,2,3
         4,5,6", col_names = FALSE)

## You can also pass along  col_names a character vector which 
## will be used as the column names.

read_csv("1,2,3
         4,5,6", col_names = c("Mon", "Wed", "Fri")
         )

## Another option that commonly needs tweaking is na: this 
## specifies the value (or values) that are used to represent 
## missing values in your file.

read_csv("a,b,c
         1,2,.", na = ".")

## Wickham uses "." as a missing value character.
## I don't like "."  Instead, I prefer a numerical 
## representation that would be considered an anomaly in
## my data.

read_csv("a,b,c
         1,2,-99", na = "-99")

read_csv("a,b,c
         1,2,999", na = "999")

## It doesn't really matter here, because you only have a
## limited number of values.  But, when you have a very
## large data set, it gets harder to readily see a . as opposed
## to a number that is obviously wrong.  Develop good 
## habits and be consistent in whatever you do.

###############################################################
## Parsing a vector
##
## The parse_*() functions take a character vector and return  
## a more specialised vector like a logical, integer, or date.

str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2010-01-01", "1979-10-14")))

## Like all functions in the tidyverse, the parse_*() functions 
## are uniform: the first argument is a character vector to 
## parse, and the na argument specifies which strings should be 
## treated as missing.

parse_integer(c("1", "231", "-99", "456"), na = "-99")

## If parsing fails, you'll get a warning.

x <- parse_integer(c("123", "345", "abc", "123.45"))

## If there are many parsing failures, you'll need to use 
## problems() to get the complete set. This returns a tibble, 
## which you can then manipulate.

problems(x)

## Using parsers is mostly a matter of understanding what's 
## available and how they deal with different types of input. 
## These are the most important parsers.
##
##    1.  parse_logical() and parse_integer() parse logicals 
##        and integers respectively. There's basically nothing 
##        that can go wrong with these parsers.
##
##    2.  parse_double() is a strict numeric parser, and 
##        parse_number() is a flexible numeric parser. These are 
##        more complicated than you might expect because different 
##        parts of the world write numbers in different ways.
##
##    3.  parse_character() seems so simple that it shouldn't be 
##        necessary. But one complication makes it quite important: 
##        character encodings.
##
##    4.  parse_factor() create factors, the data structure that 
##        R uses to represent categorical variables with fixed and 
##        known values.
##
##    5.  parse_datetime(), parse_date(), and parse_time() allow 
##        you to parse various date & time specifications. These 
##        are the most complicated because there are so many 
##        different ways of writing dates.

###############################################################
## Numbers

## It seems like it should be straightforward to parse a number, 
## but three problems make it tricky:
##
##    1. People write numbers differently in different parts of 
##       the world. For example, some countries use . in between 
##       the integer and fractional parts of a real number, 
##       while others use ,.
##
##    2. Numbers are often surrounded by other characters that 
##       provide some context, like "$1000" or "10%".
##
##    3. Numbers often contain "grouping" characters to make them 
##       easier to read, like "1,000,000", and these grouping 
##       characters vary around the world.

## To address the first problem, readr (the package in tidyverse
## that we're using) has the notion of a "locale", an object that 
## specifies parsing options that differ from place to place. 
## When parsing numbers, the most important option is the 
## character you use for the decimal mark. You can override the 
## default value of . by creating a new locale and setting the 
## decimal_mark argument.

parse_double("1.23")

parse_double("1,23", locale = locale(decimal_mark = ","))

## parse_number() addresses the second problem: it ignores 
## non-numeric characters before and after the number. This is 
## particularly useful for currencies and percentages, but also 
## works to extract numbers embedded in text.

parse_number("$100")

parse_number("20%")

parse_number("It cost $123.45")

## The final problem is addressed by the combination of 
## parse_number() and the locale as parse_number() will ignore 
## the "grouping mark".

## US-centric
parse_number("$123,456,789")

## European-centric
parse_number("123.456.789", locale = locale(grouping_mark = "."))

## Swiss-centric
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

###############################################################
## Strings

## Intuition would suggest that parse_character() should just 
## return its input. Unfortunately there are multiple ways to 
## represent the same string. To understand what's going on, 
## we need to dive into the details of how computers represent 
## strings. In R, we can get at the underlying representation 
## of a string using charToRaw()

charToRaw("Millsaps")

## Each hexadecimal number represents a byte of information: 
## 4d is M, 69 is i, and so on. The mapping from hexadecimal 
## number to character is called the encoding, and in this 
## case the encoding is called ASCII. ASCII does a great job 
## of representing English characters, because it's the 
## American Standard Code for Information Interchange.
##
## In the early days of computing there were many competing 
## standards for encoding non-English characters, and to 
## correctly interpret a string you needed to know both the 
## values and the encoding.
##
## Today there is one standard that is supported almost 
## everywhere: UTF-8, which can encode just about every 
## character used by humans today, as well as many extra 
## symbols, such as emojis.
##
## readr uses UTF-8 everywhere: it assumes your data is 
## UTF-8 encoded when you read it, and always uses it when 
## writing. This is a good default, but will fail for data 
## produced by older systems that don't understand UTF-8. 
## If this happens, your strings will look weird when you 
## print them. Sometimes just one or two characters might be 
## messed up; other times you'll get complete gibberish. 
##
## For example:

x1 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
x1

## To fix the problem you need to specify the encoding 
## in parse_character():


parse_character(x1, locale = locale(encoding = "Shift-JIS"))

## If you're lucky, the encoding will be included somewhere 
## in the data documentation. Unfortunately, that's rarely 
## the case, so readr provides guess_encoding() to help 
## you figure it out. It's not foolproof, and it works 
## better when you have lots of text (unlike here), but 
## it's a reasonable place to start.

guess_encoding(charToRaw(x1))

###############################################################
## Factors

## R uses factors to represent categorical variables that have 
## a known set of possible values. Give parse_factor() a vector 
## of known levels to generate a warning whenever an unexpected 
## value is present.

fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

###############################################################
## Dates, date-times, and times

## Choose between three parsers depending on whether you want  
## a date (the number of days since 1970-01-01), 
## a date-time (the number of seconds since midnight 1970-01-01), or 
## a time (the number of seconds since midnight). 
##
## When called without any additional arguments:
##
## parse_datetime() expects an ISO8601 date-time. ISO8601 is an 
## international standard in which the components of a date are 
## organized from biggest to smallest: year, month, day, hour, 
## minute, second. ISO8601 is the most important date/time standard.

parse_datetime("2010-10-01T2010")

parse_datetime("20101010")

## parse_date() expects a four digit year, a - or /, the month, 
## a - or /, then the day.

parse_date("2010-10-01")

## parse_time() expects the hour, :, minutes, optionally : 
## and seconds, and an optional am/pm specifier.

library(hms) # Base R doesn't have a great built in class for 
             # time data, so we use the one provided in the 
             # hms package.

parse_time("01:10 am")

###############################################################
## Building your own date-time format

## Year
##  %Y  (4 digits).
##  %y  (2 digits); 00-69 -> 2000-2069, 70-99 -> 1970-1999.
## Month
##  %m (2 digits).
##  %b (abbreviated name, like "Jan").
##  %B (full name, "January").
## Day
##  %d (2 digits).
##  %e (optional leading space).
## Time
##  %H 0-23 hour.
##  %I 0-12, must be used with %p.
##  %p AM/PM indicator.
##  %M minutes.
##  %S integer seconds.
##  %OS real seconds.
##  %Z Time zone (as name, e.g. America/Chicago). 
##
## Beware of abbreviations: if you're American, note that 
## "EST" is a Canadian time zone that does not have daylight 
## savings time; it is not Eastern Standard Time. More on
## this later.
##
##  %z (as offset from UTC, e.g. +0800).
##
##Non-digits
## %. skips one non-digit character.
## %* skips any number of non-digits.
##
## The best way to figure out the correct format is to 
## create a few examples in a character vector, and test with 
## one of the parsing functions. 

parse_date("01/02/15", "%m/%d/%y")

parse_date("01/02/15", "%d/%m/%y")

parse_date("01/02/15", "%y/%m/%d")

## If you're using %b or %B with non-English month names, 
## you'll need to set the lang argument to locale(). 
## See the list of built-in languages in date_names_langs().

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

###############################################################
## Parsing a file

## readr uses a heuristic to figure out the type of each column: 
## it reads the first 1000 rows and uses some (moderately 
## conservative) heuristics to figure out the type of each 
## column. You can emulate this process with a character vector 
## using guess_parser(), which returns readr's best guess, and 
## parse_guess() which uses that guess to parse the column:

guess_parser("2010-10-01")

guess_parser("15:01")

guess_parser(c("TRUE", "FALSE"))

guess_parser(c("1", "5", "9"))

guess_parser(c("12,352,561"))

str(parse_guess("2010-10-10"))

## The heuristic tries each of the following types, 
## stopping when it finds a match:
##
##   logical:   contains only "F", "T", "FALSE", 
##              or "TRUE".
##   integer:   contains only numeric characters 
##              (and -).
##   double:    contains only valid doubles 
##              (including numbers like 4.5e-5).
##   number:    contains valid doubles with the 
##              grouping mark inside.
##   time:      matches the default time_format.
##   date:      matches the default date_format.
##   date-time: any ISO8601 date.
##
## If none of these rules apply, then the column will 
## stay as a vector of strings.
##

## These defaults don't always work for larger files. There are 
## two basic problems:
##
## 1. The first thousand rows might be a special case, and readr 
##    guesses a type that is not sufficiently general. For 
##    example, you might have a column of doubles that only 
##    contains integers in the first 1000 rows.
##
## 2. The column might contain a lot of missing values. If the 
##    first 1000 rows contain only NAs, readr will guess that 
##    it's a logical vector, whereas you probably want to parse 
##    it as something more specific.

## readr contains a challenging CSV that illustrates both of 
## these problems.

challenge <- read_csv(readr_example("challenge.csv"))

x<-problems(challenge)

tail(x)

## That suggests we need to use a date parser instead. 
## To fix the call, start by copying and pasting your 
## original call.

challenge <- read_csv(readr_example("challenge.csv"))

## Add a comma and the column specification from your console
## between the last two parentheses. Then, change "logigal"
## to "date".

challenge <- read_csv(readr_example("challenge.csv"), 
                      cols(
                           x = col_double(),
                           y = col_date()
                           ))

## Add col_types = before cols and run it.


challenge <- read_csv(readr_example("challenge.csv"), 
                      col_types = cols(
                                       x = col_double(),
                                       y = col_date()
                      ))  

tail(challenge)

## In the previous example, if we had looked at just one more 
## row than the default, we would have correctly parsed in one 
## shot.

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2

## Sometimes it's easier to diagnose problems if you just read 
## in all the columns as character vectors

challenge2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
)

## This is particularly useful in conjunction with type_convert(), 
## which applies the parsing heuristics to the character columns 
## in a data frame.

df <- tribble(
  ~x,  ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df

type_convert(df)

type_convert(challenge2)

###############################################################
## Writing to a file

## Thus far, we've read in external files and saved them to an
## internal R data frame or tibble.
##
## readr also comes with two useful functions for writing data 
## back to disk: write_csv() and write_tsv(). Both functions 
## increase the chances of the output file being read back in 
## correctly by:
##    Always encoding strings in UTF-8.
##
##    Saving dates and date-times in ISO8601 format so they are 
##    easily parsed elsewhere.
##
## If you want to export a csv file to Excel, use 
## write_excel_csv() - this writes a special character (a 
## "byte order mark") at the start of the file which tells Excel 
## that you're using the UTF-8 encoding.

write_csv(challenge, "challenge.csv")

write_csv(challenge, "Data/challenge.csv")
##
## The most important arguments are x (the data frame to save), 
## and path (the location to save it). You can also specify 
## how missing values are written with na, and if you want to 
## append to an existing file.
##
## Note that the type information is lost when you save to csv.

write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

## This makes CSVs a little unreliable for caching interim 
## results-you need to recreate the column specification every 
## time you load in. 
##
## There are two alternatives.
##
## write_rds() and read_rds() are uniform wrappers around the 
## base functions readRDS() and saveRDS().  It is only usable
## within R.

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

## The feather package implements a fast binary file format 
## that can be shared across programming languages, but not 
## Excel.

install.packages("feather")
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")

###############################################################
## Other types of data

## haven reads SPSS, Stata, and SAS files.

## readxl reads excel files (both .xls and .xlsx).

## DBI, along with a database specific backend (e.g. RMySQL, 
## RSQLite, RPostgreSQL etc) allows you to run SQL queries 
## against a database and return a data frame.

## For hierarchical data: use jsonlite (by Jeroen Ooms) for json, 
## and xml2 for XML.

###############################################################
###############################################################
## Tidy Data
##
## Tidy data is a consistent way to organize your data in R.
## 
## Getting your data into this format requires some upfront 
## work, but that work pays off in the long term. Once you have 
## tidy data and the tidy tools provided by packages in the 
## tidyverse, you will spend much less time munging data from 
## one representation to another, allowing you to spend more time 
## on the analytic questions at hand.
##
## There are three interrelated rules which make a dataset tidy:
##
##   1. Each variable must have its own column.
##   2. Each observation must have its own row.
##   3. Each value must have its own cell.
##
library(png)
boolean<-readPNG('C:/Spring20/Images/Tidy Data Rules.png')
grid::grid.raster(boolean)

## These three rules are interrelated because it's impossible to 
## only satisfy two of the three. That interrelationship leads to 
## an even simpler set of practical instructions:
##
##   1. Put each dataset in a tibble.
##   2. Put each variable in a column.
##
## Two main advantages to ensuring you have tidy data:
##
##   1. There's a general advantage to picking one consistent 
##      way of storing data. If you have a consistent data 
##      structure, it's easier to learn the tools that work with 
##      it because they have an underlying uniformity.
##
##   2. There's a specific advantage to placing variables in 
##      columns because it allows R's vectorised nature to shine. 
##      Most built-in R functions work with vectors of values. 
##      That makes transforming tidy data feel particularly natural.
##
## A lot of data that you will encounter will be untidy. There are 
## two main reasons:
##
##   1. Most people aren't familiar with the principles of tidy 
##      data, and it's hard to derive them yourself unless you 
##      spend a lot of time working with data.
##
##   2. Data is often organised to facilitate some use other 
##      than analysis. For example, data is often organized to 
##      make entry as easy as possible.
##
## The first step in tidying data is always to figure out what 
## the variables and observations are. Sometimes this is easy; 
## other times you'll need to consult with the people who originally 
## generated the data. The second step is to resolve one of 
## two common problems:
##
##   1. One variable might be spread across multiple columns.
##   2. One observation might be scattered across multiple rows.
##
## Typically a dataset will only suffer from one of these problems. 
## To fix these problems, you'll need the two most important 
## functions in tidyr: pivot_longer() and pivot_wider().
##
## A common problem is a dataset where some of the column names are 
## not names of variables, but values of a variable.

###############################################################
## pivot_longer()

## Consider this data set.
longer <- tibble(
                 `country` = c("Afghanistan", "Brazil", "China") , 
                 `1999` = c(745, 37737, 212258),
                 `2000` = c(2666, 80488, 213766)
                 )
longer

## To tidy a dataset like this, we need to pivot the offending 
## columns into a new pair of variables. To describe that operation 
## we need three parameters:
##
##   1. The set of columns whose names are values, not variables. 
##      In this data set, those are the columns 1999 and 2000.
##
##   2. The name of the variable to move the column names to. In
##      this data frame it is year.
##   3. The name of the variable to move the column values to. In
##      this data frame it is cases.
##

longer %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

###############################################################
## pivot_wider() 

## Consider this data set.

wider <-  read_csv("Data/wider.csv")   
wider

## Similar to make a long data set, we need two parameters:
##
##   1. The column to take variable names from. In this 
##       data set, t's type.
##
##   2. The column to take values from. In this data set it
##      is count.

wider %>%
  pivot_wider(names_from = type, values_from = count)

###############################################################
## separate()

## separate() pulls apart one column into multiple columns, by 
## splitting wherever a separator character appears. 

## Consider this data set.

splitColumn <-  read_csv("Data/separate.csv")   
splitColumn

## The rate column contains both cases and population variables, 
## and we need to split it into two variables. separate() takes 
## the name of the column to separate, and the names of the 
## columns to separate into.

splitColumn %>% 
  separate(rate, into = c("cases", "population"))

splitColumn %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

## You can also pass a vector of integers to sep. separate() 
## will interpret the integers as positions to split at. 
## Positive values start at 1 on the far-left of the strings; 
## negative value start at -1 on the far-right of the strings. 

splitColumn

splitColumn %>% 
  separate(year, into = c("century", "year"), sep = 2)

new <- splitColumn %>% 
           separate(year, into = c("century", "year"), sep = 2) %>%
           separate(rate, into = c("cases", "population"), convert = TRUE)

###############################################################
## unite()

## unite() is the inverse of separate(): it combines multiple 
## columns into a single column. 

new %>% 
  unite(longYear, century, year)

new %>% 
  unite(longYear, century, year, sep = "")


stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

## Changing the representation of a dataset brings up an 
## important subtlety of missing values. A value can be missing 
## in one of two possible ways:
##
##    Explicitly, i.e. flagged with NA.
##    Implicitly, i.e. simply not present in the data.

## Consider the following data set.

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks

## The way that a dataset is represented can make implicit 
## values explicit.

stocks %>% 
  pivot_wider(names_from = year, values_from = return)

## Because these explicit missing values may not be important 
## in other representations of the data, you can set 
## values_drop_na = TRUE in pivot_longer() to turn 
## explicit missing values implicit.

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )

stocks

## Another important tool for making missing values 
## explicit in tidy data is complete().

stocks %>% 
  complete(year, qtr)

## complete() takes a set of columns, and finds all unique 
## combinations. It then ensures the original dataset contains 
## all those values, filling in explicit NAs where necessary.

## Sometimes when a data source has primarily been used for 
## data entry, missing values indicate that the previous value 
## should be carried forward.

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4  
)

## You can fill in these missing values with fill(). It takes 
## a set of columns where you want missing values to be 
## replaced by the most recent non-missing value (sometimes 
## called last observation carried forward).

treatment %>% 
  fill(person)

## Having tidy data does not insinuate all other data are
## "messy" data.  There are lots of useful and well-founded 
## data structures that are not tidy data. Two main 
## possibilities are:
##
##      Alternative representations may have substantial 
##      performance or space advantages.
##
##      Specialised fields have evolved their own conventions 
##      for storing data that may be quite different to the 
##      conventions of tidy data.



###############################################################
###############################################################
## Relational data

## Typically you have many tables of data, and you must combine 
## them to answer relevant questions. Collectively, multiple 
## tables of data are called relational data because the 
## relationship between the individual datasets are important.
## Relations are always defined between a pair of tables. All 
## other relations are built up from this simple idea: the 
## relations of three or more tables are always a property of 
## the relations between each pair.
##
## To work with relational data you need verbs that work with 
## pairs of tables. There are three families of verbs designed 
## to work with relational data:
##
## Mutating joins, which add new variables to one data frame 
## from matching observations in another.
##
## Filtering joins, which filter observations from one data 
## frame based on whether or not they match an observation in 
## the other table.
##
## Set operations, which treat observations as if they were 
## set elements.
##
## The most common place to find relational data is in a 
## relational database management system (or RDBMS), a term 
## that encompasses almost all modern databases (e.g., SQL). 
##

###############################################################
## nycflights13

## We will use the nycflights13 package to learn about 
## relational data. nycflights13 contains tibbles that are 
## related:
##
## - flights
flights
## - airlines lets you look up the full carrier name from its 
##   abbreviated code
airlines
## - airports gives information about each airport, identified 
##   by the faa airport code
airports
## - planes gives information about each plane, identified by 
##   its tailnum
planes
## - weather gives the weather at each NYC airport for each hour
weather

relate<-readPNG('C:/Spring20/Images/Relationships in nycflights13.png')
grid::grid.raster(relate)

## For nycflights13:
  
##   flights connects to planes via a single variable, tailnum.

##   flights connects to airlines through the carrier variable.

##   flights connects to airports in two ways: via the origin 
##   and dest variables.

##   flights connects to weather via origin (the location), and 
##   year, month, day and hour (the time).

###############################################################
## Keys
##
## The variables used to connect each pair of tables are called 
## keys. A key is a variable (or set of variables) that uniquely 
## identifies an observation. In simple cases, a single variable 
## is sufficient to identify an observation. For example, each 
## plane is uniquely identified by its tailnum. In other cases,
## multiple variables may be needed. For example, to identify 
## an observation in weather you need five variables: year, 
## month, day, hour, and origin.
##
## There are two types of keys:

## A primary key uniquely identifies an observation in its own 
## table. For example, planes$tailnum is a primary key because 
## it uniquely identifies each plane in the planes table.
##
## A foreign key uniquely identifies an observation in another 
## table. For example, flights$tailnum is a foreign key because 
## it appears in the flights table where it matches each flight 
## to a unique plane.
##
## A variable can be both a primary key and a foreign key. For 
## example, origin is part of the weather primary key, and is
## also a foreign key for the airport table.
##
## Once you've identified the primary keys in your tables, it's 
## good practice to verify that they do indeed uniquely identify 
## each observation. One way to do that is to count() the primary 
## keys and look for entries where n is greater than one.

planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

## Sometimes a table doesn't have an explicit primary key: each row 
## is an observation, but no combination of variables reliably 
## identifies it. For example, what's the primary key in the flights 
##table? You might think it would be the date plus the flight or tail
## number, but neither of those are unique.

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)

## Turns out, flight numbers are used more than once in a given day.
##
## If a table lacks a primary key, it's sometimes useful to add one 
## with mutate() and row_number(). That makes it easier to match 
## observations if you've done some filtering and want to check back 
## in with the original data. This is called a surrogate key.
##
## A primary key and the corresponding foreign key in another table 
## form a relation. Relations are typically one-to-many. For example, 
## each flight has one plane, but each plane has many flights. In 
## other data, you'll occasionally see a 1-to-1 relationship. You 
## can think of this as a special case of 1-to-many. You can model 
## many-to-many relations with a many-to-1 relation plus a 1-to-many 
## relation. For example, in this data there's a many-to-many 
## relationship between airlines and airports: each airline flies to 
## many airports; each airport hosts many airlines.

###############################################################
## Mutating Joins

## A mutating join allows you to combine variables from two tables. 
## It first matches observations by their keys, then copies across 
## variables from one table to the other.
##
## Like mutate(), the join functions add variables to the right, 
## so if you have a lot of variables already, the new variables 
## won't get printed out. To make it easier to see what's going 
## on in the examples, careate a narrower data set.
##
flights2 <- flights %>% 
select(year:day, hour, origin, dest, tailnum, carrier)
flights2

## To add the full airline name to the flights2 data, combine the 
## airlines and flights2 data frames with left_join().
##
flights2 %>%
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

## The result of joining airlines to flights2 is an additional 
## variable: name.

## In this case, you could have got to the same place using 
## mutate() and R's base subsetting.
flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

###############################################################
## Understanding Joins

joins <- readPNG('C:/Spring20/Images/join-setup.png')
grid::grid.raster(joins)

## The coloured column represents the "key" variable: these are 
## used to match the rows between the tables. The grey column 
## represents the "value" column that is carried along for the ride. 

## Create tribbles to represent the diagram
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

## A join is a way of connecting each row in x to zero, one, 
## or more rows in y.

joins <- readPNG('C:/Spring20/Images/join-setup2.png')
grid::grid.raster(joins)

## Typically, matches are indicated with dots. 
## The number of dots = the number of matches = the number 
## of rows in the output.

## The simplest type of join is the inner join. An inner join 
## matches pairs of observations whenever their keys are equal.

joins <- readPNG('C:/Spring20/Images/join-inner.png')
grid::grid.raster(joins)

## The output of an inner join is a new data frame that  
## contains the key, the x values, and the y values. We use  
## by to tell dplyr which variable is the key.

x %>% 
  inner_join(y, by = "key")

## The most important property of an inner join is that 
## unmatched rows are not included in the result. This means 
## that generally inner joins are usually not appropriate for 
## use in analysis because it's too easy to lose observations.

## An outer join keeps observations that appear in at least one 
## of the tables. There are three types of outer joins:
##
##    A left join keeps all observations in x.
##    A right join keeps all observations in y.
##    A full join keeps all observations in x and y.
##
## These joins work by adding an additional "virtual" observation 
## to each table. This observation has a key that always matches 
## (if no other key matches), and a value filled with NA.

joins <- readPNG('C:/Spring20/Images/join-outer.png')
grid::grid.raster(joins)

## The most commonly used join is the left join: you use this 
## whenever you look up additional data from another table, 
## because it preserves the original observations even when 
## there isn't a match. The left join will most likely be your 
## default join.

## Keys are not always unique. There are two possibilities:
##
## 1.  One table has duplicate keys. This is useful when you  
##     want to add in additional information as there is 
##     typically a one-to-many relationship.
joins <- readPNG('C:/Spring20/Images/join-one-to-many.png')
grid::grid.raster(joins)

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, by = "key")

## 2.  Both tables have duplicate keys. This is usually an error 
##     because in neither table do the keys uniquely identify 
##     an observation. When you join duplicated keys, you get 
##     all possible combinations, the Cartesian product.

joins <- readPNG('C:/Spring20/Images/join-many-to-many.png')
grid::grid.raster(joins)

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)

left_join(x, y, by = "key")

## So far, the pairs of tables have always been joined by a 
## single variable, and that variable has the same name in both 
## tables. That constraint was encoded by by = "key". You can 
## use other values for by to connect the tables in other ways.
##
## The default, by = NULL, uses all variables that appear in 
## both tables, the so called natural join. For example, the 
## flights and weather tables match on their common variables: 
## year, month, day, hour and origin.

flights2 %>% 
  left_join(weather)

## A character vector, by = "x". This is like a natural join,
## but uses only some of the common variables. For example, 
## flights and planes have year variables, but they mean
## different things so we only want to join by tailnum.

flights2 %>% 
  left_join(planes, by = "tailnum")

## A named character vector: by = c("a" = "b"). This will match 
## variable a in table x to variable b in table y. The variables 
## from x will be used in the output.

## For example, if we want to draw a map we need to combine the 
## flights data with the airports data which contains the location 
## (lat and lon) of each airport. Each flight has an origin and 
## destination airport, so we need to specify which one we want 
## to join to:

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))

###############################################################
## Filtering Joins
##
## Filtering joins match observations in the same way as 
## mutating joins, but affect the observations, not the 
## variables. There are two types:
##  
## semi_join(x, y) keeps all observations in x that have a
## match in y.
##
## anti_join(x, y) drops all observations in x that have a match 
## in y.
##
## Semi-joins are useful for matching filtered summary tables 
## back to the original rows.
##
## To find the top ten most popular destinations:
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

## Now you want to find each flight that went to one of those 
## destinations. You could construct a filter yourself.
flights %>% 
  filter(dest %in% top_dest$dest)

## But it's difficult to extend that approach to multiple 
## variables. Instead, you can use a semi-join, which connects 
## the two tables like a mutating join, but instead of adding 
## new columns, only keeps the rows in x that have a match in y.
flights %>% 
  semi_join(top_dest)

## Anti-joins are useful for diagnosing join mismatches. For 
## example, when connecting flights and planes, you might be 
## interested to know that there are many flights that don't 
## have a match in planes.
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

## We've been working with data that have been cleaned up so 
## that you'll have as few problems as possible. Your own data 
## is unlikely to be so nice, so there are a few things that you 
## should do with your own data to make your joins go smoothly.
##
## 1. Start by identifying the variables that form the primary 
##    key in each table. You should usually do this based on 
##    your understanding of the data, not empirically by 
##    looking for a combination of variables that give a 
##    uniqueidentifier. If you just look for variables  
##    without thinking about what they mean, you might get 
##    (un)lucky and find a combination that's unique in your 
##    current data but the relationship might not be true in 
##    general.
##
## 2. Check that none of the variables in the primary key are 
##    missing. If a value is missing then it can't identify 
##    an observation.
##
## 3. Check that your foreign keys match primary keys in another 
##    table. The best way to do this is with an anti_join(). 
##    It's common for keys not to match because of data entry 
##    errors. Fixing these is often a lot of work.

##    If you do have missing keys, you'll need to be thoughtful 
##    about your use of inner vs. outer joins, carefully 
##    considering whether or not you want to drop rows that  
##    don't have a match.
##
## Be aware that simply checking the number of rows before and 
## after the join is not sufficient to ensure that your join has 
## gone smoothly. If you have an inner join with duplicate keys 
## in both tables, you might get unlucky as the number of dropped 
## rows might exactly equal the number of duplicated rows.

###############################################################
## Set Operations
##
## The final type of two-table verb are the set operations. 
## Set operations are occasionally useful when you want to 
## break a single complex filter into simpler pieces. All these 
## operations work with a complete row, comparing the values of 
## every variable. These expect the x and y inputs to have the 
## same variables, and treat the observations like sets:
##
##   intersect(x, y): return only observations in both x and y.
##   union(x, y): return unique observations in x and y.
##   setdiff(x, y): return observations in x, but not in y.

df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)

df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

## The four possibilities are:

intersect(df1, df2)

union(df1, df2)

setdiff(df1, df2)

setdiff(df2, df1)

###############################################################
###############################################################
## Strings
##
## You can create strings with either single quotes or double 
## quotes. Unlike other languages, there is no difference in 
## behaviour. Best to always use "", unless you want to create 
## a string that contains multiple ".
string1 <- "This is a string"
string1
string2 <- 'To include a "quote" inside a string, use single quotes'
string2
string3 <- "To include a 'single quote' inside a string, use single quotes"
string3

## If you forget to close a quote, you'll see +, the continuation 
## character.
#string4 <- "This is a string without a closing quote
## If this happen, click in the console, press Escape, and try 
## again.
##
## To include a literal single or double quote in a string you 
## can use \ to "escape" it.
double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

## That means if you want to include a literal backslash, you'll  
## need to double it up: "\\".
x <- c("\"", "\\")
x

## Beware that the printed representation of a string is not the 
## same as string itself, because the printed representation 
## shows the escapes. To see the raw contents of the string, 
## use writeLines().
writeLines(x)

## There are a handful of other special characters. The most 
## common are "\n", newline, and "\t", tab, but you can see 
## the complete list by requesting help on ": ?'"', or ?"'". 

## Multiple strings are often stored in a character vector, 
## which you can create with c()
c("one", "two", "three")

## str_length() tells you the number of characters in a string
str_length(c("a", "R for data science", NA))

## str_c() combines two or more strings
str_c("x", "y")
str_c("x", "y", "z")

## The sep argument controls how they're separated
str_c("x", "y", sep = ", ")

## Use str_replace_na() to print missing values as "NA"
x <- c("abc", NA)
str_c("|-", x, "-|")

str_c("|-", str_replace_na(x), "-|")

## str_c() is vectorised, and it automatically recycles 
## shorter vectors to the same length as the longest
str_c("prefix-", c("a", "b", "c"), "-suffix")

## Objects of length 0 are silently dropped. This is 
## particularly useful in conjunction with if.
name <- "class"
time_of_day <- "evening"
birthday <- FALSE

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, ", ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

## To collapse a vector of strings into a single string, 
## use collapse.
str_c(c("x", "y", "z"), collapse = ", ")

## Use str_sub() to extract parts of a string, . As well as the 
## string, str_sub() takes start and end arguments which give 
## the (inclusive) position of the substring.
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

str_sub(x, -3, -1)

## str_sub() won't fail if the string is too short: it will 
## just return as much as possible.
str_sub("a", 1, 5)

## use the assignment form of str_sub() to modify strings
x
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 2))
y<- str_to_lower(str_sub(x, 1, 1))


## We just used tr_to_lower() to change the text to lower case. 
## You can also use str_to_upper() or str_to_title(). 
## specifying a locale.
str_to_upper(x)
str_to_title(x)

###############################################################
###############################################################
## Matching patterns with regular expressions

## To learn regular expressions, we'll use str_view() and 
## str_view_all(). These functions take a character vector and 
## a regular expression, and show you how they match.

x 
str_view(x, "an")

## . matches any character (except a newline), .i.e. the wild
## card character
str_view(x, ".a.")

## If we need to match the character ".", we need to use an 
## "escape" to tell the regular expression you want to match it 
## exactly, not use its special behaviour. Like strings, 
## regexps use the backslash, \, to escape special behaviour. 
## So to match an ., you need the regexp \.. Unfortunately this 
## creates a problem. We use strings to represent regular 
## expressions, and \ is also used as an escape symbol in 
## strings. So to create the regular expression \. we need the 
## string "\\.".
dot <- "\\."

writeLines(dot)

str_view(c("abc", "a.c", "bef"), "a.c")
str_view(c("abc", "a.c", "bef"), "a\.c")
str_view(c("abc", "a.c", "bef"), "a\\.c")

## Because \ is used as an escape character in regular 
## expressions, you match a literal \ by escaping it. To do so,
## create the regular expression \\. To create that regular 
## expression, you need to use a string, which also needs to 
## escape \. That means to match a literal \ you need to 
## write "\\\\" - you need four backslashes to match one.
x <- "a\\b"
writeLines(x)

#str_view(x, "\")
str_view(x, "\\")
#str_view(x, "\\\")
str_view(x, "\\\\")

## By default, regular expressions will match any part of a 
## string. It's often useful to anchor the regular expression 
## so that it matches from the start or end of the string.
##
## ^ to match the start of the string.
## $ to match the end of the string.
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

## To force a regular expression to only match a complete  
## string, anchor it with both ^ and $.
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")

str_view(x, "^apple$")

## There are a number of special patterns that match more than 
## one character, e.g., ., which matches any character other 
## than a newline. There are four other useful tools:
##
##     \d: matches any digit.
##     \s: matches any whitespace (e.g. space, tab, newline).
##     [abc]: matches a, b, or c.
##     [^abc]: matches anything except a, b, or c.

## Remember, to create a regular expression containing \d or \s, 
## you'll need to escape the \ for the string, so you'll 
## type "\\d" or "\\s".
##
## A character class containing a single character is a nice 
## alternative to backslash escapes when you want to include a 
## single metacharacter in a regex. This may be more readable.
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")
str_view(c("abc", "a.c", "a*c", "a c"), "a\\s")

## This works for most (but not all) regex metacharacters: 
## $ . | ? * + ( ) [ {. Unfortunately, a few characters have 
## special meaning even inside a character class and must be 
## handled with backslash escapes: ] \ ^ and -.

## You can use alternation to pick between one or more 
## alternative patterns. For example, abc|d..f will match 
## either '"abc"', or "deaf". Note that abc|xyz matches abc or xyz 
## but not abcyz or abxyz. Like with mathematical expressions, 
## you can use parentheses to make it clear what you want.
str_view(c("grey", "gray"), "gr(e|a)y")

## Controlling how many times a pattern matches.
##
##    ?: 0 or 1
##    +: 1 or more
##    *: 0 or more

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')

## You can also specify the number of matches precisely:
##    
##    {n}: exactly n
##    {n,}: n or more
##    {n,m}: between n and m
str_view(x, "C{2}")  
str_view(x, "C{2,}")
str_view(x, "C{2,3}")

## By default these matches are "greedy": they will match the 
## longest string possible. You can make them "lazy", matching 
## the shortest string possible by putting a ? after them. This 
## is an advanced feature of regular expressions, but it's useful 
## to know that it exists.
str_view(x, 'C{2,3}?')
str_view(x, 'C[LX]+?')

## A capturing group stores the part of the string matched by 
## the part of the regular expression inside the parentheses. 
## You can refer to the same text as previously matched by a 
## capturing group with backreferences, like \1. For 
## example, the following regular expression finds all fruits 
## that have a repeated pair of letters.


fruit <- c("banana", "coconut", "cucumber", "jujube", "papaya", "salal berry")
str_view(fruit, "(..)(..)", match = TRUE)
str_view(fruit, "(..)\\1", match = TRUE)

## To determine if a character vector matches a pattern, use 
## str_detect(). It returns a logical vector the same length 
## as the input.
x <- c("apple", "banana", "pear")
str_detect(x, "e")

## Remember that when you use a logical vector in a numeric 
## context, FALSE becomes 0 and TRUE becomes 1. That makes 
## sum() and mean() useful if you want to answer questions 
## about matches across a larger vector.

## How many common words start with t?
sum(str_detect(words, "^t"))

## What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))

## When you have complex logical conditions (e.g. match a or b 
## but not c unless d) it's often easier to combine multiple 
## str_detect() calls with logical operators, rather than 
## trying to create a single regular expression. For example, 
## here are two ways to find all words that don't contain any 
## vowels:

## Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")

## Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")

identical(no_vowels_1, no_vowels_2)

## A common use of str_detect() is to select the elements that 
## match a pattern. You can do this with logical subsetting, or 
## the convenient str_subset() wrapper.

words[str_detect(words, "x$")]

str_subset(words, "x$")

## Typically, however, your strings will be one column of a data 
## frame, and you'll want to use filter instead.
df <- tibble(
  word = words, 
  i = seq_along(word)
)

df %>% 
  filter(str_detect(word, "x$"))

## A variation on str_detect() is str_count(): rather than a 
## simple yes or no, it tells you how many matches there are 
## in a string.
x <- c("apple", "banana", "pear")
str_count(x, "a")

## On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

## You can use str_count() with mutate().
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

## Note that matches never overlap. For example, in "abababa", 
## how many times will the pattern "aba" match? Regular 
## expressions say two, not three.
str_count("abababa", "aba")

str_view_all("abababa", "aba")

## To extract the actual text of a match, use str_extract(). 
length(sentences)
head(sentences)


## If we want to find all sentences that contain a color, we 
## first create a vector of color names, and then turn it into 
## a single regular expression
colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse = "|")
color_match

## Now we can select the sentences that contain a color, and 
## then extract the color to figure out which one it is.
has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)


## Note that str_extract() only extracts the first match. We can 
## see that most easily by first selecting all the sentences 
## that have more than 1 match:
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(more, color_match)

## This is a common pattern for stringr functions, because 
## working with a single match allows you to use much simpler 
## data structures. To get all matches, use str_extract_all(). 
##
## It returns a list:
str_extract_all(more, color_match)


## If you use simplify = TRUE, str_extract_all() will return a 
## matrix with short matches expanded to the same length as the 
## longest.
str_extract_all(more, color_match, simplify = TRUE)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)

## You can use parentheses to extract parts of a complex 
## match. For example, imagine we want to extract nouns from 
## the sentences. As a heuristic, we'll look for any word that 
## comes after "a" or "the". To approximate a "word" in a regular 
## expression we'll us a sequence of at least one character that 
## isn't a space.

noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>% 
  str_extract(noun)

## str_replace() and str_replace_all() allow you to replace 
## matches with new strings. The simplest use is to replace 
## a pattern with a fixed string.
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")

str_replace_all(x, "[aeiou]", "-")

## With str_replace_all() you can perform multiple replacements 
## by supplying a named vector.
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

## Instead of replacing with a fixed string you can use 
## backreferences to insert components of the match. The 
#following code flips the order of the second and third words.

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)

## Use str_split() to split a string up into pieces. For example, 
## we could split sentences into words.
sentences %>%
  head(5) %>% 
  str_split(" ")

## Use simplify = TRUE to return a matrix.
sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)

## You can also request a maximum number of pieces.
fields <- c("Class: QMGT", "Night: Monday", "Size: 25")
fields %>% str_split(": ", n = 2, simplify = TRUE)


## Instead of splitting up strings by patterns, you can also
## split up by character, line, sentence and word boundary()s.
x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))

str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]

## str_locate() and str_locate_all() give you the starting and 
## ending positions of each match. These are particularly useful 
## when none of the other functions does exactly what you want. 
## You can use str_locate() to find the matching pattern, 
## str_sub() to extract and/or modify them.

## When you use a pattern that's a string, it's automatically 
## wrapped into a call to regex().
str_view(fruit, "nana")
str_view(fruit, regex("nana"))

## You can use the other arguments of regex() to control details of the match:
## ignore_case = TRUE allows characters to match either their uppercase or 
## lowercase forms. This always uses the current locale.
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

## multiline = TRUE allows ^ and $ to match the start and end of 
## each line rather than the start and end of the complete string.
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

## comments = TRUE allows you to use comments and white space to 
## make complex regular expressions more understandable. Spaces 
## are ignored, as is everything after #. To match a literal 
## space, you'll need to escape it: "\\ ".
phone <- regex("
  \\(?     # optional opening parens
  (\\d{3}) # area code
  [) -]?   # optional closing parens, space, or dash
  (\\d{3}) # another three numbers
  [ -]?    # optional space or dash
  (\\d{3}) # three more numbers
  ", comments = TRUE)

str_match("514-791-8141", phone)

## Three other functions you can use instead of regex()
## fixed(): matches exactly the specified sequence of bytes. It 
## ignores all special regular expressions and operates at a 
## very low level. This allows you to avoid complex escaping 
## and can be much faster than regular expressions. The following 
## microbenchmark shows that it's about 3x faster for a simple 
## example.

microbenchmark::microbenchmark(
                   fixed = str_detect(sentences, fixed("the")),
                   regex = str_detect(sentences, "the"),
                   times = 20
                               )
## coll(): compare strings using standard collation rules. This is 
## useful for doing case insensitive matching. Note that coll() 
## takes a locale parameter that controls which rules are used for 
## comparing characters. Unfortunately different parts of the world 
## use different rules.
i <- c("I", "I", "i", "i")
i

str_subset(i, coll("i", ignore_case = TRUE))
str_subset(i, coll("i", ignore_case = TRUE, locale = "tr"))

## The downside of coll() is speed; because the rules for 
## recognising which characters are the same are complicated, 
## coll() is relatively slow compared to regex() and fixed().


## As you saw with str_split() you can use boundary() to match 
## boundaries. You can also use it with the other functions:
x <- "This is a sentence."
str_view_all(x, boundary("word"))

str_extract_all(x, boundary("word"))

## There are two useful function in base R that also use 
## regular expressions.
  
##apropos() searches all objects available from the global 
## environment. This is useful if you can't quite remember the 
## name of the function.

apropos("extract")

## dir() lists all the files in a directory. The pattern argument 
## takes a regular expression and only returns file names that 
## match the pattern. For example, you can find all the R 
## script files in the current directory with:

head(dir(pattern = "\\.R"))

## stringr is built on top of the stringi package. stringr is 
## useful when you're learning because it exposes a minimal set 
## of functions, which have been carefully picked to handle the 
## most common string manipulation functions. stringi, on the 
## other hand, is designed to be comprehensive. It contains 
## almost every function you might ever need: stringi has 244 
## functions to stringr's 49.

## If you find yourself struggling to do something in stringr, 
## it's worth taking a look at stringi. The packages work very 
## similarly, so you should be able to translate your stringr 
## knowledge in a natural way. The main difference is the 
## prefix: str_ vs. stri_.


###############################################################
###############################################################
## Factors
##
## In R, factors are used to work with categorical variables, 
# variables that have a fixed and known set of possible values. 
## They are also useful when you want to display character 
## vectors in a non-alphabetical order.
##
## Historically, factors were much easier to work with than 
## characters. As a result, many of the functions in base R 
## automatically convert characters to factors. This means that 
## factors often crop up in places where they're not actually 
## helpful. #he tidyverse takes care of that problem.
##
## To work with factors, we'll use the forcats package, which is 
## part of the core tidyverse.

## Imagine that you have a variable that records month.
x1 <- c("Dec", "Apr", "Jan", "Mar")

## It doesn't sort in a useful way.
sort(x1)

## We can fix the problem with a factor. 
## To create a factor, start by creating a list of the valid
## levels.
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

## Now create the factor.
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)

##many values not in the set will be silently converted to NA.
x2 <- c("Dec", "Apr", "Jam", "Mar")
y2 <- factor(x2, levels = month_levels)
y2
y2 <- parse_factor(x2, levels = month_levels)

## If you omit the levels, they'll be taken from the data in 
## alphabetical order.
factor(x1)

## If you want the order of the levels to match the order of the 
## first appearance in the data, create the factor by setting 
## levels to unique(x), or after the fact, with fct_inorder().
f1 <- factor(x1, levels = unique(x1))
f1
f2 <- x1 %>% factor() %>% fct_inorder()
f2

## To access the set of valid levels directly, use levels().
levels(f2)

## When factors are stored in a tibble, you can't easily see 
## their levels. To see them use count() or a bar chart.
gss_cat %>%
  count(race)

ggplot(gss_cat, aes(race)) +
  geom_bar()

## By default, ggplot2 will drop levels that don't have any 
## values. You can force them to display.
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

## It's often useful to change the order of the factor levels in 
## a visualisation. For example, imagine you want to explore the 
## average number of hours spent watching TV per day across 
## religions.
relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

## It is difficult to interpret this plot because there's no 
## overall pattern. We can improve it by reordering the levels 
## of relig using fct_reorder(). 
##
## fct_reorder() takes three arguments:
##
##   f, the factor whose levels you want to modify.
##   x, a numeric vector that you want to use to reorder the 
##      levels.
##   Optionally, fun, a function that's used if there are 
##   multiple values of x for each value of f. The default 
##   value is median.
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

## With more complicated transformations, move them out of aes() 
## and into a separate mutate() step.
relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

## Reserve fct_reorder() for factors whose levels are 
## arbitrarily ordered.

## Consider a similar plot looking at how average age varies
## across reported income level.
rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + 
        geom_point()

## Here, arbitrarily reordering the levels isn't a good idea 
## because rincome already has a principled order that we 
## shouldn't mess with. However, it does make sense to pull 
## "Not applicable" to the front with the other special levels. 
## You can use fct_relevel(). It takes a factor, f, and then 
## any number of levels that you want to move to the front of 
## the line.
ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

## fct_reorder2() reorders the factor by the y values 
## associated with the largest x values. This makes the plot 
## easier to read because the line colours line up with the 
## legend.
by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

## For bar plots, you can use fct_infreq() to order levels in 
## increasing frequency: this is the simplest type of reordering 
## because it doesn't need any extra variables. You may want 
## to combine with fct_rev().
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

## Changing the values of labels allows you to clarify labels 
## for publication, and collapse levels for high-level displays. 
## The most general and powerful tool is fct_recode(). It allows 
## you to recode, or change, the value of each level. 
##
## For example, take gss_cat$partyid.
gss_cat %>% count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

## To combine groups, you can assign multiple old levels to 
## the same new level:
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)

## !! CAUtiON: if you group together categories that are truly 
## !! different you will end up with misleading results.

## If you want to collapse a lot of levels, fct_collapse() is a 
## useful variant of fct_recode(). For each new variable, you 
## can provide a vector of old levels.
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

## Sometimes you just want to lump together all the small groups 
## to make a plot or table simpler. That's the job of 
## fct_lump(). The default behaviour is to progressively lump 
## together the smallest groups, ensuring that the aggregate is 
## still the smallest group.
gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

## we can use the n parameter to specify how many groups 
## (excluding other) we want to keep.
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)

###############################################################
###############################################################
## Dates and Times
##
## The lubridate package makes it easier to work with dates and 
## times in R. lubridate is not part of core tidyverse because 
## you only need it when you're working with dates/times. 
##
install.packages("lubridate")
library(lubridate)
##
## There are three types of date/time data that refer to an 
## instant in time:
##
##      A date. Tibbles print this as <date>.
##
##      A time within a day. Tibbles print this as <time>.
##
##      A date-time is a date plus a time: it uniquely identifies 
##      an instant in time (typically to the nearest second). 
##      Tibbles print this as <dttm>. Elsewhere in , these are 
##      called POSIXct.
##
## You should always use the simplest possible data type that 
## works for your needs. That means if you can use a date 
## instead of a date-time, you should. Date-times are 
## substantially more complicated because of the need to handle 
## time zones.
##
## To get the current date or date-time you can use today() or 
## now().
today()
now()

## Otherwise, there are three ways you're likely to create a 
## date/time:

##      From a string.
##      From individual date-time components.
##      From an existing date/time object.

###############################################################
## Creating a date/time from a string

## Identify the order in which year, month, and day appear in 
## your dates, then arrange "y", "m", and "d" in the same order. 
## gives you the name of the lubridate function that will parse 
## your date.
ymd("2017-01-31")

mdy("January 31st, 2017")

dmy("31-Jan-2017")

## These functions also take unquoted numbers.
ymd(20170131)

## ymd() and friends create dates. To create a date-time, add 
## an underscore and one or more of "h", "m", and "s" to the 
## name of the parsing function
ymd_hms("2017-01-31 20:11:59")

mdy_hm("01/31/2017 08:01")

## You can also force the creation of a date-time from a date by 
##supplying a timezone:
ymd(20170131, tz = "America/Chicago")
    
## Instead of a single string, sometimes you'll have the 
## individual components of the date-time spread across 
## multiple columns.  
flights %>% 
  select(year, month, day, hour, minute)   

## To create a date/time from this sort of input, use make_date() 
## for dates, or make_datetime() for date-times.
flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))

## Let's do the same thing for each of the four time columns in 
## flights:
##          dep_time
##          sched_dep_time
##          arr_time
##          sched_arr_time
## The times are represented in a slightly odd format, so we
## use modulus arithmetic to pull out the hour and minute 
## components. 
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

## An aside...
## time %/% 100 is integer division
## 515 %/% 100 = 5
## time %% 100 is modulo
## 515 %% 100 = 15

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

## Use this data to visualize the distribution of departure times 
## across the year.
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day

## Or within a single day.
flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes

## You may want to switch between a date-time and a date. 
## That's the job of as_datetime() and as_date().
as_datetime(today())
as_date(now())

## Sometimes you'll get date/times as numeric offsets from the 
## "Unix Epoch", 1970-01-01. If the offset is in seconds, use 
## as_datetime(); if it's in days, use as_date().

as_datetime(60 * 60 * 10)

as_date(365 * 10 + 2)

## You can pull out individual parts of the date with the 
## accessor functions year(), month(), mday() (day of the month), 
## yday() (day of the year), wday() (day of the week), hour(), 
## minute(), and second().
datetime <- mdy_hms("06-25-1962 12:34:56")

year(datetime)
month(datetime)
mday(datetime)
yday(datetime)

## For month() and wday() you can set label = TRUE to return the 
## abbreviated name of the month or day of the week. Set 
## abbr = FALSE to return the full name.
month(datetime, label = TRUE)
month(datetime, label = TRUE, abbr = FALSE)

wday(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)

## We can use wday() to see that more flights depart during the 
## week than on the weekend.
flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()

## There's an interesting pattern if we look at the average 
## departure delay by minute within the hour.  It looks like 
## flights leaving in minutes 20-30 and 50-60 have much lower 
##delays than the rest of the hour.
flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>% 
  ggplot(aes(minute, avg_delay)) +
  geom_line()

## But, if we look at the scheduled departure time we don't see 
## the same pattern.
sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) 
ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

## An alternative approach to plotting individual components is 
## to round the date to a nearby unit of time, with floor_date(), 
## round_date(), and ceiling_date(). Each function takes a 
## vector of dates to adjust and then the name of the unit round 
## down (floor), round up (ceiling), or round to. This, for example, 
## allows us to plot the number of flights per week:
flights_dt %>% 
  count(week = floor_date(dep_time, "week")) %>% 
  ggplot(aes(week, n)) +
  geom_line()

## You can also use each accessor function to set the components 
## of a date/time.
datetime <- mdy_hms("06-25-1962 12:34:56")

year(datetime) <- 2020
datetime

month(datetime) <- 01
datetime

hour(datetime) <- hour(datetime) + 1
datetime

## Alternatively, rather than modifying in place, you can 
## create a new date-time with update(). This also allows you 
## to set multiple values at once.
update(datetime, year = 2020, month = 2, mday = 2, hour = 2)

## If values are too big, they will roll-over:
ymd("2015-02-01") %>% 
  update(mday = 30)

ymd("2015-02-01") %>% 
  update(hour = 400)

## You can use update() to show the distribution of flights 
## across the course of the day for every day of the year.
flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 300)


###############################################################
## Time Spans - how arithmetic with dates works, including 
## subtraction, addition, and division. 
##
## Three important classes that represent time spans:
##     durations, which represent an exact number of seconds.
##     periods, which represent human units like weeks and 
##     months.
##     intervals, which represent a starting and ending point.

## Durations
## In R, when you subtract two dates, you get a difftime object:
tAge <- today() - ymd(19620625)
tAge/365

## A difftime class object records a time span of seconds, 
## minutes, hours, days, or weeks. This ambiguity can make 
## difftimes a little painful to work with, so lubridate 
## provides an alternative which always uses seconds: the 
## duration.

as.duration(tAge)

## Durations come with a bunch of convenient constructors:


dseconds(15)

dminutes(10)

dhours(c(12, 24))

dweeks(3)

dyears(1)

## You can add and multiply durations:

2 * dyears(1)

dyears(1) + dweeks(12) + dhours(15)

## because durations represent an exact number of seconds, 
## sometimes you might get an unexpected result.

one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/Chicago")

one_pm

one_pm + ddays(1)

## So, hy is one day after 1pm on March 12, 2pm on March 13?
## Notice that the time zones have changed. Because of DST, 
## March 12 only has 23 hours, so if we add a full days worth 
## of seconds we end up with a different time.

## To solve this problem, lubridate provides periods. Periods 
## are time spans but don't have a fixed length in seconds, 
## instead they work with "human" times, like days and months. 
## That allows them work in a more intuitive way:

one_pm

one_pm + days(1)

## Like durations, periods can be created using constructor 
## functions.


seconds(15)

minutes(10)

hours(c(12, 24))

days(7)

months(1:6)

weeks(3)

years(1)

## You can add and multiply periods:

10 * (months(6) + days(1))

days(50) + hours(25) + minutes(2)

## You can add them to dates. 

## A leap year
ymd("2020-01-01") + dyears(1)

ymd("2020-01-01") + years(1)


# Daylight Savings Time
one_pm + ddays(1)

one_pm + days(1)

## In the flight data, some planes appear to have arrived at 
## their destination before they departed from New York City.

flights_dt %>% 
  filter(arr_time < dep_time) 

## These are overnight flights. We used the same date information 
## for both the departure and the arrival times, but these 
## flights arrived on the following day. We can fix this by 
## adding days(1) to the arrival time of each overnight flight.

flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),
    sched_arr_time = sched_arr_time + days(overnight * 1)
  )

## Now all of flights look normal.

flights_dt %>% 
  filter(overnight, arr_time < dep_time) 

## It's obvious that dyears(1) / ddays(365) should return one, 
## because durations are always represented by a number of 
## seconds, and a duration of a year is defined as 365 days 
## worth of seconds.

## What should years(1) / days(1) return? 
## Well, if the year was 2019 it should return 365, but if it was 
## 2020, it should return 366. There's not quite enough 
## information for lubridate to give a single clear answer. 
## Instead, it gives an estimate, with a warning
  
years(1) / days(1)

## To get a more accurate measurement, you'll have to use an 
## interval. An interval is a duration with a starting point 
## making it precise so you can determine exactly how long it is.
  
next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)

## To find out how many periods fall into an interval, 
## you need to use integer division.
  
  (today() %--% next_year) %/% days(1)

## How do you pick between duration, periods, and intervals? 
## As always, pick the simplest data structure that solves 
## your problem. 
## If you only care about physical time, use a duration.
## If you need to add human times, use a period.
## If you need to figure out how long a span is in human units, 
## use an interval.

## The following summarizes permitted arithmetic operations 
## between the different data types.

dates <- readPNG('C:/Spring20/Images/datetimes-arithmetic.png')
grid::grid.raster(dates)

###############################################################
## Time Zones
##
## Time zones are an enormously complicated topic because of 
## their interaction with geopolitical entities.
## Everyday names of time zones tend to be ambiguous. For example, 
## American has EST, or Eastern Standard Time. However, both 
## Australia and Canada also have EST.
## To avoid confusion, R uses the international standard IANA 
## time zones.  Typically, typically they are in the form 
## "<continent>/<city>", such as America/New_York or 
## America/Chicago.

## To find what R thinks your current time zone is use 
Sys.timezone().

## If R doesn't know, you'll get an NA.

## To see the complete list of all time zone names, use 
OlsonNames()

length(OlsonNames())

## In R, the time zone is an attribute of the date-time that 
## only controls printing. For example, these three objects 
## represent the same instant in time:
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))

(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))

(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))

## You can verify that they're the same time using subtraction:
x1 - x2

x1 - x3

x2 - x3

## Unless otherwise specified, lubridate always uses UTC. 
## UTC (Coordinated Universal Time) is the standard time zone 
## used by the scientific community and roughly equivalent to 
## its predecessor GMT (Greenwich Mean Time). It does not have 
## DST, which makes a convenient representation for computation. 
## Operations that combine date-times, like c(), will often 
## drop the time zone. In that case and the date-times will 
## display in your local time zone.

x4 <- c(x1, x2, x3)
x4

## You can change the time zone in two ways:
## Keep the instant in time the same, and change how it's 
## displayed. Use this when the instant is correct, but you 
## want a more natural display.
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe")
x4a

## Change the underlying instant in time. Use this when you have 
## an instant that has been labelled with the incorrect time zone, 
## and you need to fix it.
x4b <- force_tz(x4, tzone = "Australia/Lord_Howe")
x4b

## End of script ##