library(forecast)
library(zoo)
library(imputeTS)
library(lubridate)
library(xts)
library(rpart)
library(earth)

my_lag = function(vec, lag_dist){
  vec = c(rep(NA, lag_dist),vec[1:(length(vec)-lag_dist)])
  return(vec)
}

log_return = function(value, value_lag){
  return(log(value/value_lag))
}


fill_daily = function(df){
  maxd = data.frame(date = seq(from = min(df$date), to = max(df$date), by = 1))
  ff = merge(maxd, df, by = "date", all.x = TRUE )
  ff$value = imputeTS::na_locf(ff$value)
  return(ff)
}


add_seasonality = function(df){
  df$month = lubridate::month(df$date)
  df$weekday = weekdays(df$date)
  return(df)  
  
}



