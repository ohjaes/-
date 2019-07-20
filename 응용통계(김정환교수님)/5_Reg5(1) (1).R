


## Not run !! ##
curve(expr = (x-2)^2 + 0.5, from = -0.5, to = 4,
      ylim = c(0, 7),
      xlab = "model complexity",
      ylab = "error", 
      mgp=c(2.5, 1, 0),
      xaxt = "n")

curve(add  = TRUE,
      expr = exp(-1.5*x + 0.75),
      lty = 2)

axis(side = 1, 
     at = c(0.25, 2, 3.25), 
     labels = c("underfit",
                "optimal",
                "overfit"))

segments(x0 = 2, y0 = -0.5,
         x1 = 2, y1 = +0.5,
         lty = 2, col = 2)

legend("topright",
       inset = c(0.01, 0.01),
       legend = c("test error",
                  "training error"),
       lty = c(1, 2))





## Variable selection ##
data(mtcars)
d <- mtcars
d$gear <- as.factor(d$gear)
d$carb <- as.factor(d$carb)

mufun1 <- as.formula(mpg ~ cyl + disp + hp + drat + wt + qsec + gear)
mufun2 <- as.formula(mpg ~ (cyl + disp + hp + drat + wt + qsec) * gear)

f0 <- lm(mufun1, data = d)
f1 <- lm(mufun2, data = d)

f2 <- step(f0, 
           scope = list(lower = mufun1, 
                        upper = mufun2),
           data = dat.tr_ind, 
           # trace = 0,
           direction = "both")

summary(f0)  # default model
summary(f1)  # interaction model
summary(f2)  # stepwise selection




## Shrinkage estimation ##
library(mpath)  # for ridge and lasso


# ridge
set.seed(1)
f3.cv10 <- cv.glmreg(mufun2,
                     family = "gaussian",
                     alpha = 0,  # ridge penalty
                     data = d,
                     lambda = seq(0.01, 1, by = 0.01))

abline(v = log(f3.cv10$lambda.optim),
       col = "red",
       lty = 2)

f3.tune <- glmreg(mufun2,
                  family = "gaussian",
                  alpha = 0,
                  data = d, 
                  lambda = f3.cv10$lambda.optim)
coef(f3.tune)


# lasso
set.seed(1)
f4.cv10 <- cv.glmreg(mufun2,
                     family = "gaussian",
                     alpha = 1,  # lasso penalty
                     data = d)

abline(v = log(f4.cv10$lambda.optim),
       col = "red",
       lty = 2)

f4.tune <- glmreg(mufun2,
                  family = "gaussian",
                  alpha = 1,
                  data = d, 
                  lambda = f4.cv10$lambda.optim)
coef(f4.tune)

          
# elatic net
# nested cv is needed
a <- as.list(seq(0.1, 1.0, by = 0.1))
ncv <- sapply(a, function(a) {
  print(a)
  set.seed(a)
  cv10 <- cv.glmreg(mufun2,
                    family = "gaussian",
                    plot.it = F,  # cv-plot
                    alpha = a,    # lasso penalty
                    data = d)
  c(loglik = cv10$cv[cv10$lambda.which],
    lambda = cv10$lambda.optim)
})
res <- cbind.data.frame(t(ncv), alpha = unlist(a))
res

opt <- res[which.max(res[,1]),]
opt

f5.tune <- glmreg(mufun2,
                  family = "gaussian",
                  alpha = opt$alpha,
                  lambda = opt$lambda,
                  data = d)
coef(f5.tune)


# comparing coef's
round(
  cbind(ridge = coef(f3.tune),
        lasso = coef(f4.tune),
        elnet = coef(f5.tune),
        reg2  = coef(f1)), 
  digits = 6
)

# Using caret package..
# https://rpubs.com/gg_hatano/52301

# End..


