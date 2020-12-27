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

multi_lag = function(df, var, increment){
  
  for(i in c(1:increment)){
    df[,paste0(var,"_lag",as.character(i))] = my_lag(df[,var],i)
  }
  
  return(df)
  
}

log_return = function(value, value_lag){
  return(log(value/value_lag))
}


fill_daily = function(df){
  maxd = data.frame(date = seq(from = min(df$date), to = max(df$date), by = 1))
  ff = merge(maxd, df, by = "date", all.x = TRUE )
  for(i in c(1:10)){ff$value = imputeTS::na_locf(ff$value)}
  return(ff)
}


add_seasonality = function(df){
  df$month = factor(lubridate::month(df$date))
  df$weekday = weekdays(df$date)
  return(df)  
  
}



