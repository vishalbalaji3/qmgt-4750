###############################################################
## QMGT-4750-01                                              ##
## Project 1                                                 ##
##                                                           ##
## Written: 2020-03-30             Last revision: 2020-03-31 ##
## Vishal Balaji                                Revision: 02 ##
###############################################################

require(timeDate)

setwd("/Users/artlab/Desktop/Vishal Balaji/Data analysis")
getwd()

set.seed(11564)

# Days
salesDay <- as.Date(seq(7*12), origin = "2020-03-29")
salesDay <- salesDay[isWeekday(salesDay)]
weekdays(salesDay)

# Random Sales and Costs
dailySales <- rnorm(60, mean = 6755, sd = 321)
dailyCost <- rnorm(60, mean = 6755-1000, sd = 321+50)

# Data frame creation
weeklySales <- data.frame(salesDay, dailySales, dailyCost)
dailyProfit <- weeklySales$dailySales - weeklySales$dailyCost
weeklySales$dailyProfit <- dailyProfit
names(weeklySales) <- c("Sales Days", "Daily Sales", "Daily Costs", "Daily Profits")

# Logical Vector - Is there a loss?
isLoss <- weeklySales$dailyProfit < 0
isLoss