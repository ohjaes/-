

### gradient descent algorithm

## example 1 
fx <- function(x) x^4 - 3*x^3 + 2
curve(expr = fx, from = -1, to = 3)

# set up a stepsize
alpha = 0.003

# set up a number of iteration
iter = 100

# define the gradient of f(x) = x^4 - 3*x^3 + 2
gradient = function(x) return((4*x^3) - (9*x^2))

# randomly initialize a value to x
x = +3
# x = -1
# x = +1
# x = 0


# create a vector to contain all xs for all steps
x.All = vector("numeric",iter)

# gradient descent method to find the minimum
for(i in 1:iter){
  x = x - alpha*gradient(x)
  x.All[i] = x
  print(x)
}

y.All <- fx(x.All)
i.All <- seq(1:iter)

# print result and plot all xs for every iteration
print(paste("The minimum of f(x) is ", x, sep = ""))
# plot(x.All, type = "l")

curve(expr = fx, from = -1, to = 3)
points(x = x.All, y = y.All, col = 2, cex = 0.7)
text(x = x.All, y = y.All, labels = i.All, pos = 4, col = 2, cex = 0.7)
## 


## example 2 
fx <- function(x) (x - 1)^2 + 1
curve(expr = fx, from = -1, to = 3)

# set up a stepsize
alpha = 0.01

# set up a number of iteration
iter = 500

# define the gradient of f(x) = 2 * (x - 1)
gradient = function(x) return(2 * (x - 1))

# randomly initialize a value to x
# x = +3
x = -1

# create a vector to contain all xs for all steps
x.All = vector("numeric",iter)

# gradient descent method to find the minimum
for(i in 1:iter){
  x = x - alpha*gradient(x)
  x.All[i] = x
  print(x)
}

y.All <- fx(x.All)
i.All <- seq(1:iter)

# print result and plot all xs for every iteration
print(paste("The minimum of f(x) is ", x, sep = ""))
# plot(x.All, type = "l")

curve(expr = fx, from = -1, to = 3)
points(x = x.All, y = y.All, col = 2, cex = 0.7)
text(x = x.All, y = y.All, labels = i.All, pos = 4, col = 2, cex = 0.7)
## 
###




### gbm in R
N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE),levels=letters[4:1])
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]

SNR <- 10 # signal-to-noise ratio
Y <- X1**1.5 + 2 * (X2**.5) + mu
sigma <- sqrt(var(Y)/SNR)
Y <- Y + rnorm(N,0,sigma)

# introduce some missing values
X1[sample(1:N,size=500)] <- NA
X4[sample(1:N,size=300)] <- NA

data <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)

# fit initial model
library(gbm)

gbm1 <-
  gbm(Y~X1+X2+X3+X4+X5+X6,         # formula
      data=data,                   # dataset
      var.monotone=c(0,0,0,0,0,0), # -1: monotone decrease,
                                   # +1: monotone increase,
                                   #  0: no monotone restrictions
      distribution="gaussian",     # see the help for other choices
      n.trees=1000,                # number of trees
      shrinkage=0.05,              # shrinkage or learning rate,
                                   # 0.001 to 0.1 usually work
      interaction.depth=3,         # 1: additive model, 2: two-way interactions, etc.
      bag.fraction = 0.5,          # subsampling fraction, 0.5 is probably best
      train.fraction = 0.5,        # fraction of data for training,
                                   # first train.fraction*N used for training
      n.minobsinnode = 10,         # minimum total weight needed in each node
      cv.folds = 3,                # do 3-fold cross-validation
      keep.data=TRUE,              # keep a copy of the dataset with the object
      verbose=FALSE,               # don't print out progress
      n.cores=1)                   # use only a single core (detecting #cores is
                                   # error-prone, so avoided here)

gbm1


# check performance using an out-of-bag estimator
# OOB underestimates the optimal number of iterations
best.iter <- gbm.perf(gbm1,method="OOB")
print(best.iter)

# check performance using a 50% heldout test set
best.iter <- gbm.perf(gbm1,method="test")
print(best.iter)

# check performance using 5-fold cross-validation
best.iter <- gbm.perf(gbm1,method="cv")
print(best.iter)

# plot the performance # plot variable influence
summary(gbm1,n.trees=1)         # based on the first tree
summary(gbm1,n.trees=best.iter) # based on the estimated best number of trees

# compactly print the first and last trees for curiosity
print(pretty.gbm.tree(gbm1,1))
print(pretty.gbm.tree(gbm1,gbm1$n.trees))

# make some new data
N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE))
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]

Y <- X1**1.5 + 2 * (X2**.5) + mu + rnorm(N,0,sigma)

data2 <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)

# predict on the new data using "best" number of trees
# f.predict generally will be on the canonical scale (logit,log,etc.)
f.predict <- predict(gbm1,data2, best.iter)

# least squares error
print(sum((data2$Y-f.predict)^2))

# create marginal plots
par(mfrow=c(1,3))
plot(gbm1,1,best.iter)
plot(gbm1,2,best.iter)
plot(gbm1,3,best.iter)
par(mfrow=c(1,1))
# contour plot of variables 1 and 2 after "best" iterations
plot(gbm1,1:2,best.iter)
# lattice plot of variables 2 and 3
plot(gbm1,2:3,best.iter)
# lattice plot of variables 3 and 4
plot(gbm1,3:4,best.iter)

# 3-way plots
plot(gbm1,c(1,2,6),best.iter,cont=20)
plot(gbm1,1:3,best.iter)
plot(gbm1,2:4,best.iter)
plot(gbm1,3:5,best.iter)

# do another 100 iterations
gbm2 <- gbm.more(gbm1,100,
                 verbose=FALSE) # stop printing detailed progress
###






### Tree-based regression models

## loading dataset
library(MASS)  # Boston dataset
data("Boston")

dat <- Boston
str(dat)
head(dat)


## partitioning dataset 
set.seed(1)
idx <- sample(x = 1:nrow(dat), 
              size = floor(nrow(dat) * 0.2), 
              replace = F)
dat_tr <- dat[-idx,]; str(dat_tr);
dat_te <- dat[+idx,]; str(dat_te);


## training
# bagging
library(randomForest)
set.seed(1)
f.bg <- randomForest(medv ~ .,
                     data = dat_tr,
                     mtry = 13,  # using all predictors = bagging
                     ntree=500,
                     importance =TRUE)

# random forest
set.seed(1)
rf.tune <- tuneRF(x = dat_tr[,-14],
                  y = dat_tr[,+14],
                  data = dat_tr)
rf.tune

set.seed(1)
f.rf <- randomForest(medv ~ .,
                     data = dat_tr,
                     ntree=500,
                     mtry = 6,  # using some predictors = r.f.
                     importance =TRUE)

# gbm
library(gbm)
set.seed(1)
f.gb <-  gbm(medv ~ .,
             data = dat_tr,
             distribution="gaussian",  # continoues response
             n.trees=3000,             # number of trees
             shrinkage=0.05,           # shrinkage or learning rate,
             interaction.depth=2,      # 1: additive model, 2: two-way interactions
             cv.folds = 5,             # do 5-fold cross-validation
             n.cores=1)                # use only a single core
f.gb

# check performance using 5-fold cross-validation
best.iter <- gbm.perf(f.gb, method="cv")
print(best.iter)


## prediction 
pred.bg <- predict(f.bg, newdata = dat_te)
pred.rf <- predict(f.rf, newdata = dat_te)
pred.gb <- predict(f.gb, newdata = dat_te, n.trees = best.iter)

sapply(list(bg = pred.bg, 
            rf = pred.rf,
            gb = pred.gb), 
       function(pred) {
         sqrt(mean((dat_te$medv - pred)^2))
       })


## Renew the final model
set.seed(1)
f.final <- gbm(medv ~ .,
               data = dat,
               distribution="gaussian",  # continoues response
               n.trees=3000,             # number of trees
               shrinkage=0.05,           # shrinkage or learning rate,
               interaction.depth=2,      # 1: additive model, 2: two-way interactions
               cv.folds = 5,             # do 3-fold cross-validation
               n.cores=1)                # use only a single core

best.iter <- gbm.perf(f.final, method="test")
print(best.iter)

# plot variable influence
summary(f.final, n.trees=best.iter, las = 1, order = T)
summary(f.final, n.trees=best.iter, las = 1, order = F)

# create marginal plots
plot(f.gb, i.var =  6, n.trees = best.iter)
plot(f.gb, i.var = 13, n.trees = best.iter)
plot(f.gb, i.var =  c(6,13), n.trees = best.iter)
### 






### Tree-based classification models
## loading dataset
library(ISLR)  # Carseats dataset
data("Carseats")

dat <- Carseats
dat <- data.frame(
  dat[,colnames(dat)!="Sales"],
  High = ifelse(dat$Sales<=8, "No", "Yes")
)
str(dat)
head(dat)


## partitioning dataset 
set.seed(1)
idx <- sample(x = 1:nrow(dat), 
              size = floor(nrow(dat) * 0.2), 
              replace = F)
dat_tr <- dat[-idx,]; str(dat_tr);
dat_te <- dat[+idx,]; str(dat_te);


## training
# bagging
library(randomForest)
set.seed(1)
f.bg <- randomForest(High ~ ., 
                     data = dat_tr,
                     mtry = 10,  # using all predictors = bagging
                     ntree=500,
                     importance =TRUE)

# random forest
set.seed(1)
rf.tune <- tuneRF(x = dat_tr[,-11],
                  y = dat_tr[,+11], 
                  data = dat_tr)
rf.tune

set.seed(1)
f.rf <- randomForest(High ~ ., 
                     data = dat_tr,
                     ntree=500,
                     importance =TRUE)

# gbm
dat_tr$Highnum <- ifelse(dat_tr$High=="Yes", 1, 0)
mufun <- as.formula(
  paste0("Highnum ~ ", paste0(colnames(dat_tr)[1:10], collapse = " + "))
)

library(gbm)
set.seed(1)
f.gb <-  gbm(formula = mufun,
             data = dat_tr,
             distribution="bernoulli",  # continoues response
             n.trees=2000,              # number of trees
             shrinkage=0.01,            # shrinkage or learning rate,
             interaction.depth=3,       # 3: three-way interactions
             train.fraction = 0.5,      # fraction of data for training
             n.cores=1)                 # use only a single core
f.gb

# check performance using 5-fold cross-validation
best.iter <- gbm.perf(f.gb, method="test")
print(best.iter)


## prediction 
prob.bg <- predict(f.bg, newdata = dat_te, type = "prob")[,"Yes"]
prob.rf <- predict(f.rf, newdata = dat_te, type = "prob")[,"Yes"]
prob.gb <- predict(f.gb, newdata = dat_te, n.trees = best.iter, type = "response")

## AUC
dat_te$Highnum <- ifelse(dat_te$High=="Yes", 1, 0)

library(pROC)
lapply(list(bg = prob.bg, 
            rf = prob.rf,
            gb = prob.gb), 
       function(prob) {
         pROC::roc(response = dat_te$Highnum, 
                   predictor = prob)
       })


## Renew the final model
dat$Highnum <- ifelse(dat$High=="Yes", 1, 0)

set.seed(1)
f.final <- gbm(formula = mufun,
               data = dat,
               distribution="bernoulli",  # continoues response
               n.trees=1000,              # number of trees
               shrinkage=0.01,            # shrinkage or learning rate,
               interaction.depth=3,       # 3: three-way interactions
               train.fraction = 0.5,      # fraction of data for training
               n.cores=1)                 # use only a single core

best.iter <- gbm.perf(f.final, method="test")
print(best.iter)

out <- pROC::roc(response = dat$Highnum,
                 predictor = predict(f.final, 
                                     newdata = dat, 
                                     n.trees = best.iter, 
                                     type = "response"))

plot.roc(out, 
         print.thres=TRUE, 
         col = "red",
         main=paste('AUC:', round(out$auc,4)))

plot.roc(smooth(out),
         add=TRUE,
         lty = 2,
         col="blue")

coords(out, "best")


# plot variable influence
summary(f.final, n.trees=best.iter, las = 1, order = T)
summary(f.final, n.trees=best.iter, las = 1, order = F)

# create marginal plots
plot(f.gb, i.var = 5, n.trees = best.iter)
plot(f.gb, i.var = 6, n.trees = best.iter)
plot(f.gb, i.var = c(5,6), n.trees = best.iter)
### 


