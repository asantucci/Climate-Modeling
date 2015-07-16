################################################################################
################################################################################
################################################################################
###
### Title: Exploratory Analysis
###
### Author: The Penguins
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
require(zoo)

source('functions.r')

files <- list.files(pattern = 'train')
data <- lapply(files, loadData)

### Melt: transform data into a long format.
mdata <- lapply(data, melt, id.vars = c('id', 'lat', 'lon'),
                variable.name = 'date')

### Combine: Stack models on top of each other into one larger data.table
cdata <- rbindlist(mdata)
