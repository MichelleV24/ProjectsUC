library(shiny)
library(shinyjs)
library(vcd)
library(RColorBrewer)
library(corrgram)
library(visdat)
library(tidytext)
library(tidyverse)
library(stringr)
library(reshape2)
library(pls)
library(ggplot2)
library(devtools)
library(car)
library(tabplot)
library(textdata)
library(seriation)
library(visNetwork)
library(leaflet)
library(shinycssloaders)
library(skimr)
library(GGally)


factory_data <- read.csv('Ass1Data.csv', header = TRUE, 
                 sep = ",", quote = "\"", 
                 stringsAsFactors = TRUE, na.strings = c("", "NA"))

lexicon <- textdata::lexicon_afinn(dir = "assignment1MV")

# Create a vector of ordered levels
ordered_speeds <- c("Slow", "Medium", "Fast")
ordered_priority <- c("Low", "Medium", "High")
ordered_price <- c("Cheap", "Fair", "Expensive")
ordered_duration <- c("Short", "Long", "Very Long")

# Convert the variable to an ordered factor with specified levels
factory_data$Speed <- factor(factory_data$Speed, ordered = TRUE, levels = ordered_speeds)
factory_data$Priority <- factor(factory_data$Priority, ordered = TRUE, levels = ordered_priority)
factory_data$Price <- factor(factory_data$Price, ordered = TRUE, levels = ordered_price)
factory_data$Duration <- factor(factory_data$Duration, ordered = TRUE, levels = ordered_duration)


#convert date to date variable
factory_data$Date <- as.Date(factory_data$Date)

#Tabplot factory data
factory_data2 <- as.data.frame(factory_data)
factory_data2$Date <- as.character(factory_data$Date)

numeric_vars <- factory_data[, sapply(factory_data, is.numeric)]
categorical_vars <-factory_data[, sapply(factory_data, is.factor)]
categoric_vars <- categorical_vars[-1]

#data for pairs plot
pairs_data <- factory_data[,-c(2,4)]

#choices datasets
choicesMosaic <- colnames(as.data.frame(categoric_vars))
choicesPairs <- colnames(as.data.frame(pairs_data))
choicesCorr <- colnames(as.data.frame(numeric_vars))
choicesBox <- colnames(as.data.frame(numeric_vars))
choicesTab <- colnames(as.data.frame(factory_data2))
choicesRising <-colnames(as.data.frame(numeric_vars))



allVars <- colnames(factory_data)
factorVars <- colnames(factory_data)[unlist(lapply(factory_data, is.factor))]
numericVars <- colnames(factory_data)[unlist(lapply(factory_data, is.numeric))]


#to install TabPlot:
#library(devtools)
#install_github("edwindj/ffbase", subdir="pkg")
#install_github("mtennekes/tabplot")
