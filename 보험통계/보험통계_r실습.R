setwd("C:/Users/user/Desktop/오재훈/대학교_자료/보험통계/data")
library(MASS)
##이산형변수 링크펑션 함수 코드
logitexp <- function(exposure = 1) 
{ linkfun <- function(mu) {            
  eta <- if (any(exposure-mu <= 0)) log((mu)/abs(mu-exposure)) else log((mu)/(exposure-mu))
  eta 
}

linkinv <- function(eta) {
  thresh <- -log(.Machine$double.eps)
  eta <- pmin(thresh, pmax(eta, -thresh))
  exposure*(exp(eta)/(1 + exp(eta)))
}

mu.eta <- function(eta) 
{
  thresh <- -log(.Machine$double.eps)
  res <- rep(.Machine$double.eps, length(eta))
  res[abs(eta) < thresh] <- ((exposure*exp(eta))/(1 + exp(eta))^2)[abs(eta) < thresh]
  res
}

valideta <- function(eta) TRUE 
link <- paste("logexp(", exposure, ")", sep="") 
structure(list(linkfun = linkfun, linkinv = linkinv, mu.eta = mu.eta, 
               valideta = valideta, name = link), class = "link-glm") } 
####################################################################################
x <- rnorm(10)
y <- rpois(10,5)
res <- glm(y~x, family = poisson)
sum(rstandard(res))
summary(res)


dat <- read.csv("Birth.csv",header=T)
dat <- dat[,c(1,2)]
dat
head(dat)
res <- glm(children~age, family = "poisson",data=dat)
summary(res)
anova(res)
sum(rstandard(res))
sum(resid(res))

res2 <- glm(children~age, family = poisson(link="identity"),data= dat,start=c(1,1) )
summary(res2)
warnings()

res2 <- glm(children~age, family = poisson(link="identity"),data= dat,start=c(-0.965,0.057))
summary(res2)
warnings()

##
dat2 <- read.csv("diabetes.csv",header=T)
dat2
dat2 <- dat2[-17,]
dat2
res21 <- glm(deaths~offset(log(popn))+gender+age,family="poisson",data=dat2)
summary(res21)
##å?̶? ????
dat2$age <- relevel(dat2$age, ref="45-54")
dat2$gender <- relevel(dat2$gender,ref="Male")
res20 <- glm(deaths/popn~gender+age,family="poisson",data=dat2)
summary(res20)
res21 <- glm(deaths~offset(log(popn))+gender+age,family="poisson",data=dat2)
summary(res21)
anova(res21)


##
library(MASS)
stepAIC
stepAIC(res21)
AIC(res21)
res21_1 <- glm(deaths~offset(log(popn))+gender+age+(age^2),family="poisson",data=dat2)
AIC(res21_1)
res21_2 <- glm(deaths~offset(log(popn))+gender+agemidpt,family="poisson",data=dat2)
AIC(res21_2)
res21_2 <- glm(deaths~offset(log(popn))+gender+agemidpt+I(agemidpt^2),family="poisson",data=dat2)
AIC(res21_2)


##
dat3 <- read.csv("Third_party_claims.csv",header=T)
dat3
head(dat3)
res31 <- glm(claims~offset(log(population))+I(log(accidents)),family = "poisson",data=dat3)
summary(res31)
15837/174
a <- residuals(res31,type = "pearson")
b <- residuals(res31,type = "deviance")
sum(a^2)/174
sum(b^2)/174
library(MASS)
resnb <- glm.nb(claims~offset(log(population))+I(log(accidents)),data=dat3)
summary(resnb)
AIC(res31)
AIC(resnb)

a <- as.numeric(logLik(resnb))
b <- as.numeric(logLik(res31))
2*(a - b)
qchisq(0.9,1)

########################
dat4 <- read.csv("Third_party_claims.csv",header=T)
res41 <- glm(claims~offset(log(population))+I(log(accidents)),family = "poisson",data=dat4)
summary(res41)

resq <- glm(claims~offset(log(population))+I(log(accidents)),family = "quasipoisson",data=dat4)
summary(resq)

######logistic regression
dir()
datc <- read.csv("car.csv",header=T)
datc
resc <- glm(clm~veh_value, family = binomial,data=datc)
summary(resc)

resc <- glm(cbind(clm,1-clm)~veh_value, family = binomial, data=datc)
summary(resc)

resl <- glm(clm~veh_value,family = binomial(logitexp(datc$exposure)),data=datc)
summary(resl)

res <- glm(clm~area,family = binomial, data=datc)
summary(res)
f <- fitted(res)
yol <- (f > 0.24)
head(yol)
cbind(yol,f)
table(yol,f)
sum(yol)/length(yol)

dat <- read.csv("car.csv",header=T)
head(dat)
res <- glm(clm~factor(agecat),family = binomial,data=dat)
summary(res)
install.packages("pROC")
library(pROC)
fv <- fitted(res)
rr <- roc(dat$clm,fv)
rr
plot(rr)

install.packages("VGAM")
library(VGAM)
dir()
datx <- read.csv("injury.csv",header=T)
head(datx)
attach(datx)
agex <- C(factor(agecat),base=7)
roaduserclass <- C(factor(roaduserclass),base=1)
sex <- C(factor(sex),base=2)
resl <- vglm(degree~factor(agecat)+factor(roaduserclass)+factor(sex)+factor(sex)*factor(agecat),family = cumulative(parallel=T),data=datx,weights = number)
summary(resl)

resl <- vglm(degree~factor(agecat)+factor(roaduserclass)+factor(sex)+factor(sex)*factor(agecat),family = multinomial,data=datx,weights = number)
summary(resl)

-53695.73+53851.68


################### 기말고사 ####################################
dir()
dat <- read.csv("persinj.csv",header = T)
res <- glm(total~legrep+op_time,family = Gamma(link=log),data=dat)
summary(res)
gamma.dispersion(res)


dat <- read.csv("runoff_triangle.csv",header = T)
dat
res <- glm(Y~accyear+devyear,family = Gamma(link=log),data=dat)  ##이거 0값 있거나 음수면 감마로 안돌아가서 에러난다.
which(dat$Y<0)
dat$Y[47] <- 1  ##감마 돌리려고 1넣은 것
dat$accyear <- factor(dat$accyear)
dat$devyear <- factor(dat$devyear)
res <- glm(Y~accyear+devyear,family = Gamma(link=log),data=dat)
summary(res)
gamma.dispersion(res)
##Y에 내가 평균값 넣어본 거 뿐
#dat3 <- dat
# dat3$Y[47] <- sum(dat3$Y[-47])/(length(dat3$Y)-1)
# res3 <- glm(Y~accyear+devyear,family = Gamma(link=log),data=dat3)
# summary(res3)
# gamma.dispersion(res3)
res2 <- glm(Y~accyear,family = Gamma(link=log),data=dat)
summary(res2)
chis_statistics <- 2 * (logLik(res)-logLik(res2))
logLik(res)
logLik(res2)
1 - pchisq(chis_statistics,df=9)
1 - pchisq(29.92721,df=9)

res3 <- glm(Y~devyear,family = Gamma(link=log),data=dat)
summary(res3)
chis_statistics2 <- 2 * (logLik(res)-logLik(res3))
logLik(res)
logLik(res3)
1 - pchisq(chis_statistics2,df=9)
1 - pchisq(3.32033,df=9)


dat <- read.csv("car.csv", header=T)
head(dat,30)
res <- glm(claimcst0 ~ factor(agecat)+gender+area, family = inverse.gaussian(link=log),data=dat)  ##에러뜬다 인버스 가우시안은 0 허용 안한다. 양수만 가능

res <- glm(claimcst0 ~ factor(agecat)+gender+area, family = inverse.gaussian(link=log),data=subset(dat,clm==1))
summary(res)

dat2 <- dat
head(dat2,30)
which(dat2$area == "F",arr.ind = T)
dat2[which(dat2$area == "F"),9] <- "E"
res2 <- glm(claimcst0 ~ factor(agecat)+gender+area, family = inverse.gaussian(link=log),data=subset(dat2,clm==1))
summary(res2)
2*(logLik(res) - logLik(res2))
qchisq(0.95,df=1)
1 - pchisq(2.194827,df=1)


#트위디
install.packages("tweedie")
library(tweedie)
power = 1.5;mu=1;phi=1;y<-seq(0,6,length=1500)
fy <- dtweedie(y=y,phi=phi,mu=mu,power=power)
plot(y,fy,ylab="density")


install.packages("ISLR")
library(ISLR)
attach(Wage)
res <- lm(wage~poly(age,4))
summary(res)
res2 <- lm(wage ~ age+I(age^2)+I(age^3)+I(age^4))
summary(res2)
plot(fitted(res),fitted(res2))
abline(0,1)  #y햇은 정확히 일치

table(cut(age,4))
res <- lm(wage ~ cut(age,4))
summary(res)
