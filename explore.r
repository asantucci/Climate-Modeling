################################################################################
################################################################################
################################################################################
###
### Title: Exploratory Analysis
###
### Author: Andreas Santucci
###
### Date: July 13th, 2015
###
### Inputs: 'model[123]_train.csv'
###
### Dependencies: data.table, reshape2, zoo
###
################################################################################
################################################################################

##############################
###
### Set Up Workspace
###
##############################

require(data.table)
require(reshape2)
require(ggplot2)
require(animation)

#setwd("/Users/asantucci/Dropbox/Career/LLNL/data_heroes/climate_change/")
source('functions.r')

dates <- CJ(month = tolower(month.abb), year = 1900:2005, sorted = F)
dates <- dates[order(year)]
dates[, month.num := 1:12]

files <- list.files(pattern = 'train')

for (i in 1:length(files)) {
    data <- loadData(files[i], dates)
    cdata <- collapseData(data)
    setkey(cdata, year)
    #animateWrapper(dates = dates, data = cdata, model.no = i, monthly = F)
    animateWrapper(dates = dates, data = data,  model.no = i, monthly = T)
}
