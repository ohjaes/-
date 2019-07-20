##연습문제1
#1.
install.packages("animation")
library(animation)

#2.
search()
ls(2)

#3.
example(ls(2)[7])

#4.
help.search("test")  #test와 관련된 r 함수 찾기

#5.
74/(1.81*1.81)

##연습문제2
#1.
x <- c('0','21','12','16')
x
mode(x)

#2.
x <- as.numeric(x)
x
mode(x)
sort(x)

#3.
x <- as.logical(x)
x
mode(x)

#4.
y <- seq(from=0,to=30,by=10)
y

#5.
x<y & x<=y

#6.
r <- rep(c(TRUE,FALSE),times=5)
r
