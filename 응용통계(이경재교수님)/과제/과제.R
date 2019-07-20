#1장 1번
height <- c(163,157,178,190,150,167,183,153,160,172,168)

weight <- c(57,42,67,85,40,55,72,43,55,67,69)

BMI <- vector()
for (i in 1:11) {
  BMI[i] <- weight[i] / (height[i]*0.01)^2
}

physical <- data.frame("키"=height,"무게"=weight,"BMI"=BMI)
physical

ind <- which(physical$BMI < 20)
under <- physical[ind,]
# physical[physical$BMI < 20,]
under

#1장 3번
time <- c(12,13,9,4,4,7,10,3,8,3,5,9,14,10,3,6,6,8,9)
score <- c(97,90,89,85,63,75,80,55,78,42,63,78,88,92,82,72,45,72,80)
plot(time,score,xlab = "시간",ylab = "점수", main = "산점도")

a <- rep(1,19)
x <- matrix(c(a,time),19,2)
y <- matrix(score,19,1)
b = solve(t(x)%*%x) %*% t(x) %*% y
abline(b[1],b[2])

#1장 5번
x <- seq(0,1,by = 0.0001)
beta_pdf <- dbeta(x,2,7)
plot(x,beta_pdf,type="l")
a <- qbeta(0.025,2,7)
b <- qbeta(0.975,2,7)
lines(c(a,a), c(0,dbeta(a,2,7)))
lines(c(b,b),c(0,dbeta(b,2,7)))
xx <- x[x>a & x < b]
polygon(c(a,xx,b),c(0,dbeta(xx,2,7),0),col="gold")
text(a,0,labels = round(a,4))
text(b,0,labels = round(b,4))

