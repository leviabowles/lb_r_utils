library(forecast)
library(zoo)
library(imputeTS)
library(lubridate)
library(xts)
library(rpart)
library(earth)

log_return = function(value, value_lag){
  return(log(value/value_lag))
}


my_lag = function(vec, lag_dist){
  vec = c(rep(NA, lag_dist),vec[1:(length(vec)-lag_dist)])
  return(vec)
}



lb_ts = setClass("lb_ts",
         slots = list(splits = "list",
                      df = "data.frame",
                      lagged_variables = "character",
                      dvar = "character",
                      model_validation = "data.frame"))


setGeneric("log_return_dvar", function(object) standardGeneric("log_return_dvar"))
setGeneric("fill_daily", function(object) standardGeneric("fill_daily"))
setGeneric("multi_lag", function(object,var,increment) standardGeneric("multi_lag"))
setGeneric("add_seasonality", function(object,var,increment) standardGeneric("add_seasonality"))
setGeneric("complete_only", function(object) standardGeneric("complete_only"))
setGeneric("time_slice", function(object, increment, min_size =100, walk=FALSE, validate_length = 1) standardGeneric("time_slice"))
setGeneric("time_build_models", function(object,models,iter) standardGeneric("time_build_models"))
setGeneric("model_metrics", function(object) standardGeneric("model_metrics"))

setMethod("log_return_dvar",
          "lb_ts",
          function(object){
            object@df$lag_dvar = my_lag(object@df[,object@dvar],1)
            object@df[,object@dvar] = log_return(object@df[,object@dvar],object@df$lag_dvar)
            return(object)
          }
)


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


setMethod("multi_lag",
          "lb_ts",
          function(object,var,increment){
            
            for(i in c(1:increment)){
              object@df[,paste0(var,"_lag",as.character(i))] = my_lag(object@df[,var],i)
            }
            
            return(object)
            
          }
)

setMethod("add_seasonality",
          "lb_ts",
          function(object){object@df$month = factor(lubridate::month(object@df$date))
          object@df$weekday = weekdays(object@df$date)
          return(object)}
          
)


setMethod("complete_only",
          "lb_ts",
          function(object){
          
            object@df = object@df[complete.cases(object@df),]
            return(object)
            }
          
)

setMethod("time_slice",
          "lb_ts",
          function(object,increment, min_size =100, walk=FALSE, validate_length = 1){
            
            slice_out = list()
            ind = object@df$date
            ind_range = max(ind)-min(ind)
            j = min(ind) + min_size -1
            
            while(j <= max(ind)){
              df_out = object@df[object@df$date <= j ,]
              validate_out = object@df[object@df$date > j & object@df$date <= j+validate_length, ]
              temp_list = list()
              temp_list[["train"]] = df_out
              temp_list[["test"]] = validate_out
              slice_out[[as.character(max(df_out$date))]] = temp_list
              if(j == max(object@df$date)) break
              j = j + increment
              if(j > max(object@df$date)) {j = max(object@df$date)}
              
            }
            
            object@splits = slice_out
            return(object)  
            
            
      }
)

setMethod('time_build_models',
          'lb_ts',
          function(object,models,iter){
            dm_catch = NULL
            for(j in models){
              for(i in object@splits[c(1:iter)]){
                print(i)
                i$train =  i$train[,c(2:ncol(i$train))]
                mod = caret::train(value ~., data = i$train , method = j) 
                try({i$test$pred = predict(mod, newdata = i$test)
                dfx = data.frame(date = i$test$date, 
                                 real_value = i$test$value, 
                                 predicted_value = i$test$pred)
                dm_catch = rbind(dfx,dm_catch)
                print(dm_catch)
                })
              }
            }
            object@model_validation = dm_catch
            return(object)
          }          
   
)

setMethod('model_metrics',
          'lb_ts',
          function(object){
            
            print(cor(a@model_validation[,2:3]))
            
            
          }
)


