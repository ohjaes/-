#1
data <- c(0.78,4.33,0.15,0.29,14.21,0.09,4.75,0.78,
          9.59,11.70,0.20,2.93,1.79,5.81,2.82,1.94,
          2.26,0.22,0.29,3.65,0.54,5.17,1.30,3.52,
          8.13,125.93,13.72,3.47,14.81,21.01,4.57,20.10,
          3.16,1.30,0.96,1.73,0.68,0.41,74.74,4.98)
qq <- qqplot(1:40,data,xlab = 'index',ylab = 'data',main='정규확률분포표')
qqline(data)


ldata <- log(data)
lqq <- qqplot(1:40,data,xlab = 'index',ylab = 'ldata',main='log정규확률분포')
qqline(ldata)

library(MASS)
result <- fitdistr(data,'weibull')
shape <- result[1][[1]][[1]]
scale <- result[1][[1]][[2]]

x=data
y=qweibull( ppoints(40), shape=shape, scale=scale )
plot(data,main = '와이블확률분포표')
abline(line( x, y ), col="blue")
##와이블 분포가 가장 잘 맞는다. 와이블 분포로 적합 시에만 데이터들이 거의 적합선 근처에 분포하고 있다.

##2
#2-a
lamda = 0.02
f1 <- lamda*exp(-lamda)
f1
#2-b
f0 <- exp(-lamda)
result = 1-f0
result
#2-c
lamda = 0.01
f0 <- lamda^0*exp(-lamda)
result <- 1-f0
result
#공정에서 하나 이상의 결함을 가질 확률이 훨씬 작아진다.

##3
#3-a
0.005^4
#3-b
1-(0.995)^4
#3-c 잘 모르겟음
n=4
p=0.005
#200 * 0.05는 1이니까 200일?

##4
1-2*pnorm(4.95,5,0.02)

##5
1-2*pnorm(5000,7500,1000)
1-2*pnorm(5000,7500,500)
