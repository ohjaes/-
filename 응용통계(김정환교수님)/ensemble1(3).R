


# example 1
set.seed(1)

ny <- 100
x <- sort(rnorm(ny, 0, 2))
y <- sin(x) + rnorm(ny, 0, 0.25)
d <- cbind.data.frame(y, x)

plot(y ~ x, data = d)
install.packages("tree")
library(tree)
f <- tree(y ~ x, data = d)
lines(x = x, 
      y = predict(f), 
      lty = 2, col = "red")

install.packages("randomForest")
library(randomForest)
set.seed(1)
r <- randomForest(y ~ x, data = d)
lines(x = x,
      y = predict(r),
      lty = 2, col = "blue")

legend("topright",
       legend = c("obs", "tree", "ensemble"),
       inset = c(0.015, 0.015),
       col = c("black", "red", "blue"),
       pch = c(1,NA,NA),
       lty = c(NA,2,2),
       cex = 0.75)



# example 2
set.seed(1)

ny <- 100
x <- sort(rnorm(ny, 0, 2))
y <- cbind(1,x) %*% c(0,1) + rnorm(ny, 0, 0.25)
d <- cbind.data.frame(y, x)

plot(y ~ x, data = d)

library(tree)
f <- tree(y ~ x, data = d)
lines(x = x, 
      y = predict(f), 
      lty = 2, col = "red")

library(randomForest)
set.seed(1)
r <- randomForest(y ~ x, data = d)
lines(x = x,
      y = predict(r),
      lty = 2, col = "blue")

legend("topleft",
       legend = c("obs", "tree", "ensemble"),
       inset = c(0.015, 0.015),
       col = c("black", "red", "blue"),
       pch = c(1,NA,NA),
       lty = c(NA,2,2),
       cex = 0.75)



# example 3
library(tree)

f <- tree(Species ~ ., data = iris)
plot(f)
text(f, cex = 0.9)


for(k in 1:3) {
  set.seed(k)
  idx <- sample(1:nrow(iris), size = nrow(iris), replace = T)
  iris.boot <- iris[idx,]
  
  f <- tree(Species ~ ., data = iris.boot)
  plot(f)
  text(f, cex = 0.9)
  title(paste0(k, "th boot"))
}




# example 4
# x <- sapply(as.list(1:1000), function(k) {
#   mean( rnorm(n = 100, mean = 0, sd = 4) )
# })
# hist(x)
# sd(x)
# mean((x - 0)^2)
# 
# x <- sapply(as.list(1:1000), function(k) {
#   mean( rnorm(n = 100, mean = 2, sd = 1) )
# })
# hist(x)
# sd(x)
# mean((x - 0)^2)







### regression tree, bagging, random forest

## loading dataset
library(MASS)  # Boston dataset
data("Boston")

dat <- Boston
str(dat)
head(dat)


## partitioning dataset 
set.seed(1)
idx <- sample(x = 1:nrow(dat), 
              size = floor(nrow(dat) * 0.1), 
              replace = F)
dat_tr <- dat[-idx,]; str(dat_tr);
dat_te <- dat[+idx,]; str(dat_te);


## training
# tree
library(tree) 
f.rt <- tree(medv ~ ., 
             data = dat_tr)  
plot(f.rt)
text(f.rt, cex=0.8)

set.seed(1)
rt.tune <- cv.tree(f.rt)
plot(rt.tune)

f.rt.sub <- prune.tree(f.rt, best = 8)
plot(f.rt.sub)
text(f.rt.sub, cex = 0.9)

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

# oob-mse
plot(f.bg, 
     lty=2, 
     main = "")
plot(f.rf, lty=2, col=2, add=T)

legend("topright",
       legend = c("bagging", "random forest"),
       inset = c(0.015, 0.015),
       col = c("black", "red"),
       lty = c(2,2),
       cex = 0.75)

# varimplot
varImpPlot(f.bg)
varImpPlot(f.rf)


## prediction 
pred.rt.sub <- predict(f.rt.sub, newdata = dat_te)
pred.rt <- predict(f.rt, newdata = dat_te)
pred.bg <- predict(f.bg, newdata = dat_te)
pred.rf <- predict(f.rf, newdata = dat_te)

sapply(list(rt.sub = pred.rt.sub, 
            rt = pred.rt, 
            bg = pred.bg, 
            rf = pred.rf), 
       function(pred) {
         sqrt(mean((dat_te$medv - pred)^2))
       })
### 






### classification tree, bagging, random forest
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
              size = floor(nrow(dat) * 0.1), 
              replace = F)
dat_tr <- dat[-idx,]; str(dat_tr);
dat_te <- dat[+idx,]; str(dat_te);


## training
# tree
library(tree) 
f.rt <- tree(High ~ ., 
             data = dat_tr)  
plot(f.rt)
text(f.rt, cex=0.8)

set.seed(4)
rt.tune <- cv.tree(f.rt)
plot(rt.tune)

f.rt.sub <- prune.tree(f.rt, best = 10)
plot(f.rt.sub)
text(f.rt.sub, cex = 0.9)

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

# oob-err
plot(f.bg$err.rate[,1], 
     type = "l", 
     lty=2, 
     main = "",
     xlab = "trees",
     ylab = "Error")
points(f.rf$err.rate[,1], type = "l", lty=2, col=2)
legend("topright",
       legend = c("bagging", "random forest"),
       inset = c(0.015, 0.015),
       col = c("black", "red"),
       lty = c(2,2),
       cex = 0.75)

# varimplot
varImpPlot(f.bg)
varImpPlot(f.rf)


## prediction 
pred.rt.sub <- predict(f.rt.sub, newdata = dat_te, type = "class")
pred.rt <- predict(f.rt, newdata = dat_te, type = "class")
pred.bg <- predict(f.bg, newdata = dat_te, type = "response")
pred.rf <- predict(f.rf, newdata = dat_te, type = "response")

lapply(list(rt.sub = pred.rt.sub, 
            rt = pred.rt, 
            bg = pred.bg, 
            rf = pred.rf), 
       function(pred) {
         table(dat_te$High, pred)
       })
### 



