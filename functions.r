################################################################################
################################################################################
################################################################################
###
### Title: Function Definitions
###
### Author: Andreas Santucci
###
### Date: July 13th, 2015
###
### Inputs: NA
###
### Dependencies: data.table, reshape2, zoo
###
################################################################################
################################################################################

loadData <- function(fname, dates) {
    data <- fread(fname)
    ### Set up a vector of dates to identify columns.
    varnames <- dates[, paste(month, year, sep = '.')]
    setnames(data, c('id', 'lat', 'lon', tolower(varnames)))
    data[, id := NULL]
    ### Collapse data by location (average over trials), reshape data.
    data <- data[, lapply(.SD, mean), by = list(lat, lon)]
    data <- melt(data, id.vars = c('lat', 'lon'), variable.name = 'date')
    setnames(data, 'value', 'temperature')
    ### Include an identifier for the model number.
    data[, model := gsub("^[[:alpha:]]+([0-9]).*", "\\1", fname)]
    ### Allow the data.table to be keyed by date.
    data[, month := gsub('^([[:alpha:]]{3}).*$', '\\1', date)]
    data[, year := as.integer(gsub('^[[:alpha:]]+\\.([0-9]+)$', '\\1', date))]
    ### Order months in chronological order, as opposed to alphabetical.
    ordering <- data.frame(month = tolower(month.abb), month.num = 1:12)
    setkey(data, month)
    data <- data[ordering]
    setkey(data, year, month.num)
    return(data)
}

collapseData <- function(data) {
    data[, list(temperature = mean(temperature)), by = list(lat, lon, year)]
}

heatMap <- function(data, year.subset, month.subset) {
    title <- paste0('Year: ', year.subset)
    if (month.subset) {
        d <- data[.(year.subset, month.subset)]
        title <- paste0(title, ', Month: ', month.subset)
    } else {
        d <- data[.(year.subset)]
    }
    plot <- ggplot(d, aes(x = lon, y = lat)) +
        geom_tile(aes(fill = temperature)) +
        labs(title = title)
    print(plot)
}

animateHeat <- function(dates, data, monthly) {
    if (!monthly) dates <- unique(dates[, list(year)])
    for (i in 1:nrow(dates)) {
        year  <- dates[i, year]
        month <- if (monthly) dates[i, month.num] else FALSE
        heatMap(data, year, month)
    }
}

animateWrapper <- function(dates, data, model.no, monthly) {
    ext <- if (monthly) '_Monthly.gif' else '.gif'
    saveGIF(animateHeat(dates, data, monthly), interval = 0.05,
            movie.name = paste0('Model_', model.no, ext))
}
