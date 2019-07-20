##1.
x <- c(145,137,121,154,148,129,134)
y <- c(154,141,156,137,120,131,127,135)
x<- x/100
y <- y/100
t.test(x, y, mu = 0, conf.level=0.95, paired = F,
       alternative = "two.sided",
       var.equal=T)
#합동표본분산: ((n-1)s^2+(n-1s^2))/(n+n-2)

##2.
#답: a의 검정은 기술자 1과 기술자 2의 측정이 같은지 아닌지를 보는것이다.
#    만약 귀무가설이 기각 되었다면 같은 금속 부품의 표면 조도를 측정해도 기술자1과 기술자2의 측정은 같다고 할 수 없다.

##3.
t.test(x, y, mu = 0, conf.level=0.95, paired = F,
       alternative = "two.sided",
       var.equal=T)

##4.
var.test(x,y)

##5.
var.test(x,y)

##6.
#(N-1)*s^2 / Chisquare임계치(alpha/2, df)
(8-1)*var(y)/qchisq(0.025,7)
(8-1)*var(y)/qchisq(0.975,7)

##7.
qqnorm(x,main = "기술자1")
qqline(x)
qqnorm(y, main = "기술자2")
qqline(y)


#######2.
#1,2
p = 65/500
n = 500
z = (p - 0.08)/sqrt(0.08*(1-0.08)/500)
z
pvalue = 2*(1-pnorm(z,0,1))
pvalue
#3.
p = 65/500
za = qnorm(0.025,0,1)
p + (-za)*sqrt(p*(1-p)/500)


#############3.
z = 25+qnorm(0.975,0,1)*sqrt(16/12)
z2=(z-30)/sqrt(16/12)
pnorm(z2,0,1)

###############4.
#b
z = (0.11-0.15)/sqrt(0.11^2/100)
2*pnorm(z,0,1)
