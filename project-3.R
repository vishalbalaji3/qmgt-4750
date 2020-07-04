###############################################################
## QMGT-4750-01                                              ##
## Project 3                                                 ##
##                                                           ##
## Written: 2020-04-10             Last revision: 2020-04-10 ##
## Vishal Balaji                                Revision: 01 ##
###############################################################


# Preliminaries -----------------------------------------------------------

install.packages("tidyverse")
library(tidyverse)

setwd("/Users/artlab/Desktop/Vishal Balaji/Data analysis")
getwd()


# Project -----------------------------------------------------------------

# Data
countiesData<- read_csv("Data/US_County_Data.csv")
is_tibble(countiesData)

# Filtering
potentialCounties <- filter(countiesData, At.Least.High.School.Diploma > 80 & Children.Under.6.Living.in.Poverty > 33 & Unemployment >= 0.10 & median_age < 40)
potentialCountiesSummary <- select(potentialCounties, County, Median.Earnings.2010.dollars)
potentialCountiesSummary
