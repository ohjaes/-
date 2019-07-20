##품질관리 homework#4

###1번 문제###
x <- vector()
x <- 1:20
y <- c(8,1,3,0,2,4,0,1,10,6,6,0,4,0,3,1,15,2,3,0)
dat <- cbind(x,y)
frac <- y/150
dat1 <- cbind(dat,frac)
pvar <- sum(dat1[,3])/20
ucl <- pvar + (3*sqrt(pvar*(1-pvar)/150))
lcl <- pvar - (3*sqrt(pvar*(1-pvar)/150))
which(dat1[,3]>ucl)

rey <- c(8,1,3,0,2,4,0,1,0,6,6,0,4,0,3,1,0,2,3,0)
redat <- cbind(x,rey)
refrac <- rey/150
redat1 <- cbind(redat,refrac)
repvar <- sum(redat1[,3])/18
reucl <- repvar + (3*sqrt(repvar*(1-repvar)/150))
relcl <- repvar - (3*sqrt(repvar*(1-repvar)/150))

###2번 문제###
#(a)
x2 <- 1:20
y2 <- c(230,435,221,346,230,327,285,311,342,308,456,394,285,331,198,414,131,269,221,407)
frac2 <- y2/2500
dat2 <- cbind(x2,y2,frac2)
pvar2 <- sum(dat2[,3])/20 
ucl2 <- pvar2 + (3*sqrt(pvar2*(1-pvar2)/2500))
lcl2 <- pvar2 - (3*sqrt(pvar2*(1-pvar2)/2500))
which(dat2[,3]>ucl2 | dat2[,3]<lcl2)
plot(frac2,main = "2번 trial control chart")
abline(ucl2,0)
abline(lcl2,0)

#(b)
#비율말고 개수로 컨트롤 차트를 그려보는 것도 괜찮을 거 같다.#

###3번 문제###
p3 = 0.02
n3 = 50
ucl3 <- p3 + (3*sqrt(p*(1-p)/50))
lcl3 <- p3 - (3*sqrt(p*(1-p)/50))
ucl3*50
a <-pbinom(ucl3*50,50,0.04)
b <- pbinom(0,50,0.04)
a - b


###4번 문제###
p0 = 0.1
n4 = 64
delta4 = 0.4
k4 <- delta4/sqrt(p0*(1-p0)/n4)

n4 <- (k4/delta4)^2*(p0*(1-p0))

###5번 문제###
pvar5 = 0.07
n5 = 400
ucl5 <- pvar5 + (3*sqrt(pvar5*(1-pvar5)/n5))
lcl5 <- pvar5 - (3*sqrt(pvar5*(1-pvar5)/n5))
a5 <- pbinom(n5*ucl5,n5,0.1)
b5 <- pbinom(n5*lcl5,n5,0.1)
p5a <- a5-b5

p5a + p5a*(1-p5a)
