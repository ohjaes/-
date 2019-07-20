


## Gaussian dist'n ##
ny <- 1000
nx <- 2

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx, rep(1, nx)), ncol=1)
mu <- cbind(1,x) %*% b

sig <- 1
e <- rnorm(n=ny, mean=0, sd=sig)

y <- mu + e
hist(y)

d <- cbind.data.frame(y, x) 
head(d); dim(d);

# glm
f0 <- glm(y ~ ., 
          family = "gaussian" (link = "identity"),
          data = d)
summary(f0)

# real dataset
data(mtcars)
head(mtcars); dim(mtcars);

f1 <- glm(mpg ~ cyl + disp + hp + drat + wt + qsec,
          family = "gaussian" (link = "identity"),
          data = mtcars)
summary(f1)  
  




## Gamma dist'n ##
ny <- 1000
nx <- 2

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx, rep(1, nx)), ncol=1)
mu <- exp(cbind(1,x) %*% b)
th <- 2

y <- rgamma(n = ny, shape = 1/th, scale = mu*th)
hist(y)

d <- cbind.data.frame(y, x) 
head(d); dim(d);

# glm
f0 <- glm(y ~ ., 
          family = "Gamma"(link = "log"), 
          data = d)
summary(f0)
summary(f0)$dispersion

# Motor Trend Car Road Tests
data(mtcars)
head(mtcars); dim(mtcars);

f1 <- glm(mpg ~ cyl + disp + hp + drat + wt + qsec,
          family = "Gamma"(link = "log"),
          data = mtcars)
summary(f1)  





## Poisson dist'n ##
ny <- 1000
nx <- 2

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx, rep(1, nx)), ncol=1)
mu <- exp(cbind(1,x) %*% b)
y <- rpois(n = ny, lambda = mu)
hist(y)

d <- cbind.data.frame(y, x) 
head(d); dim(d);

# glm
f0 <- glm(y ~ ., 
          family = "poisson" (link = "log"),
          data = d)
summary(f0)

# Dobson (1990) Page 93: Randomized Controlled Trial :
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
d <- data.frame(treatment, outcome, counts)
d

f1 <- glm(counts ~ outcome + treatment, 
          family = "poisson" (link = "log"),
          data = d)
summary(f1)





## Bernoulli dist'n ##
ny <- 1000
nx <- 2

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx, rep(1, nx)), ncol=1)
p <- 1 / { 1 + exp(-cbind(1,x) %*% b) } 

m <- 1
y <- rbinom(n = ny, size = m, prob = p) 
hist(y)

d <- cbind.data.frame(y, x)
head(d); dim(d);

# glm
f0 <- glm(y ~ ., 
          family = "binomial" (link = "logit"),
          data = d)
summary(f0)

# https://www.theanalysisfactor.com/generalized-linear-models-glm-r-part4/
d <- structure(
  list(numeracy = c(6.6, 7.1, 7.3, 7.5, 7.9, 7.9, 8, 
                    8.2, 8.3, 8.3, 8.4, 8.4, 8.6, 8.7, 8.8, 8.8, 9.1, 9.1, 9.1, 9.3, 
                    9.5, 9.8, 10.1, 10.5, 10.6, 10.6, 10.6, 10.7, 10.8, 11, 11.1, 
                    11.2, 11.3, 12, 12.3, 12.4, 12.8, 12.8, 12.9, 13.4, 13.5, 13.6, 
                    13.8, 14.2, 14.3, 14.5, 14.6, 15, 15.1, 15.7), 
       anxiety = c(13.8, 
                   14.6, 17.4, 14.9, 13.4, 13.5, 13.8, 16.6, 13.5, 15.7, 13.6, 14, 
                   16.1, 10.5, 16.9, 17.4, 13.9, 15.8, 16.4, 14.7, 15, 13.3, 10.9, 
                   12.4, 12.9, 16.6, 16.9, 15.4, 13.1, 17.3, 13.1, 14, 17.7, 10.6, 
                   14.7, 10.1, 11.6, 14.2, 12.1, 13.9, 11.4, 15.1, 13, 11.3, 11.4, 
                   10.4, 14.4, 11, 14, 13.4), 
       success = c(0L, 0L, 0L, 1L, 0L, 1L, 
                   0L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 
                   1L, 1L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 
                   1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L)),
  .Names = c("numeracy", 
             "anxiety", "success"), 
  row.names = c(NA, -50L), 
  class = "data.frame")
d

f1 <- glm(success ~ ., 
          family = "binomial" (link = "logit"),
          data = d)
summary(f1)





## Binomial dist'n ##
ny <- 1000
nx <- 2

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx, rep(1, nx)), ncol=1)
p <- 1 / { 1 + exp(-cbind(1,x) %*% b) } 

m <- 5
y <- rbinom(n = ny, size = m, prob = p)    
hist(y)

d <- cbind.data.frame(y, m, x)
head(d); dim(d);

# glm
f0 <- glm(cbind(y, m-y) ~ ., 
          family = "binomial" (link = "logit"),
          data = d)
summary(f0)

# http://people.tamu.edu/~alawing/materials/ESSM689/GLMtutorial.pdf
d <- read.table("http://data.princeton.edu/wws509/datasets/cuse.dat", header=TRUE)
d

f1 <- glm(formula = cbind(using, notUsing) ~ age + education + wantsMore,
          family = "binomial" (link = "logit"),
          data = d)
summary(f1)





## Poisson with offset ##
ny <- 1000
nx <- 2
yt <- rpois(n = ny, 
            lambda = 10)

x <- list()
for(i in 1:nx) {
  x[[i]] <- runif(ny)
}
names(x) <- sprintf("x%d", 1:nx)
x <- do.call("cbind", x)

b <- matrix(c(-nx, rep(1, nx)), ncol=1)
mu <- exp(cbind(1,x) %*% b)
y <- rpois(n = ny, lambda = mu * yt)
hist(y)

d <- cbind.data.frame(y, yt, x) 
head(d); dim(d);

# glm
f0 <- glm(y ~ x1 + x2, 
          family = "poisson" (link = "log"),
          offset = log(yt),
          data = d)
summary(f0)

# https://onlinecourses.science.psu.edu/stat504/node/169
width <- c(22.69,23.84,24.77, 25.84,26.79,27.74,28.67,30.41)
cases <- c(14,14,28,39,22,24,18,14)
SaTotal <- c(14,20,67,105,63,93,71,72)
d <- data.frame(width,cases,SaTotal)
d

f1 <- glm(SaTotal ~ width, 
          family = "poisson" (link = "log"),
          offset = log(cases),
          data = d)
summary(f1)


