library(shiny)
library(shinyjs)
library(shinycssloaders)
library(RColorBrewer)
library(vcd)
library(corrgram)
library(car)
library(visdat)
library(tabplot)
library(ggplot2)
library(skimr)
library(GGally)
library(recipes)
library(caret)
library(rpart)
library(rpart.plot)
library(glmnet)
library(plotly)
library(ggrepel)
library(DT)
library(devtools)

# library(tidytext)
# library(tidyverse)
# library(stringr)
# library(reshape2)
# library(pls)
# library(textdata)
# library(seriation)
# library(visNetwork)
# library(leaflet)


covid_dat <- read.csv("Ass2Data.csv", 
                header = TRUE, 
                sep =",",
                quote ="\"",
                na.strings = c(" ","--","-99","NA","N/A", "<NA>"), 
                stringsAsFactors = TRUE)


covid_dat_shadow <- covid_dat

covid_dat_shadow$HEALTHCARE_BASIS_SHADOW <- as.character(covid_dat_shadow$HEALTHCARE_BASIS) #convert away from factor
covid_dat_shadow$HEALTHCARE_BASIS_SHADOW[is.na(covid_dat_shadow$HEALTHCARE_BASIS_SHADOW)] <- "none"
covid_dat_shadow$HEALTHCARE_BASIS_SHADOW <- as.factor(covid_dat_shadow$HEALTHCARE_BASIS_SHADOW)  # convert back to factor

covid_dat_shadow$HEALTHCARE_COST_SHADOW<- as.numeric(is.na(covid_dat_shadow$HEALTHCARE_COST)) # create a shadow variable
covid_dat_shadow$HEALTHCARE_COST_SHADOW[is.na(covid_dat_shadow$HEALTHCARE_COST_SHADOW)] <- 0 #Assign missing to zero


#creating a test/train split

train_data <- covid_dat[covid_dat$OBS_TYPE == "Train",]
test_data <-covid_dat[covid_dat$OBS_TYPE == "Test",]


lexicon <- textdata::lexicon_afinn(dir = "assignment2Data423")


numeric_vars <- covid_dat[, sapply(covid_dat, is.numeric)]
categorical_vars <- covid_dat[, sapply(covid_dat, is.factor)]

allVars <- colnames(covid_dat)

pairs_data <- covid_dat[,-c(1,15)]

#choices datasets
choicesPairs <- colnames(as.data.frame(pairs_data))
choicesColor <- colnames(as.data.frame(categorical_vars))
choicesCorr <- colnames(as.data.frame(numeric_vars))
choicesMosaic <- colnames(as.data.frame(categorical_vars[-c(1,4)]))
choicesBox <- colnames(as.data.frame(numeric_vars))
choicesTab <- colnames(as.data.frame(covid_dat))
choicesRising <-colnames(as.data.frame(numeric_vars))






#to install TabPlot:
#library(devtools)
#install_github("edwindj/ffbase", subdir="pkg")
#install_github("mtennekes/tabplot")
