###############################################################
## QMGT-4750-01                                              ##
## Project 2                                                 ##
##                                                           ##
## Written: 2020-03-31             Last revision: 2020-03-31 ##
## Vishal Balaji                                Revision: 01 ##
###############################################################

require(timeDate)
require(ggplot2)

setwd("/Users/artlab/Desktop/Vishal Balaji/Data analysis")
getwd()

## Image save function
imageDirectory <- "images"
saveInImageDirectory <- function(filename){
  imageFile <- file.path(imageDirectory, filename)
  ggsave(imageFile, width = 30, height = 20, units = "cm", dpi = 300)
}

# Data
dataInput <- "Data/Shop_Data.csv"
shopData <- read.csv(dataInput, colClasses = c(Location = "factor"))

# Jitter Plot
jitterP <- ggplot(shopData, aes(Location, Gross_Profit))
jitterP + geom_jitter(aes(colour = Location)) + 
  ggtitle("Gross Profit by Location Type") + 
  labs(x = "Location", y = "Gross Profit") +
  theme(plot.title = element_text(color = "grey25", size = 24, face = "bold"))
saveInImageDirectory("Gross Profit Jitter – Vishal Balaji.png")

# Bar Graph
bar <- ggplot(shopData, aes(Location))
bar + geom_bar(fill = "tomato3") + 
  ggtitle("Location Types") + 
  labs(x = "Location", y = "Count") +
  theme(plot.title = element_text(color = "tomato3", size = 24, face = "bold"))
saveInImageDirectory("Location Type Bar Chart – Vishal Balaji.png")

# Scatterplot
scatter <- ggplot(shopData, aes(Gross_Profit, Households)) 
scatter + geom_point() + 
  ggtitle("Relationship betweeen Gross Profit and Number of Households") + 
  labs(x = "Gross Profit", y = "Households") +
  theme(plot.title = element_text(color = "grey25", size = 24, face = "bold"))
saveInImageDirectory("Scatterplot – Vishal Balaji.png")