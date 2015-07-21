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
require(ggmap)
require(reshape2)
require(sp)
require(zoo)
require(ggplot2)
require(animation)

source('functions.r')

files <- list.files(pattern = 'train')
data <- loadData(files[1])
#data <- lapply(files, loadData)

data[, month := gsub('^([[:alpha:]]{3}).*$', '\\1', date)]
data[, year := gsub('^[[:alpha:]]+\\.([0-9]+)$', '\\1', date)]
data[, year := as.integer(year)]

d <- data[month == 'jan' & year == 2000]

ggplot(d, aes(x = lon, y = lat)) +
    geom_tile(aes(fill = value))

dates <- CJ(month = tolower(month.abb), year = 1900:2005, sorted = F)
dates <- dates[order(year)]
dates[, month.num := 1:12]

ordering <- data.frame(month = tolower(month.abb), month.num = 1:12)
setkey(data, month)
data <- data[ordering]
setkey(data, year, month.num)

HeatMap <- function(data, year, month) {
    t <- CJ(year = year, month.num = month)
    setkey(t, year, month.num)    
    d <- data[t]
    plot <- ggplot(d, aes(x = lon, y = lat)) +
        geom_tile(aes(fill = value)) +
        labs(title = paste0('Year: ', year, ', Month: ', month))
    print(plot)
}

animate.heatMap <- function(dates, data) {
    for (i in 1:nrow(dates))
        HeatMap(data, dates[i, year], dates[i, month.num])
}

saveGIF(animate.heatMap(dates, data), interval = 0.05, movie.name = 'test1.gif')
