library(caret)
wd = "/Users/lbowle11/Documents/GitHub/leviabowles_repo/r_timeseries"
setwd(wd)
source("lb_ts.R")
wd = "/Users/lbowle11/Documents"
setwd(wd)
xx = read.csv("wheat.csv")
xx$date = as.Date(xx$date, "%m/%d/%Y")
row.names(xx) = xx$date


xx = fill_daily(xx)
xx$value_lag = my_lag(xx$value,1)
xx$log_return = log_return(xx$value,xx$value_lag)
xx = multi_lag(xx,"log_return",10)
xx = add_seasonality(xx)

xx = xx[complete.cases(xx),]
xx = xx[,c(4:ncol(xx))]


mod = caret::train(log_return~.,data = xx, type = "GBM")



mod = earth(log_return ~ weekday + log_return_lag1 + log_return_lag2+ log_return_lag3+ log_return_lag4+ log_return_lag5+factor(month) , degree = 2,ff)


yy = forecast::auto.arima(ff$value)

yy = forecast::arfima(xx$value)