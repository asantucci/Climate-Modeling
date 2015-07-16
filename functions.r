################################################################################
################################################################################
################################################################################
###
### Title: Function Definitions
###
### The Penguins
###
### Date: July 13th, 2015
###
### Inputs: NA
###
### Dependencies: data.table, reshape2, zoo
###
################################################################################
################################################################################

loadData <- function(fname) {
    data <- fread(fname)
    ### Set up a vector of dates to identify columns.
    dates <- CJ(month = month.abb, year = 1900:2005, sorted = F)
    dates <- dates[order(year)]
    dates <- dates[, paste(month, year, sep = '.')]
    setnames(data, c('id', 'lat', 'lon', tolower(dates)))
    ### Include an identifier for the model number.
    data[, model := gsub("^[[:alpha:]]+([0-9]).*", "\\1", fname)]
    return(data)
}
