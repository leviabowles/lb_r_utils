install.packages("ragtop")
install.packages("RQuantLib")
install.packages("quantmod")
install.packages("copula")
library(ragtop)
library(RQuantLib)
blackscholes(callput=1, S0=100, K=90, r=0.03, time=1,
             vola=0.5, default_intensity=0.07)
dd = RQuantLib::EuropeanOptionImpliedVolatility(type="call", value=11.10, underlying=100,
                                     strike=100, dividendYield=0.01, riskFreeRate=0.03,
                                     maturity=0.5, volatility=0.4)


library(quantmod)
start <- as.Date("2012-01-01")
end <- as.Date("2019-02-28")

dd = getSymbols("SWPPX", src = "yahoo", from = start, to = end)
candleChart(SWPPX, up.col = "black", dn.col = "red", theme = "white")
library(tseries)
dm =ts(SWPPX$SWPPX.Close)
SWPPX = data.frame(SWPPX)
gar = tseries::garch(dm)
sl = data.frame(gar$fitted.values)
sl$dat = as.Date(row.names(SWPPX))
sl$actual = SWPPX$SWPPX.Close

library(ggplot2)
ggplot(sl)+
  geom_point(aes(x = sl$dat,y = sl$sigt),colour = "red") +
  geom_point(aes(x = sl$dat,y = sl$actual), colour = "green")
library(dplyr)
sl = mutate(sl, actual_lag = lead(actual, order_by =dat), 
            pred_lag = lead(sigt, order_by =dat))

sl$pred =  (sl$sigt - sl$actual_lag)
sl$pred_fake =  (sl$sigt - sl$pred_lag)
sl$act_test =  (sl$actual - sl$actual_lag)
sl = sl[complete.cases(sl),]
cor(sl$pred, sl$act_test)
cor(sl$pred_fake, sl$act_test)



library(copula)
tauAMH(c(0, 2^-40, 2^-20))
curve(tauAMH,  0, 1)
curve(tauAMH, -1, 1)# negative taus as well
curve(tauAMH, 1e-12, 1, log="xy") # linear, tau ~= 2/9*theta in the 




library(copula)
tauClayton <- Vectorize(function(theta) tau(claytonCopula(theta, dim=2)))
plot(tauClayton, -1, 10, xlab=quote(theta), ylim = c(-1,1), n=1025)
xx = frankCopula(0.5, d = 10)
x <- rCopula(50, xx)
