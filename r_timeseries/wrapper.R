wd = "/Users/lbowle11/Documents"
setwd(wd)
xx = read.csv("wheat.csv")
xx$date = as.Date(xx$date, "%m/%d/%Y")
row.names(xx) = xx$date
ff$value_lag = my_lag(ff$value,1)
ff$log_return = log(ff$value/ff$value_lag)



for(i in c(1:5)){
  ff[,paste0("log_return_lag",as.character(i))] = my_lag(ff$log_return,i)
}

ff = ff[complete.cases(ff),]
mod = earth(log_return ~ weekday + log_return_lag1 + log_return_lag2+ log_return_lag3+ log_return_lag4+ log_return_lag5+factor(month) , degree = 2,ff)


yy = forecast::auto.arima(ff$value)

yy = forecast::arfima(xx$value)