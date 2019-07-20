

## Library ##
library(MASS)   # for mvrnorm
library(mpath)  # for ridge
library(pls)    # for pca



# setting 1 : OLS reg's
nsim <- 1000
ny <- 100
nx <- 5

rho <- 0.9999
corx <- matrix(rho, ncol = nx, nrow = nx)
diag(corx) <- 1


f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  
  x <- mvrnorm(n = ny, 
               mu = rep(0, nx), 
               Sigma = corx)
  colnames(x) <- sprintf("x%d", 1:nx)
  # cor(x)
  # solve(t(x)%*%x)
  
  coef <- c(-nx, rep(1, nx))
  err <- rnorm(100, 0, 1)
  y <- cbind(1, x) %*% coef + err
  d <- cbind.data.frame(y, x)

  f0 <- lm(y ~ . , data = d)  # using all variables
  f1 <- lm(y ~ x1, data = d)  # using only some variales
  
  return(list(
    f0 = f0,
    f1 = f1
  ))
})

apply(do.call("rbind", lapply(f.list, function(f) coef(f$f0))), 2, mean)  # mean(beta) for ols-1
apply(do.call("rbind", lapply(f.list, function(f) coef(f$f1))), 2, mean)  # mean(beta) for ols-2

apply(sapply(f.list, function(f) summary(f$f0)$coef[-1,"Pr(>|t|)"]) <= 0.05, 1, sum) / nsim  # ols-1
sum(sapply(f.list, function(f) summary(f$f1)$coef[-1,"Pr(>|t|)"]) <= 0.05) / nsim  # ols-2



# setting 2 : OLS reg and ridge reg
nsim <- 100
ny <- 100
nx <- 5

rho <- 0.9999
corx <- matrix(rho, ncol = nx, nrow = nx)
diag(corx) <- 1


f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  print(L)
  
  x <- mvrnorm(n = ny, 
               mu = rep(0, nx), 
               Sigma = corx)
  colnames(x) <- sprintf("x%d", 1:nx)
  # cor(x)
  
  coef <- c(-nx, rep(1, nx))
  err <- rnorm(100, 0, 1)
  y <- cbind(1, x) %*% coef + err
  d <- cbind.data.frame(y, x)
  
  f0 <- lm(y ~ . , data = d)  # using all variables
  
  # ridge reg without cv  
  # f1.try <- glmreg(y ~ .,
  #                  family = "gaussian",
  #                  data = d,
  #                  alpha = 0,    # ridge penalty
  #                  lambda = seq(0.01, 1, by=0.01))
  # plot(f1.try)
  # plot(x = f1.try$lambda,
  #      y = f1.try$beta[1,],
  #      xlab = expression(lambda),
  #      ylab = expression(beta),
  #      type = "l", ylim = c(0, 5.5))
  # lines(x = f1.try$lambda,
  #       y = f1.try$beta[2,],
  #       col = 2)
  # lines(x = f1.try$lambda,
  #       y = f1.try$beta[3,],
  #       col = 3)
  # lines(x = f1.try$lambda,
  #       y = f1.try$beta[4,],
  #       col = 4)
  # lines(x = f1.try$lambda,
  #       y = f1.try$beta[5,],
  #       col = 5)
  
  # ridge reg with cv  
  f1.cv <- cv.glmreg(y ~ .,
                     family = "gaussian",
                     data = d,
                     plot.it = F,  # cv-plot
                     alpha = 0,    # ridge penalty
                     lambda = seq(0.01, 1, by=0.01))
  plot(f1.cv)
  abline(v = log(f1.cv$lambda.optim), col = 2, lty = 2)

  f1 <- glmreg(y ~ .,
               family = "gaussian",
               data = d,
               alpha = 0, # ridge penalty
               lambda = f1.cv$lambda.optim)
  
  return(list(
    f0 = f0,
    f1 = f1
  ))
})


# checking estimates
b0 <- apply(do.call("rbind", lapply(f.list, function(f) coef(f$f0))), 2, mean)  # mean(beta) for ols
b1 <- apply(do.call("rbind", lapply(f.list, function(f) coef(f$f1))), 2, mean)  # mean(beta) for ridge
s0 <- apply(do.call("rbind", lapply(f.list, function(f) coef(f$f0))), 2, sd)    # sd(beta) for ols
s1 <- apply(do.call("rbind", lapply(f.list, function(f) coef(f$f1))), 2, sd)    # sd(beta) for ridge

bias2 <- cbind((b0 - coef)^2, (b1 - coef)^2)
var2  <- cbind(s0^2, s1^2)
mse <- bias2 + var2

colnames(bias2) <- c("ols", "ridge")
colnames(var2) <- c("ols", "ridge")
colnames(mse) <- c("ols", "ridge")

list(bias2 = round(bias2, 4),
     var2 = round(var2, 4),
     mse = round(mse, 4))


# checking fitted.values
cbind(  # mean 
  apply(sapply(f.list, function(f) f$f0$fitted.values), 1, mean),
  apply(sapply(f.list, function(f) predict(f$f1, newx = f$f1$data)), 2, mean)
)

cbind(  # sd
  apply(sapply(f.list, function(f) f$f0$fitted.values), 1, sd),
  apply(sapply(f.list, function(f) predict(f$f1, newx = f$f1$data)), 2, sd)
)





# setting 2 : OLS reg and prcomp reg
nsim <- 100
ny <- 100
nx <- 5

rho <- 0.9999
corx <- matrix(rho, ncol = nx, nrow = nx)
diag(corx) <- 1


set.seed(1)
x <- mvrnorm(n = ny, 
             mu = rep(0, nx), 
             Sigma = corx)
colnames(x) <- sprintf("x%d", 1:nx)
# cor(x)

coef <- c(-nx, rep(1, nx))
err <- rnorm(100, 0, 1)
y <- cbind(1, x) %*% coef + err
d <- cbind.data.frame(y, x)

# ols regression
f0 <- lm(y ~ . , data = d)
summary(f0)

# not recommended !
f1 <- pcr(y ~ ., 
          data = d, 
          scale = TRUE)
f1$coefficients
# f1$loadings
# round(f1$scores, 4) 


# recommended
pr <- prcomp(x, center=TRUE, scale=TRUE)  
# pr$rotation
# pr$sdev^2
# round(pr$x, 4)
# round(scale(x)%*%pr$rotation, 4)
# diag(
#   t(pr$x) %*% pr$x / (nrow(x) - 1)
# )

z <- scale(x)%*%pr$rotation
f2 <- lm(y ~ z)  ## pcr by lm 
summary(f2)

list(reg = cbind(coef(f2)[-1]),
     pcr = t(f1$loadings) %*% f1$coefficients[,,5])

list(pcr = cbind(f1$coefficients[,,5]), 
     reg = f1$loadings %*% coef(f2)[-1])  

# check correlation matrix
# cor(x)
# t(scale(x)) %*% scale(x) / (nrow(x) - 1)
# pr$rotation %*% t(pr$x) %*% pr$x %*% t(pr$rotation) / (nrow(x) - 1)





# example : fish dataset
dat <- read.table("Reg4_dat1.txt")
colnames(dat) <- c("obs", "Species", "Weight", "Length1", "Length2", "Length3", "Height", "Width", "Sex")
head(dat); dim(dat);

dat <- dat[complete.cases(dat[,2:8]),]
dat <- dat[dat$Weight != 0,]
head(dat); dim(dat);

panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

pairs(dat[,2:8], 
      lower.panel=panel.smooth, 
      upper.panel=panel.cor, 
      pch=20, main="Iris Scatterplot Matrix")

dat$Volume <- (dat$Length3 * dat$Height * dat$Width)

pdf(paste0("output.pdf"), width = 9, height = 9, onefile = TRUE)

plot(Weight ~ Volume, data = dat, pch = 19, xlab = "Volume")
points(x = dat$Volume[143], y = dat$Weight[143], col = 2)
f <- lm(Weight ~ Volume, data = dat)
abline(a = coef(f)[1], b = coef(f)[2], col = 2, lwd = 2, lty = 2)  # linear fit
mtext(bquote(paste(R^{2} == .(round(summary(f)$adj.r.squared, 4)))), line=1.5)

plot(Weight ~ Volume, data = dat, pch = 19, xlab = "Volume", col = dat$Species)
dat.g <- split(x = dat, f = dat$Species)
fit.g <- lapply(dat.g, function(x) lm(Weight ~ Volume, x))
Rsq.g <- lapply(fit.g, function(x) summary(x)$adj.r.squared)

for(i in 1:length(dat.g)) {
  abline(a = coef(fit.g[[i]])[1], b = coef(fit.g[[i]])[2], col = i, lwd = 2, lty = 2)
}
mtext(bquote(paste(R[1]^{2} == .(round(Rsq.g[[1]], 4)), ', ', 
                   R[2]^{2} == .(round(Rsq.g[[2]], 4)), ', ', 
                   R[3]^{2} == .(round(Rsq.g[[3]], 4)), ', ', 
                   R[4]^{2} == .(round(Rsq.g[[4]], 4)), ', ', 
                   R[5]^{2} == .(round(Rsq.g[[5]], 4)), ', ', 
                   R[6]^{2} == .(round(Rsq.g[[6]], 4)), ', ', 
                   R[7]^{2} == .(round(Rsq.g[[7]], 4)))), line=1.5)

# log-scaled 
dat$Weight <- log(dat$Weight)

plot(log(Weight) ~ Volume, data = dat, pch = 19, xlab = "Volume")
f <- lm(log(Weight) ~ Volume, data = dat)
abline(a = coef(f)[1], b = coef(f)[2], col = 2, lwd = 2, lty = 2)  # linear fit
mtext(bquote(paste(R^{2} == .(round(summary(f)$adj.r.squared, 4)))), line=1.5)

plot(log(Weight) ~ Volume, data = dat, pch = 19, xlab = "Volume", col = dat$Species)
dat.g <- split(x = dat, f = dat$Species)
fit.g <- lapply(dat.g, function(x) lm(log(Weight) ~ Volume, x))
Rsq.g <- lapply(fit.g, function(x) summary(x)$adj.r.squared)

for(i in 1:length(dat.g)) {
  abline(a = coef(fit.g[[i]])[1], b = coef(fit.g[[i]])[2], col = i, lwd = 2, lty = 2)
}
mtext(bquote(paste(R[1]^{2} == .(round(Rsq.g[[1]], 4)), ', ', 
                   R[2]^{2} == .(round(Rsq.g[[2]], 4)), ', ', 
                   R[3]^{2} == .(round(Rsq.g[[3]], 4)), ', ', 
                   R[4]^{2} == .(round(Rsq.g[[4]], 4)), ', ', 
                   R[5]^{2} == .(round(Rsq.g[[5]], 4)), ', ', 
                   R[6]^{2} == .(round(Rsq.g[[6]], 4)), ', ', 
                   R[7]^{2} == .(round(Rsq.g[[7]], 4)))), line=1.5)

dev.off()




# example for tuning parameter
nsim <- 100
ny <- 100
nx <- 5

rho <- 0.9999
corx <- matrix(rho, ncol = nx, nrow = nx)
diag(corx) <- 1


mylist <- lapply(1:nsim, function(L) {
  set.seed(L)
  print(L)
  
  x <- mvrnorm(n = ny, 
               mu = rep(0, nx), 
               Sigma = corx)
  colnames(x) <- sprintf("x%d", 1:nx)
  # cor(x)
  
  coef <- c(-nx, rep(1, nx))
  err <- rnorm(100, 0, 1)
  y <- cbind(1, x) %*% coef + err
  d <- cbind.data.frame(y, x)
  
  set.seed(1)
  ss <- sample(1:3, size=nrow(d), replace=T, prob=c(0.6,0.2,0.2))
  train <- d[ss==1,]
  valid <- d[ss==2,]
  tests <- d[ss==3,]
  
  
  lambdas <- seq(0.01, 1, by=0.01)
  
  
  # step 1: modeling in training set
  # no cv  
  
  f0.nocv <- glmreg(y ~ .,
                    family = "gaussian",
                    data = train,
                    alpha = 0,    # ridge penalty
                    lambda = lambdas)
  
  # with cv  
  f0.10cv <- cv.glmreg(y ~ .,
                       family = "gaussian",
                       data = train,
                       plot.it = F,  # cv-plot
                       alpha = 0,    # ridge penalty
                       lambda = lambdas)
  
  f0.tune <- glmreg(y ~ .,
                    family = "gaussian",
                    data = train,
                    alpha = 0, # ridge penalty
                    lambda = f0.10cv$lambda.optim)
  
  which.opt <- which.min(
    apply(predict(f0.nocv, newx = valid, type = "response"), 2, function(x) {
      mean((valid$y - x)^2)
    })
  )
  L.train.nocv <- lambdas[which.opt]
  L.train.tune <- f0.10cv$lambda.optim
  
  err0.nocv <- mean((valid$y - predict(f0.nocv, newx = valid, type = "response")[,which.opt])^2)
  err0.tune <- mean((valid$y - predict(f0.tune, newx = valid, type = "response"))^2)
  
  
  # step 2: modeling in validation set
  trval <- rbind.data.frame(train, valid)
  
  # no cv  
  f1.nocv <- glmreg(y ~ .,
                    family = "gaussian",
                    data = trval,
                    alpha = 0,    # ridge penalty
                    lambda = L.train.nocv)
  
  # with cv  
  f1.10cv <- cv.glmreg(y ~ .,
                       family = "gaussian",
                       data = trval, 
                       plot.it = F,  # cv-plot
                       alpha = 0,    # ridge penalty
                       lambda = lambdas)
  
  f1.tune <- glmreg(y ~ .,
                    family = "gaussian",
                    data = trval, 
                    alpha = 0, # ridge penalty
                    lambda = f1.10cv$lambda.optim)
  
  L.trval.nocv <- f1.nocv$lambda
  L.trval.tune <- f1.10cv$lambda.optim
  
  err1.nocv <- mean((tests$y - predict(f1.nocv, newx = tests, type = "response"))^2)
  err1.tune <- mean((tests$y - predict(f1.tune, newx = tests, type = "response"))^2)
  
  return( c(L.train.nocv = L.train.nocv, 
            L.train.tune = L.train.tune,
            L.trval.tune = L.trval.tune,
            err0.nocv = err0.nocv, 
            err0.tune = err0.tune,
            err1.nocv = err1.nocv, 
            err1.tune = err1.tune))
})

res <- do.call("rbind", mylist)
round(apply(res, 2, mean), 4)
round(apply(res, 2,   sd), 4)


boxplot(res)
boxplot(list(res[,"err0.nocv"], res[,"err1.nocv"]),
        names = c("biased", "correct"), ylab = "Test-mse")

# End..

