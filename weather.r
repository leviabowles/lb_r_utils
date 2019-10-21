library(rnoaa)
library(lubridate)
library(ggplot2)
library(dplyr)

## FIND ALL AVAILABLE STATIONS
nn = rnoaa::ghcnd_stations()

## DF NO 
nn = data.frame(nn)

## FIND SOME KANSAS CITY WEATHER STATIONS
## ALTERNATELY, YOU CAN GEO-SEARCH BASED ON LAT/LON
nn[grepl("KANSAS CITY",nn$name) & nn$element == "TMAX",c("id","name","first_year","last_year")]



## PULL IN KC DOWNTOWN AIRPORT DATA
outs = rnoaa::ghcnd_search("USW00013988",refresh = TRUE)

## SHOW ALL (I'M INTERESTED IN TMAX)
summary(outs)

## GRAB TMAX INTO DF
dd = data.frame(outs$tmax)

## CONVERT FOR 'MERICA
dd$far = (dd$tmax/50*9)+32

## KILL MISSINGNESS
dd = dd[complete.cases(dd),]


##  PULL IN DATE PARTS 
dd$temp_year = lubridate::year(dd$date)
dd$temp_month = lubridate::month(dd$date)
dd$temp_day = lubridate::day(dd$date)

## SET DATE OF INTEREST
check_date = as.Date("2019-09-18")

## MARK UP DATES
dd$this_year = ifelse(dd$temp_year== lubridate::year(check_date) ,1,0)

## PULL ON "THIS" DATE
dd = dd[dd$temp_day == lubridate::day(check_date) & dd$temp_month == lubridate::month(check_date),]


## SPLIT INTO PRIOR YEARS AND THIS YEAR
this_year_data = dd[dd$this_year ==1 ,]
nrow(this_year_data)
prior_year_data = dd[dd$this_year != 1 ,]
nrow(prior_year_data)

## GRAB QUANTILE DATA FOR OUTPUT
perc = as.character(round(100*ecdf(prior_year_data$far)(this_year_data$far),1))

##GGPLOT TO SHOW DATA
ggplot(prior_year_data,aes(far))+
  geom_density(colour = "red",fill = "red" ,alpha = .4, show.legend = FALSE)+
  scale_x_continuous("Daily High Degrees Farenheit",limits =  c(min(prior_year_data$far-20),max(prior_year_data$far+20)))+
  geom_vline(aes(xintercept = mean(prior_year_data$far), colour = "mean"), size = 2) +
  geom_vline(aes(xintercept = median(prior_year_data$far), colour = "median"), size = 2) +
  geom_vline(aes(xintercept = this_year_data$far, colour = "this_year"), size = 2) +
  ggtitle(paste0("Comparison to Average Temperatures: ",as.character(check_date),
                 "| Percentile of Current Date: ",perc))+
  scale_color_manual(name = "statistics", values = c(median = "blue", mean = "red", this_year = "green"))
