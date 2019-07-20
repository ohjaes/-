

## example ##
dat1 <- read.table("Reg3_dat1.txt", header = T)
str(dat1)
head(dat1)

plot(ybar ~ day, 
     data = dat1)


f1 <- lm(ybar ~ day, 
         data = dat1)

f2 <- lm(ybar ~ day, 
         weights = dat1$n,
         data = dat1)

list(
  ols = round(summary(f1)$coef,4),
  wls = round(summary(f2)$coef,4)
)


# for checking residuals for wls
residuals(f2)
residuals(f2, "pearson")
residuals(f2) * sqrt(f2$weights)

plot(x = dat1$day,
     y = rstudent(f1))

plot(x = dat1$day,
     y = rstudent(f2))

plot(x = dat1$day,
     y = rstudent(f2) * sqrt(f2$weights))



# for checking estimates and std.err
X <- model.matrix(f1)
W <- diag(dat1$n)
y <- dat1$ybar

solve(t(X)%*%W%*%X)%*% t(X)%*%W%*%y  # hat(beta)
c(summary(f2)$sigma,
  sqrt(sum(dat1$n * residuals(f2)^2)/f1$df.residual))  # hat(sigma)
sqrt(diag(solve(t(X)%*%W%*%X) * summary(f2)$sigma^2))  # se(beta)

wy <- diag(sqrt(dat1$n)) %*% y
wx <- diag(sqrt(dat1$n)) %*% X
summary(lm(wy ~ wx - 1))




## simulation ##
nsim <- 1000


# setting 1 : OLS regression
f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  
  x1 <- rnorm(100)
  x2 <- rnorm(100)
  
  coef1 <- c(0, 1, 1)
  err1 <- rnorm(100, 0, 1)
  y <- cbind(1, x1, x2)%*%coef1 + err1
  d <- cbind.data.frame(y, x1, x2)
  f <- lm(y ~ x1 + x2, data = d)
  
  return(f)
})

apply(do.call("rbind", lapply(f.list, coef)), 2, mean)
sum(sapply(f.list, function(f) summary(f)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f)$coef["x2", "Pr(>|t|)"]) <= 0.05) / nsim



# setting 2 : WLS regression
f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  print(L)
  x1 <- rnorm(100, 0, 0.2)
  x2 <- runif(100, min = 0.2, max = 2)
  sig2 <- 0 + 4*x2^2 + rnorm(100, 0, 0.01)   
  
  coef1 <- c(0, -1, 1)
  err1 <- rnorm(100, 0, sqrt(sig2))
  y <- cbind(1, x1, x2)%*%coef1 + err1
  d <- cbind.data.frame(y, x1, x2)
  f1 <- lm(y ~ x1 + x2, data = d)
  f2 <- lm(y ~ x1 + x2, data = d, weights = 1/d$x2)
  
  # plot(x = d$x2, y = rstudent(f1))
  # plot(x = d$x2, y = rstudent(f2))
  
  return(list(f1=f1, f2=f2))  
})

apply(do.call("rbind", lapply(f.list, function(f) coef(f$f1))), 2, mean)
apply(do.call("rbind", lapply(f.list, function(f) coef(f$f2))), 2, mean)

sum(sapply(f.list, function(f) summary(f$f1)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f$f1)$coef["x2", "Pr(>|t|)"]) <= 0.05) / nsim

sum(sapply(f.list, function(f) summary(f$f2)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f$f2)$coef["x2", "Pr(>|t|)"]) <= 0.05) / nsim



# setting 3 : dispersion modeling
library(dglm)

f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  # print(L)
  x1 <- rnorm(500, 0, 0.2)
  x2 <- runif(500)
  
  coef0 <- c(0, 4)
  mu0 <- exp(cbind(1, x2)%*%coef0)
  k0 <- 1
  sig0 <- rgamma(n = 500, shape = 1/k0, scale = mu0*k0)

  # zfit <- glm(sig0 ~ x2, family = "Gamma" (link = "log"))
  # summary(zfit)
  # summary(zfit)$dispersion

  coef1 <- c(0, -1, 1)
  err1 <- rnorm(500, 0, sqrt(sig0))
  y <- cbind(1, x1, x2)%*%coef1 + err1
  d <- cbind.data.frame(y, x1, x2)
  f1 <- lm(y ~ x1 + x2, data = d)
  f2 <- dglm(formula = y ~ x1 + x2, dformula = ~ x2, 
             dlink = "log", data=d)
  
  # plot(x = x2, y = rstudent(f1))
  # s.res <- rstudent(f2)/sqrt(fitted(f2$dispersion.fit))
  # plot(x = x2, y = s.res)
  
  return(list(f1=f1, f2=f2))  
})

apply(do.call("rbind", lapply(f.list, function(f) coef(f$f1))), 2, mean)
apply(do.call("rbind", lapply(f.list, function(f) coef(f$f2))), 2, mean)

apply(do.call("rbind", 
              lapply(f.list, function(f) summary(f$f2)$dispersion.summary$coef[,1])), 2, mean)

sum(sapply(f.list, function(f) summary(f$f1)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f$f1)$coef["x2", "Pr(>|t|)"]) <= 0.05) / nsim

sum(sapply(f.list, function(f) summary(f$f2)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f$f2)$coef["x2", "Pr(>|t|)"]) <= 0.05) / nsim


# End..



