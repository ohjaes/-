# 2018-03-07
help.start()
help(boxplot)  #함수 이름 알고있을 때
?boxplot       #함수 이름 알고있을 때
boxplot(count ~ spray, data = InsectSprays, col = "lightgray")
InsectSprays   #r이 제공해주는 기본 데이터
?InsectSprays
example(boxplot)  #예제코드 실행
x = 3
y = 15
x = c(1,3,5,7)
x[3]
{ x=3
  y=2}         #이거 한줄에 쓰면 안됨 한줄에 쓰려면 ; 써라

{x=3 ; y=2}

search()
library(MASS)
search()      #MASS 패키지 추가됨 순서 중요
objects(pos=1)    #search에 있는거 포지션 1번꺼 목록 보여주는 것
ls()              #ls도 같은 기능
objects()
ls(2)         #MASS 패키지 함수 목록들 보는 것
help(ls(2)[101])  #여기서 help대신 ?쓰면 연산자때매 안된다 여기서는 help만 써라
z=1:10000000
remove(z)        #지우는 함수
rm(y)
rm(list=c("y","xi"))
rm(list=ls())  #현재 목록 다 날려버리는 것
?options
pi
options(digits=20)
pi

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

