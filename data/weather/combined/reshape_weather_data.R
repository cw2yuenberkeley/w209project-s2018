library(dplyr)
library(reshape2)

setwd('~/Documents/ucb-mids/w209project-s2018/data/weather/combined/CombinedArchive/')



cols.to.keep <- c('FIRE_ID', 'OBS_DATE', 'START_DATE', 'END_DATE', 'DAYS', 
                  'FIRE_LAT', 'FIRE_LON', 'FIRE_YEAR', 'STATION_ID', 
                  'STAT_LAT', 'STAT_LON', 'DIST', 'BEARING', 
                  'TAVG', 'TMAX', 'TMIN', 'PRCP', 'SNWD', 'SNOW')

new.header <- c('FIRE_ID', 'OBS_DATE', 'START_DATE', 'END_DATE', 'DAYS', 
                  'FIRE_LAT', 'FIRE_LON', 'FIRE_YEAR', 'STATION_ID', 
                  'STAT_LAT', 'STAT_LON', 'DIST', 'BEARING', 
                  'TAVG', 'TMAX', 'TMIN', 'PRCP', 'SNWD', 'SNOW')

# write.table(rbind(cols.to.keep), file = './long/headers.csv', sep = ',', row.names = FALSE, col.names = FALSE)
write.table(rbind(cols.to.keep), file = '../long2/headers.csv', sep = ',', row.names = FALSE, col.names = FALSE)

ConvertToLongFormat <- function(fn, cols) {
  d <- read.csv(paste(fn, '_combined.csv', sep = ''))
  d.l <- dcast(d, FIRE_ID + OBS_DATE + START_DATE + END_DATE + DAYS + FIRE_LAT + FIRE_LON + FIRE_YEAR + STATION_ID + STAT_LAT + STAT_LON + DIST + BEARING ~ KEYWORD, value.var = 'VAL')
  head(d.l)
  d.s <- subset(d.l, select = cols)
  colnames(d.s) <- cols
  d.s$TAVG <- d.s$TAVG / 10.0
  d.s$TMIN <- d.s$TMIN / 10.0
  d.s$TMAX <- d.s$TMAX / 10.0
  d.s$OBS_DATE <- as.Date(as.character(d.s$OBS_DATE), '%Y%m%d')
  write.table(d.s, sep=',', file = paste('../long2/all_years_long2.csv', sep = ''), append = TRUE, row.names = FALSE, col.names = FALSE)
}

# ConvertToLongFormat(2015, cols.to.keep)


# d.n$OBS_DATE <- as.Date(as.character(d.n$OBS_DATE), '%Y%m%d')


# plot(TMAX ~ FIRE_ID + OBS_DATE, data = d.n)
# sapply(c(1997:1998), 1, FUN = function(x) {ConvertToLongFormat(x, cols.to.keep)})

for (year in c(1997:2015)) {
  ConvertToLongFormat(year, cols.to.keep)
}

# Add the header back from bash
# echo -e "$(cat headers.csv)\n$(cat all_years_long2.csv)" > all_years_long2.csv 

# d.n <- read.csv('../long2/all_years_long2.csv', header = FALSE)
# colnames(d.n) <- new.header

# Bash, combine all csvs into one
# paste -d , *_long.csv > all_years_long.csv
# cat ./headers.csv | cat - all_years_long.csv > /tmp/out && mv /tmp/out ./all_years_long.csv 
