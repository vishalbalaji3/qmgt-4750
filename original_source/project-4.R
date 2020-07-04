###############################################################
## QMGT-4750-01                                              ##
## Project 4                                                 ##
##                                                           ##
## Written: 2020-04-23             Last revision: 2020-04-23 ##
## Vishal Balaji                                Revision: 01 ##
###############################################################


# Packages -----------------------------------------------------------

install.packages("tidyverse")
library(tidyverse)

install.packages("lubridate")
library(lubridate)

install.packages("mosaic")
library(mosaic)

# Preliminaries -----------------------------------------------------------

setwd("F:/Google Drive/Classes/2020 Spring/data analysis")
getwd()

# Image save function
imageDirectory <- "images"
saveInImageDirectory <- function(filename){
  imageFile <- file.path(imageDirectory, filename)
  ggsave(imageFile, width = 30, height = 20, units = "cm", dpi = 300)
}

# Scatter Plot Theme 
scatterPlotter <- list(xlab("Date"),
                ylab("Price Change"),
                theme_minimal(),
                theme(plot.title = element_text(color = "grey25", size = 20, face = "bold")),
                geom_point(size = 2, alpha = 1/5)
             )

# Data -----------------------------------------------------------------

stocksData <- read_csv("Data/Stock_Comparison_Data.csv", 
                      col_types = cols(
                        date = col_date("%m/%d/%Y"),
                        Amazon_Price_Change = col_double(),
                        Starbucks_Price_Change = col_double(),
                        Coke_Price_Change = col_double()
                        ))


# Scatter plots -----------------------------------------------------------

amazonScatterPlot <- ggplot(stocksData, aes(date, Amazon_Price_Change)) + 
  scatterPlotter + ggtitle("Amazon Stock Price Change")
saveInImageDirectory("Amazon Scatter Plot - Vishal Balaji.png")

starbucksScatterPlot <- ggplot(stocksData, aes(date, Starbucks_Price_Change)) + 
  scatterPlotter + ggtitle("Starbucks Price Change")
saveInImageDirectory("Starbucks Scatter Plot - Vishal Balaji.png")

cokeScatterPlot <- ggplot(stocksData, aes(date, Coke_Price_Change)) + 
  scatterPlotter + ggtitle("Coke Price Change")
saveInImageDirectory("Coke Scatter Plot - Vishal Balaji.png")


# Yearly Average Price Changes --------------------------------------------

yearlyPriceChange <- stocksData %>% 
  mutate(date = year(date)) %>% 
  group_by(date) %>% 
  summarise(
    Amazon_Price_Change = mean(Amazon_Price_Change, na.rm = TRUE),
    Starbucks_Price_Change = mean(Starbucks_Price_Change, na.rm = TRUE),
    Coke_Price_Change = mean(Coke_Price_Change, na.rm = TRUE)
    )

# Average increase or decrease ---------------------------------------------

# Yearly
yearlyAvgIncDec <- mutate(yearlyPriceChange,
            Amazon_Price_Change = derivedFactor(
              "Increase" = (Amazon_Price_Change > 0), 
              "Decrease" = (Amazon_Price_Change <= 0), 
              .method = "first", 
              .default = 0
              ),
            Starbucks_Price_Change = derivedFactor(
              "Increase" = (Starbucks_Price_Change > 0), 
              "Decrease" = (Starbucks_Price_Change <= 0), 
              .method = "first", 
              .default = 0
              ),
            Coke_Price_Change = derivedFactor(
              "Increase" = (Coke_Price_Change > 0), 
              "Decrease" = (Coke_Price_Change <= 0), 
              .method = "first", 
              .default = 0
              )
            )

## Transposing yearly average increase or decrease
yearlyAvgIncDec <- yearlyAvgIncDec %>%
     remove_rownames() %>%
     column_to_rownames(var = 'date')
yearlyAvgIncDec <- as.data.frame(t(yearlyAvgIncDec))
yearlyAvgIncDec <- as_tibble(yearlyAvgIncDec, rownames = NA)


# Daily

dailyAvgIncDec <- mutate(stocksData,
            Amazon_Price_Change = derivedFactor(
              "Increase" = (Amazon_Price_Change > 0), 
              "Decrease" = (Amazon_Price_Change <= 0), 
              .method = "first", 
              .default = 0
              ),
            Starbucks_Price_Change = derivedFactor(
              "Increase" = (Starbucks_Price_Change > 0), 
              "Decrease" = (Starbucks_Price_Change <= 0), 
              .method = "first", 
              .default = 0
              ),
            Coke_Price_Change = derivedFactor(
              "Increase" = (Coke_Price_Change > 0), 
              "Decrease" = (Coke_Price_Change <= 0), 
              .method = "first", 
              .default = 0
              )
            )

# Transposing daily average increase or decrease
dailyAvgIncDec <- dailyAvgIncDec %>%
     remove_rownames() %>%
     column_to_rownames(var = 'date')
dailyAvgIncDec <- as.data.frame(t(dailyAvgIncDec))
dailyAvgIncDec <- as_tibble(dailyAvgIncDec, rownames = NA)

# Exporting as CSV
write_csv(yearlyAvgIncDec , path = "Exports/yearly_avg_inc_dec - Vishal Balaji.csv")
### write_csv(dailyAvgIncDec , path = "Exports/yearly_avg_inc_dec - Vishal Balaji.csv")

