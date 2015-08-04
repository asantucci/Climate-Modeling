################################################################################
################################################################################
################################################################################
###
### Title: Modeling Climate Change
###
### Andreas Santucci
###
### Date: July 21st, 2015
###
### Inputs: model[123]_train.csv, model_test.csv
###
### Dependencies: data.table, doMC, foreach
###
################################################################################
################################################################################

##################################################
###
### Set Up Workspace
###
##################################################

require(data.table)
require(doMC)
require(foreach)

source('functions.r')

registerDoMC(4)

##################################################
###
### Load Training and Test Data
###
##################################################

dates <- CJ(month = tolower(month.abb), year = 1900:2005, sorted = F)
dates <- dates[order(year)]
vars  <- dates[, paste(month, year, sep = '.')]
vars  <- c('id', 'lat', 'lon', vars)

files <- list.files(pattern = 'train')
data  <- lapply(files, distinguishData, vars)
data  <- rbindlist(data)

test <- fread('model_test.csv')
setnames(test, vars)
gc()

### Collapse training data by lat/lon
vars <- grep('\\.', vars, value = T)
data <- data[, lapply(.SD, mean), by = list(id, lat, lon)]

data[, ':='(lon = roundLatLon(lon),
            lat = roundLatLon(lat)), by = list(lon, lat)]

### Wrap longitude.
data[, lon := (lon + 180) %% 360 - 180]

##################################################
###
### Train Model
###
##################################################

setkey(data, lon, lat)
setkey(test, lon, lat)

gc()

out <- foreach(i = 1:nrow(test), .combine = c) %dopar% {
    computeDistWrap(test, data, i, FALSE)
}

