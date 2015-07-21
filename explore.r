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

source('functions.r')

km.per.mile <- 1.6

files <- list.files(pattern = 'train')
data <- lapply(files, loadData)

ll <- geocode("san francisco, ca")
loc <- unique(data[, list(lon, lat)])
loc$lon <- loc$lon - 360
dist <- spDistsN1(as.matrix(loc), pt = as.numeric(ll), longlat = T)
dist <- dist/km.per.mile

addr <- revgeocode(as.numeric(loc[which.min(dist)]))

data <- data[lat == loc[which.min(dist), lat] & lon == loc[which.min(dist), lon] + 360]

data[, year := gsub('^[[:alpha:]]+\\.', '', date)]

ggplot(data = data, aes(x = date, y = value, color = year)) +
    geom_point()
