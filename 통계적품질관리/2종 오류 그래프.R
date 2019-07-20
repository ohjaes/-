a <- rnorm(1000,0,1)
x <- -10:10
plot(a)
c <- dnorm(a,0,1)
curve((1/sqrt(0.5*pi))*exp(-(x^2)/0.5),from = -3,to = 4)
par(new=T)
curve((1/sqrt(0.5*pi))*exp(-((x-1)^2)/0.5),from = -3,to = 4)
