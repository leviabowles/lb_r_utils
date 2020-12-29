library(forecast)
library(zoo)
library(imputeTS)
library(lubridate)
library(xts)
library(rpart)
library(earth)

lb_ts = setClass("lb_ts",
         slots = list(splits = "list",
                      df = "data.frame",
                      lagged_variables = "character",
                      dvar = "character"))

setMethod("fill_daily",
          "lb_ts",
          function(object) {
            
            
            maxd = data.frame(date = seq(from = min(object@df$date), to = max(object@df$date), by = 1))
            ff = merge(maxd, object@df, by = "date", all.x = TRUE )
            for(i in c(1:10)){ff$value = imputeTS::na_locf(ff$value)}
            print(typeof(object))
            object@df = ff
            return(object)
          }
)


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


# fill_daily = function(df){
#   maxd = data.frame(date = seq(from = min(df$date), to = max(df$date), by = 1))
#   ff = merge(maxd, df, by = "date", all.x = TRUE )
#   for(i in c(1:10)){ff$value = imputeTS::na_locf(ff$value)}
#   return(ff)
# }


add_seasonality = function(df){
  df$month = factor(lubridate::month(df$date))
  df$weekday = weekdays(df$date)
  return(df)  
  
}

time_slice = function(df, increment, min_size =100, walk=FALSE, validate_length = 1){
  ##walk is not currently working, need to add functionality
  
  slice_out = list()
  ind = df$date
  ind_range = max(ind)-min(ind)
  j = min(ind) + min_size -1
  
  while(j <= max(ind)){
    df_out = df[df$date <= j ,]
    validate_out = df[df$date > j & df$date <= j+validate_length, ]
    temp_list = list()
    temp_list[["train"]] = df_out
    temp_list[["test"]] = validate_out
    print(df_out)
    slice_out[[as.character(max(df_out$date))]] = temp_list
    if(j == max(df$date)) break
    j = j + increment
    if(j > max(df$date)) {j = max(df$date)}
    
  }
  return(slice_out)  
  
}


time_slice_validate = function(time_sliced, models, iter){
  dm_catch = NULL
  for(j in models){
    for(i in time_sliced[c(1:iter)]){
     i$train =  i$train[,c(4:ncol(i$train))]
     mod = caret::train(log_return ~., data = i$train , method = j) 
     try({i$test$pred = predict(mod, newdata = i$test)
     dfx = data.frame(date = i$test$date, 
                      real_value = i$test$log_return, 
                      predicted_value = i$test$pred)
     dm_catch = rbind(dfx,dm_catch)
     print(dm_catch)
     })
    }
  }
  return(dm_catch)
}



