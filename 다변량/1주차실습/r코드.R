### Box plot
setwd('C:/Users/user/Desktop/오재훈/대학교_자료/다변량/1주차실습')
data<-read.table("T1-1.DAT")
head(data)

colnames(data)<-c("Player payroll","Won-lost percentage")

op<-par(mfrow=c(1,2))
boxplot(data[,1],main="Player payroll")
boxplot(data[,2],main="Won-lost percentage")
par(op)


set.seed(123)
x<-rnorm(100)
x[50]<-x[50]+3
x[75]<-x[75]-3
boxplot(x,range=1.5)  #### idenifying some outliers


### Scatter Plots
data<-read.table("T1-2.DAT")
head(data)

colnames(data)<-c("Density","Machine Direction","Cross Direction")
pairs(data)
#pairs(~data[,1]+data[,2]+data[,3])

### Scatter plots with box plots (by Prof.Ripley)

panel.bxp <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 2, usr[3:4]))
  boxplot(x, add=TRUE)
}
pairs(data, diag.panel = panel.bxp, text.panel = function(...){})


boxplot(data[,1],range=1.5,main="Density")

### "GGally" package
# install.packages('GGally')
library(GGally)
data(tips, package="reshape")

ggpairs(data=tips, # data.frame with variables
        columns=1:3, # columns to plot, default to all.
        title="tips data", # title of the plot
)



### Scatter Plot in 3D
# install.packages('scatterplot3d')
library(scatterplot3d)
data<-read.table("T1-3.DAT")
head(data)

colnames(data)<-c("Mass","SVL","HLS")
attach(data)
scatterplot3d(SVL,HLS,Mass,main="3D Scatterplot")





# Spinning 3d Scatterplot
# install.packages('rgl')
library(rgl)
plot3d(SVL,HLS,Mass,col="red", size=3) 



# Growth curves
data<-read.table("T1-4.DAT")
head(data)

colnames(data)<-c("Wt2","Wt3","Wt4","Wt5","Length2","Length3","Length4","Length5")

Year<-c(2,3,4,5)
plot(Year,data[1,1:4],type="l",ylim=c(50,250),ylab="Weight",xlab="Year")
for (k in 2:7){
  lines(Year,data[k,1:4])
}

# ggplots for growth curves

data$id<-1:dim(data)[1]
dat2<-cbind(data$Wt2,data$Length2,data$id,2)
dat3<-cbind(data$Wt3,data$Length3,data$id,3)
dat4<-cbind(data$Wt4,data$Length4,data$id,4)
dat5<-cbind(data$Wt5,data$Length5,data$id,5)

longdata<-rbind(dat2,dat3,dat4,dat5)
colnames(longdata)<-c("Wt","Length","id","time")
longdata<-as.data.frame(longdata)

library(ggplot2) 

qplot(time, Wt, data = longdata, group = id, color = factor(id), geom = 'line') 

qplot(time, Wt, data = longdata, facets=~id, geom = 'line') 


## Chernoff Face
# install.packages('TeachingDemos')
library(TeachingDemos)

data<-read.table("T1-4.DAT")
head(data)
faces2(data)


### The problem of high-dimension : knn

## p=3
train0<-cbind(rnorm(1000,mean=0),rnorm(1000),rnorm(1000))
train1<-cbind(rnorm(1000,mean=2),rnorm(1000),rnorm(1000))
train<-rbind(train0,train1)

test0<-cbind(rnorm(100,mean=0),rnorm(100),rnorm(100))
test1<-cbind(rnorm(100,mean=2),rnorm(100),rnorm(100))
test<-rbind(test0,test1)

cl.train<-as.factor(c(rep(0,1000),rep(1,1000)))
cl.test<-c(rep(0,100),rep(1,100))

library(class)
fit<-knn(train,test,cl.train,k=3)

table(fit,cl.test)


## p=1000   맨뒷장에 필기한거 돌려본거다.
train0<-matrix(rnorm(1000*1000),1000,1000)
train1<-cbind(rnorm(1000,mean=2),matrix(rnorm(1000*999),1000,999))
train<-rbind(train0,train1)

test0<-matrix(rnorm(100*1000),100,1000)
test1<-cbind(rnorm(100,mean=2),matrix(rnorm(100*999),100,999))
test<-rbind(test0,test1)

cl.train<-as.factor(c(rep(0,1000),rep(1,1000)))
cl.test<-c(rep(0,100),rep(1,100))

library(class)
fit<-knn(train,test,cl.train,k=3)

table(fit,cl.test)










