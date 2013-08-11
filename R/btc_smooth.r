#! /usr/bin/rscript 

library(tseries)

usdmga <- read.csv('http://www.quandl.com/api/v1/datasets/QUANDL/USDMGA.csv?&trim_start=2012-08-08&trim_end=2013-08-07&sort_order=desc', colClasses=c('Date'='Date'))
usdeur <- read.csv('http://www.quandl.com/api/v1/datasets/QUANDL/USDEUR.csv?&trim_start=2012-08-08&trim_end=2013-08-07&sort_order=desc', colClasses=c('Date'='Date'))
eurmga <- read.csv('http://www.quandl.com/api/v1/datasets/QUANDL/EURMGA.csv?&trim_start=2012-08-08&trim_end=2013-08-07&sort_order=desc', colClasses=c('Date'='Date'))
mtgoxusd <- read.csv('http://www.quandl.com/api/v1/datasets/BITCOIN/MTGOXUSD.csv?&trim_start=2012-08-08&trim_end=2013-08-07&sort_order=desc', colClasses=c('Date'='Date'))

usdmga.pdf <- diff(log(as.ts(usdmga$Rate)))
eurmga.pdf <- diff(log(as.ts(eurmga$Rate)))
usdeur.pdf <- diff(log(as.ts(usdeur$Rate)))

plot(usdmga.pdf,type="l",lty="solid", lwd = 1, col = "blue", ylab = "Log Return")
lines(eurmga.pdf, lty = "solid", lwd = 1, col = "red")
legend(x = "topleft", legend=c("USD/MGA", "EUR/MGA"), lwd = 2,lty = c("solid", "solid"),col=c("blue", "red"))

library(PerformanceAnalytics)


usdmga.dates = as.Date(usdmga$Date,format="%Y-%m-%d")
#log return
usdmga.lret = zoo (x=usdmga.pdf, order.by=usdmga.dates)
#rate
usdmga.rate = zoo (x=usdmga$Rate, order.by=usdmga.dates)

eurmga.dates = as.Date(eurmga$Date,format="%Y-%m-%d")
#log return
eurmga.lret = zoo (x=eurmga.pdf, order.by=eurmga.dates)
#rate
eurmga.rate = zoo (x=eurmga$Rate, order.by=eurmga.dates)


# create merged time series
usdmga_eurmga.rate = merge(usdmga.rate, eurmga.rate)
plot(usdmga_eurmga.rate, lwd=c(2,2), plot.type="multiple", col=c("black", "blue"), lty=c("solid", "dotted"), ylab=c("USD/MGA", "EUR/MGA"), main="")

usdmga_eurmga.lret = merge(usdmga.lret, eurmga.lret)
plot(usdmga_eurmga.lret, lwd=c(2,2), plot.type="multiple", col=c("black", "blue"), lty=c("solid", "dotted"), ylab=c("USD/MGA", "EUR/MGA"), main="")

plot(usdmga.lret,type="l",lty="solid", lwd = 1, col = "blue", ylab = "Log Return")
lines(eurmga.lret, lty = "solid", lwd = 1, col = "red")
legend(x = "topleft", legend=c("USD/MGA", "EUR/MGA"), lwd = 2,lty = c("solid", "solid"),col=c("blue", "red"))

# Not same size
btcusd.pdf <- diff(log(as.ts(mtgoxusd$Weighted.Price)))

btcusd.dates = as.Date(mtgoxusd$Date,format="%Y-%m-%d")
#log return
btcusd.lret = zoo (x=btcusd.pdf, order.by=btcusd.dates)
#rate
btcusd.rate = zoo (x=mtgoxusd$Weighted.Price, order.by=btcusd.dates)

# Function filering week days
is.weekend <- function(x) { x <- as.POSIXlt(x);  x$wday > 5 | x$wday < 1 }

# Adjusting Size
btcusd.lret <- btcusd.lret[!is.weekend(time(btcusd.lret))]
btcusd.rate <- btcusd.rate[!is.weekend(time(btcusd.rate))]

# create merged time series
usdmga_btcusd.rate = merge(usdmga.rate, btcusd.rate)
plot(usdmga_btcusd.rate, lwd=c(2,2), plot.type="multiple", col=c("green", "blue"), lty=c("solid", "dotted"), ylab=c("USD/MGA", "BTC/USD"), main="")

usdmga_btcusd.lret = merge(usdmga.lret, btcusd.lret)
plot(usdmga_btcusd.lret, lwd=c(2,2), plot.type="multiple", col=c("black", "blue"), lty=c("solid", "dotted"), ylab=c("USD/MGA", "EUR/MGA"), main="")

plot(usdmga.lret,type="l",lty="solid", lwd = 1, col = "blue", ylab = "Log Return")
lines(btcusd.lret, lty = "solid", lwd = 1, col = "red")
legend(x = "topleft", legend=c("USD/MGA", "BTC/USD"), lwd = 2,lty = c("solid", "solid"),col=c("blue", "red"))


# Regression
r <-lm(usdmga.pdf~eurmga.pdf )
# Beta Estimates
b <- summary(r)$coefficients[2,1]

