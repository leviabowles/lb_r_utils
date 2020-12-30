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
a = add_seasonality(a)
a = complete_only(a)
a = time_slice(a,increment = 100)
a = time_build_models(a,c("lm"),iter = 100)
model_metrics(a)


