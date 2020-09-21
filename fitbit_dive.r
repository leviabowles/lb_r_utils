


library(httr)
library(ggplot2)
library(dplyr)
library(e1071)
library(fitdistrplus)


  
fbep = oauth_endpoint(request = "https://api.fitbit.com/oauth2/token",
                      authorize = "https://www.fitbit.com/oauth2/authorize",
                      access = "https://api.fitbit.com/oauth2/token")
app = oauth_app(appname = "levi_pull",
                key = mykey,
                secret = mysecret)

sco = "activity"
fitbit_token = oauth2.0_token(fbep, app,
                              scope = sco, use_basic_auth = TRUE)



resp <- GET(url = "https://api.fitbit.com/1/user/-/activities/steps/date/today/1y.json", 
            config(token = fitbit_token))
xx = unlist(content(resp))
xy = xx[names(xx) == "activities-steps.dateTime"]
xz = xx[names(xx) != "activities-steps.dateTime"]
steps_day = data.frame(dat = as.Date(xy), steps = as.numeric(as.character(xz)))

steps_day = steps_day[steps_day$steps !=0 , ]
steps_day = steps_day[steps_day$dat != Sys.Date() , ]
hist(steps_day$steps)
descdist(steps_day$steps)



resp <- GET(url = "https://api.fitbit.com/1/user/-/activities/floors/date/today/1y.json", 
            config(token = fitbit_token))
xx = unlist(content(resp))
xy = xx[names(xx) == "activities-floors.dateTime"]
xz = xx[names(xx) != "activities-floors.dateTime"]
floors_day = data.frame(dat = as.Date(xy), floors = as.numeric(as.character(xz)))
floors_day = floors_day[floors_day$floors != 0 , ]
floors_day = floors_day[floors_day$dat != Sys.Date() , ]
hist(floors_day$floors)
descdist(floors_day$floors)



resp <- GET(url = "https://api.fitbit.com/1/user/-/body/log/weight/date/2019-05-31.json", 
            config(token = fitbit_token))
resp


floors_day$new = ifelse(floors_day$dat > Sys.Date()-30,1,0)

t.test(floors_day$floors~factor(floors_day$new))

steps_day$new = ifelse(steps_day$dat >  Sys.Date()-30,1,0)

t.test(steps_day$steps~factor(steps_day$new))


ggplot(steps_day,aes(x = dat, y = steps))+
  geom_point()+
  geom_smooth()+
  geom_hline(yintercept = (mean(steps_day$steps[steps_day$new ==1])), size = 2)


ggplot()+
  geom_density(aes(steps_day$steps),colour = "red", fill = 'red', alpha = .5, size = 1.5)+
  geom_density(aes(steps_day$steps[steps_day$new ==1]), colour = "green", fill = 'green', alpha = .5, size = 1.5)

ggplot(steps_day,aes(steps))+
  geom_histogram(colour = "red", fill = 'red', alpha = .5, size = 1.5) 

ggplot(floors_day,aes(floors))+
  geom_density(colour = "red", fill = 'red', alpha = .5, size = 1.5) 

ggplot(floors_day,aes(floors))+
  geom_histogram(colour = "red", fill = 'red', alpha = .5, size = 1.5) 

nn = merge(floors_day, steps_day, by = 'dat')

xxx = lm(floors~steps, nn)
summary(xxx)
nn$wd = weekdays(nn$dat)

ggplot(steps_day,aes(steps))+
  geom_histogram(colour = "red", binwidth = 1000, fill = 'red', alpha = .5, size = 1.5) 




ggplot(nn, aes(x = steps, y = floors)) +
  geom_point()+
  geom_smooth() +
  facet_wrap(~wd)
         
ggplot(nn,aes(steps, group = wd, colour = wd, fill = wd))+
  geom_density(alpha = .5, size = 1.5) 

ggplot(nn,aes(steps, group = wd, colour = wd, fill = wd))+
  geom_density(alpha = .5, size = 1.5) +
  facet_wrap(~wd)



nn %>% group_by(wd) %>% summarize(mean=mean(steps), kurt=kurtosis(steps), skew = skewness(steps))
