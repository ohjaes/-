


## Overdispersed count models ##

# 1) Quasi-Poisson regression
rqpois <- function(n, mu, phi) {
  rnbinom(n = n, mu = mu, size = mu / (phi - 1))
}

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
ph <- 2

y <- rqpois(n = ny, mu = mu, phi = ph)   
hist(y)

d <- cbind.data.frame(y, x) 
head(d); dim(d);

# glm
f0 <- glm(y ~ ., 
          family = "poisson",
          data = d)
summary(f0)

f1 <- glm(y ~ ., 
          family = "quasipoisson",
          data = d)
summary(f1)

c(summary(f1)$dispersion,  # dispersion parameter
  sum(residuals(f1, type = "pearson")^2)/f1$df.residual)

cbind(sqrt(diag(vcov(f0))*summary(f1)$dispersion),
      sqrt(diag(vcov(f1))))


# 2) Negative binomial regression
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

y <- rnbinom(n = ny, mu = mu, size = 1/th)   
hist(y)

d <- cbind.data.frame(y, x) 
head(d); dim(d);

# glm
library(MASS)
f1 <- glm.nb(y ~ ., 
             data = d)
summary(f1)
1/f1$theta  # dispersion parameter

library(aod)
f2 <- negbin(y ~ ., 
             random = ~ 1, 
             data = d)
summary(f2)
f2@random.param

library(msme)
f3 <- nbinomial(y ~ ., 
                formula2 = ~ 1, 
                data = d, 
                family = "negBinomial",
                mean.link = "log",
                scale.link = "identity_s")
summary(f3)
f3$coefficients["(Intercept)_s"]

c(1/f1$theta, 
  f2@random.param, 
  f3$coefficients["(Intercept)_s"])


# Article production by graduate students in biochemistry Ph.D. programs
# Long and Freese (2001), 
# REGRESSION MODELS FOR CATEGORICAL DEPENDENT VARIABLES USING STATA, p267
# http://data.princeton.edu/wws509/r/overdispersion.html
library(pscl)

data(bioChemists)
head(bioChemists); dim(bioChemists);
hist(bioChemists$art)

f1 <- glm(art ~ fem + mar + kid5 + phd + ment,
          family = "poisson",
          data = bioChemists)

f2 <- glm(art ~ fem + mar + kid5 + phd + ment,
          family = "quasipoisson",
          data = bioChemists)

f3 <- glm.nb(art ~ fem + mar + kid5 + phd + ment,
             data = bioChemists)

lapply(list(f1,f2,f3), summary)
lapply(list(f1,f2,f3), AIC)





## Overdispersed binomial models ##
library(rmutil)
rqbinom <- function(n, size, prob, phi) {
  rbetabinom(n = n, size = size, m = prob, s = (size - phi)/(phi - 1))
}

# 1) Quasi-logistic regression
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
ph <- 2 
y <- rqbinom(n = ny, size = m, prob = p, phi = ph)  
hist(y)

d <- cbind.data.frame(y, m, x)
head(d); dim(d);

# glm
f0 <- glm(cbind(y, m-y) ~ ., 
          family = "binomial" (link = "logit"),
          data = d)
summary(f0)

f1 <- glm(cbind(y, m-y) ~ ., 
          family = "quasibinomial" (link = "logit"),
          data = d)
summary(f1)

c(summary(f1)$dispersion,  # dispersion parameter
  sum(residuals(f1, type = "pearson")^2)/f1$df.residual)

cbind(sqrt(diag(vcov(f0))*summary(f1)$dispersion),
      sqrt(diag(vcov(f1))))


# 2) Beta-binomial regression
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
th <- 1 
y <- rbetabinom(n = ny, size = m, m = p, s = th)  
hist(y)

d <- cbind.data.frame(y, m, x)
head(d); dim(d);

f1 <- betabin(cbind(y, m-y) ~ ., 
              random = ~ 1, 
              # link = "logit", 
              data = d)
summary(f1)
list(esti = summary(f1)@Phi, true = 1/(1+th))


# Mortality of Djallonke Lambs in Senegal
data(dja)
head(dja); dim(dja);

f1 <- glm(cbind(y, n - y) ~ group * trisk, 
          family = "binomial" (link = "logit"),
          data = dja)

f2 <- glm(cbind(y, n - y) ~ group * trisk,  
          family = "quasibinomial" (link = "logit"),
          data = dja)

f3 <- betabin(cbind(y, n - y) ~ group * trisk, 
        random = ~ 1, 
        link = "logit",
        data = dja)

lapply(list(f1,f2,f3), summary)
lapply(list(f1,f2,f3), AIC)





## Dispersion modeling by double glm ##
library(statmod)
clotting <- data.frame(
  u = c(5,10,15,20,30,40,60,80,100),
  lot1 = c(118,58,42,35,27,25,21,19,18),
  lot2 = c(69,35,26,21,18,16,13,12,12)
)
clotting

library(dglm)
f1 <- dglm(lot1 ~ log(u), 
           dformula = ~ 1, 
           family = "Gamma" (link = "log"),
           dlink = "log", 
           data = clotting)
summary(f1)

f2 <- dglm(lot1 ~ log(u), 
           dformula = ~ u, 
           family = "Gamma" (link = "log"),
           dlink = "log", 
           data = clotting)
summary(f2)


