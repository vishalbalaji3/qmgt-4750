###############################################################
## QMGT-4750/QMGT-677                                        ##
## Week 2                                                    ##
## Elements of R - Data Visualization                        ##
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

## Most often, you have data in other formats that you need 
## to import into R rather than entering it directly.

## Importing CSV files
amazonData<-read.csv("Data/Amazon_Stock_Prices.csv", header = TRUE)
lecturerData$job<-factor(lecturerData$job, levels = c(1:2), 
                         labels = c("Lecturer", "Student"))

## Importing delimited files
datAmazon<-read.delim("Data/Amazon_Stock_Prices.dat", header = TRUE)
txtAmazon<-read.delim("Data/Amazon_Stock_Prices.txt", header = TRUE)


## Although we won't have a need to import them, you can import files
## from other statistical software packages.

library(foreign)
spsAmazon<- read.spss("Data/Amazon_Stock_Prices.sav",use.value.labels=TRUE, to.data.frame=TRUE)


###############################################################
###############################################################
## tidyverse
## https://www.tidyverse.org/

###############################################################
###############################################################
## ggplot2 

## ggplot2 is one of the packages included with tidyverse.
## Althought R has several systems for making graphs, ggplot2 is  
## one of the most elegant and most versatile. 
## ggplot2 implements the grammar of graphics, a coherent system 
## for describing and building graphs. With ggplot2, you can do 
## more faster by learning one system and applying it in many places.

###############################################################
###############################################################
## Create a directory to store your graphs/images.
## First, create a subfolder in stats named "images".

imageDirectory<-"C:/Spring20/images"


###############################################################
###############################################################
## Create a function to make it quick to save graphs in the image directory

saveInImageDirectory<-function(filename){
  imageFile <- file.path(imageDirectory, filename)
  ggsave(imageFile)	
}

###############################################################
###############################################################
## Creating graphs with ggplot2

## Import data
patientData <- read.csv("Data/Patient_Data.csv",  header = TRUE)

## What's in the data?
summary(patientData)

## ggplot2 can be used to build a graph.  
##
## With ggplot2, you can independently specify the 
## building blocks of a graph, including:
##      Data (what data are we using?)
##      Aesthetic mappings (how do we want the graph to appear?)
##      Geometric objects (what type of graph are we creating?)
##      Statistical transformations
##      Scales
##      Coordinate systems
##      Position adjustments
##      Faceting 


ggplot(data = patientData) + 
  geom_point(mapping = aes(x = Marital_Status, y = Weight))

## With ggplot2, you begin a plot with the function ggplot(). 
## ggplot() creates a coordinate system that you can add layers to. 
## The first argument of ggplot() is the dataset to use in the graph. 
## So ggplot(data = patientData) creates an empty graph, but 
## it's not very interesting 
##
## Complete the graph by adding one or more layers to ggplot(). 
##
## The function geom_point() adds a layer of points to the plot, 
## which creates a scatterplot. 
##
## ggplot2 comes with many geom functions that each add a different 
## type of layer to a plot.
##
## Each geom function in ggplot2 takes a mapping argument. This 
## defines how variables in your dataset are mapped to visual properties. 
## The mapping argument is always paired with aes(), and the x and y 
## arguments of aes() specify which variables to map to the x and y axes. 
#3 ggplot2 looks for the mapped variables in the data argument, 
## in this case, patientData.
##
## Because we tend to reuse the data frame and the variables, we
## can save them to a list and streamline our coding as we add layers.

graph <- ggplot(patientData, aes(Marital_Status, Weight))

## Now, instead of
## ggplot(data = patientData) + 
## geom_point(mapping = aes(x = Marital_Status, y = Weight))

graph + geom_point()

## We can add a title
graph + geom_point() + ggtitle("Learning geom_point()")

## And we can use our new function to save the image
saveInImageDirectory("Our First Graph.png")


## We can change the shape of the points
graph + geom_point(shape = 17) + ggtitle("geom_point(shape = 17)")
saveInImageDirectory("Graph with Shape.png")
## So where does the shape come from?  See PowerPoint

## We can change the size of the points
graph + geom_point(size = 4) + ggtitle("geom_point(size = 4)")
saveInImageDirectory("Graph with Size.png")
## The size of the point is in mm

## We can change the color of the point based on the person's gender
graph + geom_point(aes(color = Gender)) + 
  ggtitle("geom_point(aes(color = Gender))")
saveInImageDirectory("Graph with Colored Points.png")

## "jitter" can be useful
graph + geom_point(aes(color = Gender), position = "jitter") + 
  ggtitle("geom_point(aes(colour = Gender), position = jitter)")
saveInImageDirectory("Graph with Jitter.png")

## We can identify the jittered points based on gender
graph + geom_point(aes(shape = Gender), position = "jitter") + 
  ggtitle("geom_point(aes(shape = Rating_Type), position = jitter)")

## We can add some color to make it easier to read
graph + geom_point(aes(shape = Gender, color = Marital_Status), position = "jitter") + 
  ggtitle("geom_point(aes(shape = Rating_Type), position = jitter)")
saveInImageDirectory("Gaph with Jitter and Color.png")

###############################################################
###############################################################
## Bar Charts in ggplot

bar <- ggplot(patientData, aes(Marital_Status))

##     We're using the ggplot function
##     We're using the mpg1 dataframe
##     The x-axis will be the "Marital_Status" variable
##     The y-axis will be the counts of the "Marital_Status" variable

##     geom_bar() allows us to create the graph.
##     We add it using "+"

bar + geom_bar()

##     Typically leave them black/white, but you can add color.
bar + geom_bar(fill = "purple")
bar + geom_bar(fill = "red")

##     We can add a title. 
bar + geom_bar(fill = "red") + ggtitle("Marital Status")

##     We can format the title. 
bar + geom_bar(fill = "red") + ggtitle("Marital Status") + 
  theme(plot.title = element_text(color="blue", size=28, face="bold"))

##     We can use the function we created to save
##     the image. 
saveInImageDirectory("Count of Marital Status.png")

###############################################################
###############################################################
## Side-by-Side and Segmented Bar Charts

bar <- ggplot(patientData, aes(Marital_Status, fill=Gender))
bar + geom_bar()
saveInImageDirectory("Marital Status Stacked Bar.png")

## If we want them side-by-side
bar + geom_bar(position = "dodge2")
saveInImageDirectory("Marital Status Side by Side Bar.png")

###############################################################
###############################################################
## Histograms

salaries <- read.csv("Data/San_Francisco_Salaries_2014.csv", header = TRUE)

hist <- ggplot(salaries, aes(x = TotalPayBenefits))

hist + geom_histogram(color = "black", fill = "gray")
hist + geom_histogram(color = "black", fill = "purple", bins=5) + 
        ggtitle("Total Pay & Benefits") + 
        theme(plot.title = element_text(color="purple", size=28, face="bold"))

## bins define the number of bars to include.  In this case, 5 bars.
## However, 5 bars don't provide a lot of detail

hist + geom_histogram(color = "black", fill = "purple", bins=20) + 
  ggtitle("Total Pay & Benefits") + 
  theme(plot.title = element_text(color="purple", size=28, face="bold"))

## 20 may provide too much detail and make the graph "noisy"
hist + geom_histogram(color = "black", fill = "purple", bins=10) + 
  ggtitle("Total Pay & Benefits") + 
  theme(plot.title = element_text(color="purple", size=28, face="bold"))

## You can also define bars based on the range of values included rather
## than a specific number of bars.
hist + geom_histogram(color = "black", fill = "purple", binwidth=10000) + 
  ggtitle("Total Pay & Benefits") + 
  theme(plot.title = element_text(color="purple", size=28, face="bold"))

## This example starts with the lowest total pay & benefits and includes 
## a range of $10,000.

saveInImageDirectory("Total Pay & Benifits Histogram.png")

## One way to add additional variables, particularly useful for categorical 
## variables, is to split the plot into facets, subplots that each display 
## one subset of the data.
##
## To facet a plot by a single variable, use facet_wrap(). The first argument 
## of facet_wrap() should be a formula, which you create with ~ followed by a 
## variable name (here "formula" is the name of a data structure in R, not a 
## synonym for "equation"). The variable that you pass to facet_wrap() should 
## be discrete.

## (We've already created this, but just as a reminder)
hist <- ggplot(salaries, aes(x = TotalPayBenefits))

hist + geom_histogram(color = "black", fill = "purple", binwidth=10000) + 
  ggtitle("Total Pay & Benefits") + 
  theme(plot.title = element_text(color = "purple", size=28, face="bold")) +
  facet_wrap(~ JobTitle, nrow = 1)


## ~ JobTitle tells R to split the graphs based on Job Title
## nrow tells R how many rows of graphs to create.  Because there are 
## only two job titles in the file, I chose to put it all on one row.

## We could make it a little fancier
hist <- ggplot(salaries, aes(x = TotalPayBenefits, fill=JobTitle))

hist + geom_histogram(color="black",binwidth=10000) + 
  ggtitle("Total Pay & Benefits") + 
  theme(plot.title = element_text(color = "purple", size=28, face="bold"))
## Without the facet, this is a stacked histogram.

hist + geom_histogram(color="black",binwidth=10000) + 
  ggtitle("Total Pay & Benefits") + 
  theme(plot.title = element_text(color = "purple", size=28, face="bold")) +
  facet_wrap(~ JobTitle, nrow = 1)

saveInImageDirectory("Faceted Histogram.png")

###############################################################
###############################################################
## Scatterplots

scatter <- ggplot(salaries, aes(x=BasePay, y=TotalPay)) 
scatter + geom_point()

## A geom is the geometrical object that a plot uses to represent 
## data. People often describe plots by the type of geom that the 
## plot uses. For example, bar charts use bar geoms, line charts 
## use line geoms, boxplots use boxplot geoms, and so on. 
## Scatterplots break the trend; they use the point geom. 
## You can use different geoms to plot the same data.

scatter + geom_smooth()

## We can get separate lines for each job title
scatter + geom_smooth(aes(linetype=JobTitle))

## We can graph points and lines on the same graph
scatter + geom_point() + geom_smooth()

scatter + geom_point(aes(color = JobTitle)) + geom_smooth(se = FALSE)

scatter + geom_point(aes(color = JobTitle)) + 
  geom_smooth(data = filter(salaries, JobTitle == "EMT/Paramedic/Firefighter"), se = FALSE)

###############################################################
###############################################################
### Box Plots

box <- ggplot(salaries, aes(x = factor(1), y = BasePay)) 

box + geom_boxplot(width = 0.4, fill = "white") 

box + geom_boxplot(width = 0.4, fill = "white") +
  geom_jitter(width = 0.1, size = 1) # Add a dot for each observation

box + geom_boxplot(width = 0.4, fill = "white") +
  geom_jitter(width = 0.1, size = 1) +
  labs(x = NULL)   # Remove x axis label


## End of script ##
