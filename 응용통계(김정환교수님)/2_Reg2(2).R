

## example ##
dat1 <- read.table("Reg2_dat1.txt", header = T)
str(dat1)
head(dat1)


# modeling with categorical variable
# (whole modeling)
f0 <- lm(weight ~ height * gender, 
         data = dat1)
summary(f0)

gender0 <- c(coef(f0)[1], 
            coef(f0)[2])
gender1 <-  c(coef(f0)[1] + coef(f0)[3],
              coef(f0)[2] + coef(f0)[4])
list('0' = gender0, 
     '1' = gender1)

plot(weight ~ height, 
     data = dat1, 
     col = (dat1$gender + 1),
     pch = (dat1$gender + 11))

abline(a = gender0[1],
       b = gender0[2], 
       col = 1,
       lty = 2)
abline(a = gender1[1],
       b = gender1[2], 
       col = 2,
       lty = 2)

legend("topleft", 
       legend = c("gender = 0 (male)", 
                  "gender = 1 (female)"), 
       cex = 0.9, 
       inset = c(0.01, 0.01),
       col = c(1, 2),
       pch = c(11, 12),
       lty = 2)

sig0 <- round(summary(f0)$sigma, 4)
mtext(bquote(sigma==.(sig0)), 
      line=1, side=3, cex=1.2)



# modeling with data partition 
# (seperate modeling)
dat1g <- split(dat1, f = dat1$gender)
dat1g <- lapply(dat1g, function(d) { 
  o <- order(d$height)
  d[o,] 
})

str(dat1g)
lapply(dat1g, head)


fg <- lapply(dat1g, function(d) {
  lm(weight ~ height, data = d)
})

lapply(fg, summary)
lapply(fg, coef)

sig <- sapply(fg, function(x) {
  round(summary(x)$sigma,4)
})
mtext(bquote(paste(sigma[0]==.(sig[1]),', ',
                   sigma[1]==.(sig[2]))), 
      line=1, side=3, cex=1.2)


# graphical expression for seperate modeling
plot(weight ~ height, 
     data = dat1, 
     col = (dat1$gender + 1),
     pch = (dat1$gender + 11))

legend("topleft", 
       legend = c("gender = 0 (male)", 
                  "gender = 1 (female)"), 
       cex = 0.9, 
       inset = c(0.01, 0.01),
       col = c(1, 2),
       pch = c(11, 12),
       lty = 2)

mtext(bquote(paste(sigma[0]==.(sig[1]),', ',
                   sigma[1]==.(sig[2]))), 
      line=1, side=3, cex=1.2)

fg.ci <- lapply(fg, function(f) {
  predict(f, newdata = f$model, interval = "confidence")
})

lines(x = fg[[1]]$model$height,
      y = fg.ci[[1]][,"fit"],
      col = 1, lty = 2)
lines(x = fg[[1]]$model$height,
      y = fg.ci[[1]][,"lwr"],
      col = 1, lty = 2)
lines(x = fg[[1]]$model$height,
      y = fg.ci[[1]][,"upr"],
      col = 1, lty = 2)

lines(x = fg[[2]]$model$height,
      y = fg.ci[[2]][,"fit"],
      col = 2, lty = 2)
lines(x = fg[[2]]$model$height,
      y = fg.ci[[2]][,"lwr"],
      col = 2, lty = 2)
lines(x = fg[[2]]$model$height,
      y = fg.ci[[2]][,"upr"],
      col = 2, lty = 2)




## simulation ##

# setting 1 : homogeneous variance
library(nnet)

nsim <- 1000

f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  
  z <- rep(c("A","B"), c(50, 50))
  z.ind <- class.ind(z)
  z.ind <- as.matrix(z.ind)
  x2 <- z.ind[,-1,drop=F]
  
  x1 <- rnorm(100)
  coef <- c(-1, 1, 1, 2)
  err <- rnorm(100)
  y <- cbind(1, x1, x2, x1*x2) %*% coef + err
  d <- cbind.data.frame(y, x1, x2)
  f <- lm(y ~ x1 * x2, data = d)
  return(f)
})

apply(do.call("rbind", lapply(f.list, coef)), 2, mean)
sum(sapply(f.list, function(f) summary(f)$coef[   "x2", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f)$coef["x1:x2", "Pr(>|t|)"]) <= 0.05) / nsim



# setting 2 : heterogeneous variance
nsim <- 1000

# fitting model assuming homogenous variance 
f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  
  z <- rep(c("A","B"), c(50, 50))
  z.ind <- class.ind(z)
  z.ind <- as.matrix(z.ind)
  x2 <- z.ind[,-1,drop=F]
  
  x1 <- rnorm(100)
  coef <- c(-1, 1, 1, 2)
  err <- c(rnorm(n = 50, mean = 0, sd = 1),
           rnorm(n = 50, mean = 0, sd = 5))
  y <- cbind(1, x1, x2, x1*x2) %*% coef + err
  d <- cbind.data.frame(y, x1, x2)
  f <- lm(y ~ x1 * x2, data = d)
  return(f)
})

apply(do.call("rbind", lapply(f.list, coef)), 2, mean)
sum(sapply(f.list, function(f) summary(f)$coef[   "x2", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f)$coef["x1:x2", "Pr(>|t|)"]) <= 0.05) / nsim
  

# fitting model assuming heterogeneous variance 
f.list <- lapply(1:nsim, function(L) {
  set.seed(L)
  
  z <- rep(c("A","B"), c(50, 50))
  z.ind <- class.ind(z)
  z.ind <- as.matrix(z.ind)
  x2 <- z.ind[,-1,drop=F]
  
  x1 <- rnorm(100)
  coef <- c(-1, 1, 1, 2)
  err <- c(rnorm(n = 50, mean = 0, sd = 1),
           rnorm(n = 50, mean = 0, sd = 5))
  y <- cbind(1, x1, x2, x1*x2) %*% coef + err
  d <- cbind.data.frame(y, x1, x2)
  f1 <- lm(y ~ x1, data = d[x2==0,])
  f2 <- lm(y ~ x1, data = d[x2==1,])
  return(list(f1=f1, f2=f2))
})

apply(do.call("rbind", lapply(f.list, function(f) coef(f$f1))), 2, mean)
apply(do.call("rbind", lapply(f.list, function(f) coef(f$f2))), 2, mean)

sum(sapply(f.list, function(f) summary(f$f1)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim
sum(sapply(f.list, function(f) summary(f$f2)$coef["x1", "Pr(>|t|)"]) <= 0.05) / nsim


# End..


