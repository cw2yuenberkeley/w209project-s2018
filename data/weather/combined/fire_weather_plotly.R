library(plotly)
library(RColorBrewer)
setwd('~/Documents/ucb-mids/w209project-s2018/data/weather/combined/')

# load data and set column names
d <- read.csv('./long/all_years_long.csv', header = FALSE)
d <- d[1:1000,]
colnames(d)
cols.to.keep <- c('FIRE_ID', 'OBS_DATE', 'START_DATE', 'END_DATE', 'DAYS', 
                  'FIRE_LAT', 'FIRE_LON', 'FIRE_YEAR', 'STATION_ID', 
                  'STAT_LAT', 'STAT_LON', 'DIST', 'BEARING', 
                  'TAVG', 'TMAX', 'TMIN', 'PRCP', 'SNWD')
colnames(d) <- cols.to.keep

# plotly

# plot(TMAX ~ FIRE_ID + OBS_DATE, d)
# hist(d$TMAX)

p.tmax <- plot_ly(d, x=~TMAX, color = ~as.factor(FIRE_YEAR), type = "box")
p.tmin <- plot_ly(d, x=~TMIN, color = ~as.factor(FIRE_YEAR), type = "box")
p.tavg <- plot_ly(d, x=~TMIN, color = ~as.factor(FIRE_YEAR), type = "box")
p.snwd <- plot_ly(d, x=~log(SNWD), color = ~as.factor(FIRE_YEAR), type = "box")
  
p.tmax
p.tmin
p.tavg
p.snwd


library(psych)
describe(d$SNWD)
hist(log(d$SNWD))


p.mult <- plot_ly(d, x = ~as.Date(OBS_DATE), y = ~TMAX/10, name = 'TMAX', type = 'scatter',
                  transforms = list(
                    list(
                      type = 'filter', 
                      target = 'y', 
                      operation = '>=', 
                      value = mean(d$TMAX, na.rm = TRUE) / 10))) %>%
  layout(
    title = 'Weather By Year', 
    xaxis = list(
      rangeslider = list(type = "date")),
    yaxis = list(title = "Weather"), 
    updatemenus = list(
      list(
        type = 'dropdown', 
        active = 1, 
        buttons = list(
          list(method = 'restyle', 
               args = list('transforms[0].value', min(d$TMAX, na.rm = TRUE) / 10), 
               label = 'All'), 
          list(method = 'restyle', 
               args = list('transforms[0].value', mean(d$TMAX, na.rm = TRUE) / 10), 
               label = '> mean')
        )
      )
    )
  )


p.mult


# Create a map 
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray85"),
  subunitwidth = 1,
  countrywidth = 1,
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white")
)

p.map <- plot_geo(d, locationmode = 'USA-states', sizes = c(1, max(d$DAYS, na.rm = TRUE))) %>% 
  add_markers(
    text = ~list(paste('DAYS:', d$FIRE_LON)), hoverinfo='text', 
    x = ~FIRE_LON, y = ~FIRE_LAT, size = ~DAYS+1, color = ~TMAX/10
  ) %>% 
  layout(title = 'Fires by location', geo = g)
p.map
head(d)
