


## Shrinkage estimation for glm ##
library(mpath)  # for ridge, lasso and elastic net

library(pscl)
data(bioChemists)
head(bioChemists); dim(bioChemists);
hist(bioChemists$art)


# glm
f0 <- glm(art ~ .,
          family = "poisson",
          data = bioChemists)
coef(f0)                     


# ridge
set.seed(1)
f1.cv10 <- cv.glmreg(art ~ .,
                     family = "poisson",
                     alpha = 0,  # ridge penalty
                     data = bioChemists,
                     lambda = seq(0.01, 1, by = 0.01))

abline(v = log(f1.cv10$lambda.optim),
       col = "red",
       lty = 2)

f1.tune <- glmreg(art ~ .,
                  family = "poisson",
                  alpha = 0,
                  data = bioChemists,
                  lambda = f1.cv10$lambda.optim)
coef(f1.tune)


# lasso
set.seed(1)
f2.cv10 <- cv.glmreg(art ~ .,
                     family = "poisson",
                     alpha = 1,  # lasso penalty
                     data = bioChemists)

abline(v = log(f2.cv10$lambda.optim),
       col = "red",
       lty = 2)

f2.tune <- glmreg(art ~ .,
                  family = "poisson",
                  alpha = 1,
                  data = bioChemists, 
                  lambda = f2.cv10$lambda.optim)
coef(f2.tune)


# elatic net
# nested cv is needed
a <- as.list(seq(0.1, 0.9, by = 0.1))
ncv <- sapply(a, function(a) {
  print(a)
  set.seed(a)
  cv10 <- cv.glmreg(art ~ .,
                    family = "poisson",
                    plot.it = F,  # cv-plot
                    alpha = a,    # lasso penalty
                    data = bioChemists)
  c(loglik = cv10$cv[cv10$lambda.which],
    lambda = cv10$lambda.optim)
})
res <- cbind.data.frame(t(ncv), alpha = unlist(a))
res

opt <- res[which.max(res[,1]),]
opt

f3.tune <- glmreg(art ~ .,
                  family = "poisson",
                  alpha = opt$alpha,
                  lambda = opt$lambda,
                  data = bioChemists)
coef(f3.tune)


# comparing coef's
round(
  cbind(glm = coef(f0),
        ridge = coef(f1.tune),
        lasso = coef(f2.tune),
        elnet = coef(f3.tune)),
  digits = 6
)





## Prediction Intervals for Poisson Regression ##
# https://statcompute.wordpress.com/2015/12/20/prediction-intervals-for-poisson-regression/





## Classification of logistic regression ##
# generate binary data
ny <- 1000
nx <- 2

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-1, rep(1, nx)), ncol=1)
p <- 1 / { 1 + exp(-cbind(1,x) %*% b) } 

m <- 1
y <- rbinom(n = ny, size = m, prob = p) 
table(y)

d <- cbind.data.frame(y, x)
head(d); dim(d);

# glm
f0 <- glm(y ~ ., 
          family = "binomial" (link = "logit"),
          data = d)
summary(f0)

# install.packages("pROC")
library(pROC)
out <- pROC::roc(response = d$y,
                 predictor = fitted(f0))
plot.roc(out, 
         print.thres=TRUE, 
         col = "red",
         main=paste('AUC:', round(out$auc,4)))
# plot.roc(smooth(out),
#          add=TRUE,
#          lty = 2,
#          col="blue")
coords(out, "best")

# check ROC curve
# plot(y = out$sensitivities,
#      x = 1 - out$specificities,
#      type = "l")
# o <- which.max(out$sensitivities + out$specificities)
# c(thres = out$thresholds[o],
#   speci = out$specificities[o],
#   sensi = out$sensitivities[o])


