###############################################################
## QMGT-4750-01                                              ##
## Project 5                                                 ##
##                                                           ##
## Written: 2020-04-29             Last revision: 2020-05-02 ##
## Vishal Balaji                                Revision: 03 ##
###############################################################


# Packages -----------------------------------------------------------

install.packages("tidyverse")
library(tidyverse)

# Preliminaries -----------------------------------------------------------

setwd("F:/Google Drive/Classes/2020 Spring/data analysis")
getwd()

# Image save function
imageDirectory <- "images"
saveInImageDirectory <- function(filename){
  imageFile <- file.path(imageDirectory, filename)
  ggsave(imageFile, width = 30, height = 20, units = "cm", dpi = 300)
}

# Data -----------------------------------------------------------------

# The data is imported with the right column types
tuitionData <- read_csv("Data/Tuition.csv", 
                        col_types = cols(
                          Name = col_character(), 
                          Location = col_character(), 
                          `In-State Tuition` = col_double(), 
                          `Out-of-State Tuition` = col_double(), 
                          Type = col_factor()
                        ))
# The data is mutated to include three new Columns
# `Classification` is of type factor containing three levels: College, University, Community College
# This is done by comparing the insitiution name and extracting the classification which is then converted into a factor
# All insitutions that do not have any of the classification in their `name` will have an "NA" factor
# This will be changed into a factor of "College"
# `State` is of type factor containing 45 levels, each level represents a state
# `Location_print` is of type character which contains the `Location` with proper capitalization
tuitionData <- tuitionData %>% 
  mutate(
    Classification = parse_factor(str_extract(tuitionData$Name, "College|University|Community College")),
    State = parse_factor(str_extract(tuitionData$Location, '\\S+$')),
    Location_print = 
      str_c(str_to_title(sub("(,).*", "", tuitionData$Location)), 
            str_extract(tuitionData$Location, '\\S+$'), 
            sep = ", "
            )
  )
tuitionData$Classification <- fct_explicit_na(tuitionData$Classification, "College")


# Colleges in Top 10 ------------------------------------------------------

# Displays the Colleges that are in the list of top 10 instituitons with the highest in-state tuition
tuitionData %>% 
  top_n(10, `In-State Tuition`) %>%
  filter(Classification == "College") %>%
  select(Name, Type, `In-State Tuition`)


# In-State vs Out-Of-State tuition difference for private colleges -----------------------------

tuitionDifference <- tuitionData %>% 
  mutate(
    Tuition_Diff = `In-State Tuition` - `Out-of-State Tuition`
  ) %>%
  filter(Type == "Private") %>%
  select(Name, Type, `Tuition_Diff`)
tuitionDifference

# Lower tuition than Millsaps ---------------------------------------------

millsapsTuition <- tuitionData %>% filter(str_detect(tuitionData$Name, "Millsaps"))
  
lowerThanMillsaps <- tuitionData %>%
  filter(Type == "Private" & Classification == "College") %>%
  filter(`In-State Tuition` < millsapsTuition$`In-State Tuition`, `Out-of-State Tuition` < millsapsTuition$`Out-of-State Tuition`)
lowerThanMillsaps

# Mean In-state tuition by state ------------------------------------------

inStateTuition_byState <- tuitionData %>% 
  group_by(State) %>% 
  summarise(
    `In-State Tuition` = mean(`In-State Tuition`, na.rm = TRUE)
    ) %>% 
  arrange(desc(`In-State Tuition`))

# Mississippi's rank (1 - highest, nth - lowest)
which(grepl("MS", inStateTuition_byState$State))


# Millsaps vs other private colleges in MS --------------------------------------

privateCollegesInMS <- tuitionData %>% 
  filter(Type == "Private", 
         Classification == "College",
         State == "MS"
         ) %>%
  arrange(desc(`In-State Tuition`))

# Millsaps' Rank (1 - highest, nth - lowest)
which(grepl("Millsaps", privateCollegesInMS$Name))


# Bar Graphs for each Private College by State --------------------------------------------------------------

# Bar grapher function
privateCollegeBarGraph <- function(state_name){
  tuitionData %>% 
    filter(Type == "Private", 
           Classification == "College",
           State == state_name
    ) %>% 
    ggplot(aes(x = Name, y = `In-State Tuition`)) + 
    theme_minimal() + 
    theme(plot.title = element_text(color = "grey25", size = 20, face = "bold")) +  
    geom_bar(stat = "identity", fill = "darkcyan", width = 0.7) +
    ggtitle(
      str_c(c("In-state Tution for Private Colleges in", state_name), collapse = " ")
    )
  saveInImageDirectory(str_c(c("In-state tuition - ", state_name, ".png"), collapse = ""))
}

# Bar graphs
privateCollegeBarGraph("AL")
privateCollegeBarGraph("AR")
privateCollegeBarGraph("FL") # No Private Colleges
privateCollegeBarGraph("GA")
privateCollegeBarGraph("LA")
privateCollegeBarGraph("MS")
privateCollegeBarGraph("TN")


# Bar Graphs for average in-state tuition for each state ---------------------------------------------------

selStates = c("AL", "AR", "FL", "GA", "LA", "MS", "TN")
inStateTuition_byState %>% 
  filter(
    State %in% selStates
  ) %>%
  ggplot(aes(x = State, y = `In-State Tuition`)) + 
  theme_minimal() + 
  theme(plot.title = element_text(color = "grey25", size = 20, face = "bold")) +  
  geom_bar(stat = "identity", fill = "coral1", width = 0.7) + 
  ggtitle("Average In-state Tution by State")

saveInImageDirectory("Average In-state Tution by State.png")
