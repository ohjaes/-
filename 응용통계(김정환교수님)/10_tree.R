


# example 1
set.seeed(1)

ny <- 100
x <- sort(rnorm(ny, 0, 2))
y <- sin(x) + rnorm(ny, 0, 0.25)
d <- cbind.data.frame(y, x)

plot(y ~ x, data = d)

library(tree)
f <- tree(y ~ x, data = d)
lines(x = x, 
      y = predict(f), 
      lty = 2, col = "red")

library(mgcv)
g <- gam(y ~ s(x), data = d)
lines(x = x, 
      y = predict(g), 
      lty = 2, col = "blue")

legend("topright",
       legend = c("obs", "tree", "gam"),
       inset = c(0.015, 0.015),
       col = c("black", "red", "blue"),
       pch = c(1,NA,NA),
       lty = c(NA,2,2),
       cex = 0.75)



# example 2
set.seeed(1)

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

library(mgcv)
g <- gam(y ~ s(x), data = d)
lines(x = x, 
      y = predict(g), 
      lty = 2, col = "blue")

legend("topleft",
       legend = c("obs", "tree", "gam"),
       inset = c(0.015, 0.015),
       col = c("black", "red", "blue"),
       pch = c(1,NA,NA),
       lty = c(NA,2,2),
       cex = 0.75)



# Regression tree
airq <- subset(airquality, !is.na(Ozone))
head(airq); str(airq);

f <- tree(Ozone ~ ., data = airq)
f
f$frame

plot(f)
# plot(f, type="uniform")
text(f, cex = 0.9)

plot(f)
text(f, cex = 0.9, all = T)

f.cv <- cv.tree(f)
plot(f.cv)

f.pr <- prune.tree(f, best = 6)
plot(f.pr)
text(f.pr, cex = 0.9)

library(rpart)
library(rpart.plot)
g <- rpart(Ozone ~ ., data = airq)
prp(g, type=4, extra = 1)

library(party)
g <- ctree(Ozone ~ ., data = airq)
plot(g)



# Classification tree
f <- tree(Species ~ ., data = iris)
f
f$frame

plot(f)
# plot(f, type="uniform")
text(f, cex = 0.9)

plot(f)
text(f, cex = 0.9, all = T)

f.cv <- cv.tree(f)
plot(f.cv)

f.pr <- prune.tree(f, best = 4)
f.pr$frame
plot(f.pr)
text(f.pr, cex = 0.9)

library(rpart)
library(rpart.plot)
g <- rpart(Species ~ ., data = iris)
prp(g, type=4, extra = 1)

library(party)
g <- ctree(Species ~ .,data = iris)
plot(g)

