


## Nonlinear regression ##

# y = exp(b0 + b1*x1) + err
ny <- 100

# set.seed(1)
x <- sort(runif(n = ny, min = 0, max = 10))
e <- rnorm(n = ny)
b <- c(1, 1)
y <- exp(cbind(1,x)%*%b) + e
summary(y)

plot(x = x,
     y = y)
lines(supsmu(x = x, 
             y = y), 
      lty = 3,
      col = 4)


# initial solver
b0 <- runif(2)
D0 <- cbind(exp(cbind(1,x) %*% b0), 
            exp(cbind(1,x) %*% b0)*x)
f0 <- exp(cbind(1,x) %*% b0)
b1 <- b0 + solve(t(D0) %*% D0) %*% t(D0) %*% (y - f0)

# iteration
tol <- sum(abs(b1 - b0))
iter <- 1

while(tol > 0.1) {
  print(iter)
  b0 <- b1  # renew estimates
  
  D0 <- cbind(exp(cbind(1,x) %*% b0), 
              exp(cbind(1,x) %*% b0)*x)
  f0 <- exp(cbind(1,x) %*% b0)
  b1 <- b0 + solve(t(D0) %*% D0) %*% t(D0) %*% (y - f0)
  
  tol <- sum(abs(b1 - b0))  # check convergence
  iter <- iter + 1  
}

# final estimates
cbind.data.frame(esti=b1, 
                 true=b,
                 lm=coef(lm(log(y) ~ x)))

# fitted values
f <- exp(cbind(1,x)%*%b1)  
points(x = x,
       y = f,
       type = "l",
       col = 2)
# ----- ----- ----- ----- ----- #





## shrinkage estimation When n << p ##
ny <- 100
nx <- 200

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx/10, rep(1, nx)), ncol=1)
mu <- cbind(1,x) %*% b

sig <- 1
e <- rnorm(n=ny, mean=0, sd=sig)

y <- mu + e
hist(y)

d <- cbind.data.frame(y, x) 
head(d); dim(d);

# ordinary reg
f <- lm(y ~ x,
        data = d)
summary(f)


# ridge reg
library(mpath)

set.seed(1)
g.cv10 <- cv.glmreg(y ~ .,
                    family = "gaussian",
                    alpha = 0,  # ridge penalty
                    data = d,
                    lambda = seq(0.01, 1, by = 0.01))

abline(v = log(g.cv10$lambda.optim),
       col = "red",
       lty = 2)

g.tune <- glmreg(y ~ .,
                 family = "gaussian",
                 alpha = 0,
                 data = d, 
                 lambda = g.cv10$lambda.optim)
coef(g.tune)

# check over-fitting
head(
  cbind.data.frame(
    y = y, 
    lm = fitted(f),
    ridge = predict(g.tune, 
                    newx = d, 
                    type = "response")
  ), 
  n = 10L
)

# reg-coef
cbind.data.frame(
  true = b,
  lm = coef(f),
  ridge = coef(g.tune)
)
# ----- ----- ----- ----- ----- #





## Nonparametric regression ##
library(MASS)  # for mcycle dataset
data(mcycle)
head(mcycle); dim(mcycle);

# Orthogonal polynomial regression
f1 <- lm(accel ~ times, data=mcycle)
f2 <- lm(accel ~ poly(times,3), data=mcycle);   
f3 <- lm(accel ~ poly(times,5), data=mcycle);   
f4 <- lm(accel ~ poly(times,7), data=mcycle);   
f5 <- lm(accel ~ poly(times,9), data=mcycle);   

plot(x=mcycle$times, y=mcycle$accel, 
     xlab="Time in milliseconds after impact", 
     ylab="Accelation in g", 
     main="",
     cex.lab=1.25, mgp=c(2.5,1,0), cex.main=1.5)

lines(x=mcycle$times, y=fitted(f1), lty=1, pch=16, col="black",  lwd=1)
lines(x=mcycle$times, y=fitted(f2), lty=2, pch=16, col="green",  lwd=1)
lines(x=mcycle$times, y=fitted(f3), lty=3, pch=16, col="red",    lwd=1)
lines(x=mcycle$times, y=fitted(f4), lty=4, pch=16, col="darkred",lwd=1)
lines(x=mcycle$times, y=fitted(f5), lty=4, pch=16, col="purple", lwd=1)

legend("topleft", c("1st order", 
                    "3rd order", 
                    "5th order", 
                    "7th order", 
                    "9th order"), 
       col=c("black", "green", "red", "darkred", "purple"), 
       inset=0.05, lty=c(1,2,3,4,5), cex=0.8, lwd=1)


# Spline models
library(splines)
g1 <- lm(accel ~ bs(times, df=9), data=mcycle)  # B-spline
g2 <- lm(accel ~ ns(times, df=9), data=mcycle)  # natural cubic spline
g3 <- smooth.spline(x=mcycle$times, y=mcycle$accel) # smoothing spline
# smooth.spline choose df automatically using GCV

plot(x=mcycle$times, y=mcycle$accel, 
     xlab="Time in milliseconds after impact", 
     ylab="Accelation in g", 
     main="Spline models",
     cex.lab=1.25, mgp=c(2.5,1,0), cex.main=1.5)

lines(x=mcycle$times, y=fitted(g1), lty=1, pch=16, col="black", lwd=1)
lines(x=mcycle$times, y=fitted(g2), lty=2, pch=16, col="green", lwd=1)
lines(x=mcycle$times, y=fitted(g3), lty=3, pch=16, col="red",   lwd=1)

legend("topleft", c("B-spline (6 knots)", 
                    "Regression spline (8 knots)", 
                    "Smoothing spline"), 
       col=c("black", "green", "red"), 
       inset=0.05, lty=c(1,2,3), cex=0.8, lwd=1)



# Spline models by edf
library(splines)

dfs  <- c(2, 3, 5, 7, 9)
h.list <- lapply(as.list(dfs), function(x) {
  smooth.spline(x=mcycle$times, y=mcycle$accel, df = x)
})

lapply(h.list, function(x) x$lambda)  # checking lambdas ..

plot(x=mcycle$times, y=mcycle$accel, 
     xlab="Time in milliseconds after impact", 
     ylab="Accelation in g", 
     main="Spline models",
     cex.lab=1.25, mgp=c(2.5,1,0), cex.main=1.5)

cols <- c("black", "green", "red", "darkred", "purple")
for(i in 1:length(dfs)) {
  lines(x=mcycle$times, y=fitted(h.list[[i]]), 
        lty=i, col=cols[i], pch=16, lwd=1)
}

legend("topleft", 
       c("spline, df=2", 
         "spline, df=3", 
         "spline, df=5", 
         "spline, df=7", 
         "spline, df=9"), col=cols, 
       inset=0.05, lty=c(1,2,3,4,5),cex=0.8, lwd=1.5)



# Generalized additive models
library(mgcv)  # for gam modeling

# 1) mcycle dataset
f <- gam(accel ~ s(times), 
         data = mcycle)
summary(f)

plot(x=mcycle$times, y=mcycle$accel, 
     xlab="Time in milliseconds after impact", 
     ylab="Accelation in g", 
     main="GAM",
     cex.lab=1.25, mgp=c(2.5,1,0), cex.main=1.5)

lines(x = mcycle$times,
      y = fitted(f),
      col = "red")

legend("topleft", c("gam"), col = "red",
       inset=0.05, cex=0.8, lwd=1)

plot(f)  # smoothing plot


# 2) Article production by graduate students in biochemistry Ph.D. programs
# Long and Freese (2001), 
# REGRESSION MODELS FOR CATEGORICAL DEPENDENT VARIABLES USING STATA, p267
# http://data.princeton.edu/wws509/r/overdispersion.html
library(pscl)

data(bioChemists)
head(bioChemists); dim(bioChemists);
hist(bioChemists$art)

# glms
f1 <- glm(art ~ fem + mar + kid5 + phd + ment,
          family = "poisson",
          data = bioChemists)

f2 <- glm(art ~ fem + mar + kid5 + phd + ment,
          family = "quasipoisson",
          data = bioChemists)

f3 <- glm.nb(art ~ fem + mar + kid5 + phd + ment,
             data = bioChemists)

lapply(list(f1,f2,f3), summary)

# semi-parametric gam
g <- gam(art ~ fem + mar + kid5 + s(phd) + s(ment),
         family = "poisson",
         data = bioChemists)
summary(g)

# plot(g)  # smoothing plot
plot.gam(g, pages = 1)  # onepage
# ----- ----- ----- ----- ----- #


