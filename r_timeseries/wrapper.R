library(caret)
wd = "/Users/lbowle11/Documents/GitHub/leviabowles_repo/r_timeseries"
setwd(wd)
source("lb_ts.R")
wd = "/Users/lbowle11/Documents"
setwd(wd)
xx = read.csv("wheat.csv")
xx$date = as.Date(xx$date, "%m/%d/%Y")
row.names(xx) = xx$date

a = lb_ts(df = xx, dvar = "value")
a = fill_daily(a)
a = log_return_dvar(a)
a = multi_lag(a, "value",10)

xx$value_lag = my_lag(xx$value,1)
xx$log_return = log_return(xx$value,xx$value_lag)
xx = multi_lag(xx,"log_return",10)
xx = add_seasonality(xx)

xx = xx[complete.cases(xx),]

dd = time_slice(xx,10)

jj = time_slice_validate(dd,c("lm"), iter = 50)
summary(lm(predicted_value ~ real_value ,jj))

