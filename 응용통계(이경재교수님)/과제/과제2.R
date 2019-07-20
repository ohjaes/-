hpdsample = function(theta,level=0.95){
  N = length(theta)
  theta.sort = sort(theta)
  M = ceiling(N*level)
  nci = N-M
  ci.width = rep(0,nci)
  for (i in 1:nci) {
    ci.width[i] = theta.sort[i+M] - theta.sort[i]
  }
  index = which.min(ci.width)
  hpd = c(theta.sort[index],theta.sort[index+M])
  return(hpd)
}

#3
phi_theta = 1/9
sum = 0
likelihood = function(theta){
  sum = 0
  for (i in seq(0.1,0.9,by=0.1)) {
    sum = sum + (i^3)*(1-i)^2
    sum <<- sum
  }
  result = theta^3 * (1-theta)^2 / sum
  return(result)
}
likelihood(0.5)

sum1 = 0
for (i in seq(0.1,0.9,by=0.1)) {
  sum1 = sum1 + likelihood(i)
  sum1 <<- sum1
}
sum1

x <- seq(0.1,0.9,by=0.1)
y <- c()
for (i in seq(0.1,0.9,by=0.1)) {
  y <- c(y,likelihood(i))
  print(likelihood(i))
}
plot(x,y,xlab = "theta",ylab = "posterior")
0.5^5




#2
x <- seq(0,1,length = 500)
prior <- dbeta(x,0.44,1.76)
posterior <- dbeta(x,0.44+2,1.76+8)
plot(x,prior,type="l",lty=1,col=1,xlab = "theta",ylab = "prior,posterior")
lines(x,posterior,lty=2,col = 2)
legend(0.6,15,legend = c("Beta(0.44,1.76)","Beta(2.44,9.76)"),lty=c(1,2),col=c(1,2))


theta <- rbeta(1000,2.44,9.76)
hpd = hpdsample(theta)
plot(x,posterior,type='l',xlab = "theta",ylab = "density")
abline(v=hpd,lty=2)
text(0.18,1.3,"95% hpd interval")

x <- seq(-10,10,length = 1000)
theta1 = rbeta(1000,0.44,1.76)
theta2 = rbeta(1000,2.44,9.76)
x1 <- log(theta1/(1-theta1))
x2 <- log(theta2/(1-theta2))
x3 <- log((theta1/(1-theta1))/(theta2/(1-theta2)))
hpd1 = hpdsample(x1)
hpd2 = hpdsample(x2)
hpd3 = hpdsample(x3)
plot(density(x1),type='l',lty=1,col=1,ylim=c(0,0.5))
lines(density(x2),lty=2,col=2)
abline(v=hpd2,lty=3,col=3)
legend(-22,0.45,legend = c("prior","posterior","95% hpd interval"),lty = c(1,2,3),col=c(1,2,3))
hpd2 #95% hpd interval



#6
theta1 = rbeta(1000,11,11)
theta2 = rbeta(1000,15,7)
xi = log((theta1/(1-theta1))/(theta2/(1-theta2)))
hpd = hpdsample(xi)
plot(density(xi),type='l',xlab = "odds ratio",ylab="posterior density")
abline(v=hpd,lty=2)
text(mean(xi),0.06,"95% hpd interval")
mean(xi)  #추정치
sd(xi)/sqrt(1000)  #표준오차
hpd  #95% hpd interval

