######연습문제1######
#1. animation 이름의 패키지 설치하고 불러오기
install.packages("animation")
library(animation)

#2. animation 패키지에서 제공되는 함수 및 자료 목록 출력
search() #animation패키지 찾으려고 쓴것
ls(2)   #animation함수가 2번에 있어서 2 썻

#3. animation 패키지 내의 함수 중 하나를 정하여 예제 코드 실행 및 설명
example(ls(2)[37])

#4. test 와 관련된 R 함수 찾기
help.search("test")  #test와 관련된 r 함수 찾기

#5. BMI (체질량 지수) 계산하기
#(계산식) 체중 / (키(m)의 제곱)
#18.5 이하 저체중, 18.5 - 24.9 정상
#74/(1.81*1.81)

##################################################################################

######연습문제2######
#1. 성분으로 ‘0’, ‘21’, ‘12’, ’16’을 갖는 문자열 벡터를 x라는 이름으로 생성하시오.
x <- c('0','21','12','16')  #벡터 만들기
x
mode(x)   #x의 타입알려주는거

#2. 1번의 x를 숫자형 변수로 변환하고 오름차순으로 정렬하시오.
#    (여기서 변환이란 변환하여 x에 다시 저장하는 것을 의미)
x <- as.numeric(x)
x
mode(x)
sort(x)  #sort()의 디폴트는 오름차순

#3. x를 논리형 변수로 변환하시오.
x <- as.logical(x)
x
mode(x)

#4. seq함수를 이용하여 y라는 변수명으로 0, 10, 20, 30의 수열을 생성하시오.
y <- seq(from=0,to=30,by=10)
y

#5. x < y의 논리 값과 x <= y 의 논리 값을 and 연산 하시오.
x<y & x<=y

#6. repeat 함수를 이용하여 TRUE, FALSE의 순서로 반복하는 크기 10의 벡터
#    를 생성하여 변수에 저장하시오. (변수명은 임의로 지정)
r <- rep(c(TRUE,FALSE),times=5) #times=5는 5번 반복  each=5는 각각5번 반
r

########################################################################################

######연습문제3######
#1. 1항이 -10 부터 시작하여 30항이 10에서 끝나는 등차수열을 생성하여 x에 저장하시오.
x <- seq(from=-10,to=10,length=30)
x

#2. "S","T","A","T","S" 의 값을 순서대로 6번 반복하여 30개의 원소를 갖는 문자열 벡터 y를 생성하시오. 
y <- rep(c("S","T","A","T","S"),times=6)
y

#3. 0,7을 각각 15번 씩 반복하여 길이 30인 벡터 z를 생성하고 이를 논리형으로 변환하여 zm에 저장하시오.
z <- rep(c(0,7),each=15)
z
zm <- as.logical(z)
zm

#4. 1번의 x를 이용하여 6 x 5 의 행렬을 생성하고 xmat 변수에 저장 하시오. (행기준으로 채움)
xmat <- matrix(x,nrow = 6,ncol = 5,byrow=T) #byrow=T 행기준(가로)
xmat

#5. 1,2,3의 결과를 각각 성분으로 갖는 데이터프레임 xdat 를 생성하시오.
xdat <- data.frame(x,y,z)
xdat

#6. x, y, zm, xdat를 원소로 갖는 리스트를 생성하여 xlst에 저장하시오.
xlst <- list(x,y,z,xdat)
xlst

#7. 5의 xdat 중에서 첫번째와 두번째 변수를 선택하여 행렬로 변환하시오.
matrix(c(xdat$x,xdat$y),nrow=30,ncol=2)  #모르는 문제

#8. 5의 xdat 중에서 첫번째와 세번째 변수를 선택하여 행렬로 변환하시오.
matrix(c(xdat$x,xdat$z),nrow=30,ncol=2)  #모르는 문제

#9. 1의 x 벡터에서 -2보다 크고 4보다 작은 원소의 합을 구하시오.
sum(x[x>-2 & x<4])

#10. 4의 xmat에서 행의 합, 열의 평균, 분산 값을 각각 계산하시오.
apply(xmat,1,sum)  #행의합
apply(xmat,2,mean) #열의 평균
apply(xmat,2,var)  #열의 분산

##################################################################################
###연습문제4
#1. Ex_data.csv로 부터 자료를 읽어서 raw_dat로 저장하시오.
raw_dat = read.csv(file = "Ex_data.csv",header = T)
raw_dat

#2.head 함수를 사용하여 입력된 raw_dat를 확인하시오.
head(raw_dat)

#3.raw_dat의 자료의 차원을 구하시오.
dim(raw_dat)

#4.raw_dat의 첫번째 열에서 유전자의 이름을 추출하고 gene_name.txt로 저장하시오
library(dplyr)
gene_name <- select(raw_dat,Gene.Symbol)
write.table(gene_name,file = 'gene_name.txt',quote = F,sep = ",")

write.table(raw_dat[,1],file='gege_name.txt',quote = F, sep=",")

#5.raw_dat의 3,9,10 열의 성분을 선택하여 새로운 변수에 저장하고
#sub_data.txt로 저장하시오. (구분은 tab을 이용할 것)
thr <- select(raw_dat,NCI_U133A_2L,NCI_U133A_8L,NCI_U133A_9L)
write.table(thr,file="sub_data.txt",quote = F,sep = "\t")

new <- raw_dat[,c(3,9,10)]
write.table(new,file="sub_data.txt",quote = F,sep = "\t",col.names = T)

#6.raw_dat의 31~100의 행과 21~40 사이의 짝수 열을 선택하여 새로운 변수
#에 저장하고 sub_data2.csv로 저장하시오. (구분을 comma 사용) 모르겠음...
newb <- raw_dat[31:100,seq(from=22,to=40,by=2)]
write.table(newb,file = "sub_data2.csv",sep = ",",quote = F)

#7. raw_dat에서 결측값의 갯수를 구하시오.
sum(is.na(raw_dat))

#8. raw_dat에서 결측값의 위치를 1차원 인덱스로 찾으시오.
which(is.na(raw_dat)) 

#9. raw_dat에서 결측값의 위치를 2차원 인덱스로 찾으시오.
which(is.na(raw_dat),arr.ind = T) 

# #10.9번에서 찾은 raw_dat에서 결측값의 위치를 index 변수에 저장하고 이를
# 활용하여 결측값이 발생한 열의 결측값 제외 평균을 계산하여 각 결측값
# 을 대체하시오. (결측값 제외 평균 계산: mean(x, na.rm=T) 이용)
index = which(is.na(raw_dat),arr.ind = T)
index
for (i in 1:24) {
  raw_dat[index[i,1],index[i,2]] <-mean(raw_dat[,index[i,2]],na.rm = T)
}
raw_dat[index]

##############################################################################################################
x <- runif(10)
#연습문제5
#1.조건문을 사용하여 x의 원소의 합이 5보다 클 경우 "sum(x) is greater than 5"
# 를, 5보다 작을 경우에는 "sum(x) is less than 5.", 같을 경우에는"sum(x) is equal to 5"를
# 출력하는 코드를 작성하시오.
ifelse(sum(x)>5,"sum(x) is greater than 5",ifelse(sum(x)==5,"sum(x) is equal to 5","sum(x) is less than 5"))

#2. 조건문을 사용하여 x의 원소 중 0.5보다 작은 값은 동일한 원소를 갖으며,
# 0.5보다 크거나 같은 값은 0.3만큼 작은 값을 갖는 벡터 y를 정의하시오.
y = ifelse(x < 0.5, x, x - 0.3)

y <-c()
for (i in 1:length(x)) {
  if(x[i]<0.5){
    y[i]<-x[i]
  }
  else{
    y[i]<-x[i]-0.3
  }
}

#3. 변수i를 이용하여 i=1일 때, x+y, i=2일 때, x*y를 출력하는 구문을 switch함수를 이용하여 작성하시오.
i<-2
switch(i,x+y,x-y,x*y)

#score<-65 입력하고 아래의 물음에 답하시오.
score <- 65
#4. 조건문을 사용하여 score가 90이상이면 A, 75 이상이면 B, 50 이상이면C, 그 외 다른 값은 D의 값을 출력하는 코드를 작성하시오.
if(score >= 90){
  cat("A")
}else if(score >=75){
  cat("B")
}else if(score >= 50){
  cat("C")
}else{
  cat("D")
}


#5.type변수에 "sqrt","square","log" 중 하나의 값을 할당한다고 할 때, 해당변수값에 따라서 "sqrt"일 때는 score의 제곱근,
# "square"는 score의 제곱,"log"는 score의 상용로그값을 출력하는 코드를 작성하시오.
type = 'log'
switch(type,sqrt=sqrt(score),square=score^2,log=log(score,base = 10)) #log10(score)

##################################################################################################
#연습문제6
# 1. while 문과 조건문을 이용하여 아래와 같이 출력하는 코드를 작성하시오.
# 
# 2. 100에서 부터 1까지 차례로 더해 나갈 때, 처음으로 합이 3000을 넘게 만
# 드는 수는 무엇인지 for문과 break 문을 이용하여 구하여라. 또한 처음으
# 로 3000을 넘었을 때, 누적합은 얼마인지 구하여라.
# 
# 3. 1에서 50까지의 수 중에서 1과 자기 자신만을 약수로 갖는 수(소수)는 어
# 떠한 것이 있으며, 총 몇 개인지 반복문 및 조건문을 사용하여 계산하여
# 라.
# 
# 4. 3의 코드를 활용하여 30에서 50 사이의 소수의 합을 계산하는 코드를
# 작성하시오. (단, next 함수를 활용하여 작성하시오.)
# 
# 5. x = runif(1e7, 0, 100)을 실행하고 x의 값이 5보다 크고 20보다 작은 수만
# 선택하여 합을 계산하고자 할 때, 아래와 같이 코드를 작성하시오.
# 
# 1) 반복문과 조건문을 이용하여 계산하고 실행 시간을 체크하시오.
# 
#2) 인덱스를 이용하여 계산하고 실행 시간을 체크하시오.


###################################################################################################
########################연습문제7###############################
# 1. 하나의 벡터를 입력 받아 벡터의 길이, 원소의 합, 원소의 곱, 최솟값, 최
# 댓값, 평균, 분산을 반환하는 함수를 작성하고 x = 1:10에 대한 결과를 확
# 인하시오.
func <- function(x){
  a = length(x)
  b = 0
  for (i in x) {
    b <- b + i
  }
  c=1
  for (i in x){
    c <- c * i
  }
  d <- min(x)
  e <- max(x)
  f <- mean(x)
  g <- var(x)
  return(list("벡터의 길이"=a,"sum"=b,"product"=c,"min"=d,"max"=e,"mean"=f,"var"=g))
}
x <- 1:10
func(x)

# 2. 1에서 작성한 함수를 활용하여 하나의 벡터와 하나의 인수를 입력 받아
# 추가로 입력한 인수의 값이 1인 경우 벡터의 길이, 2인 경우 원소의 합과
# 같이 특정 값을 선택할 수 있도록 함수를 작성하시오. x=1:10의 값을 이
# 용하여 각각의 경우에 대해서 결과를 확인하시오.
func <- function(x,n){
  a = length(x)
  b = 0
  for (i in x) {
    b <- b + i
  }
  c=1
  for (i in x){
    c <- c * i
  }
  d <- min(x)
  e <- max(x)
  f <- mean(x)
  g <- var(x)
  ls <- list("벡터의 길이"=a,"sum"=b,"product"=c,"min"=d,"max"=e,"mean"=f,"var"=g)
  return(ls[n])
}
x <- 1:10
func(x,3)
 
# 3. 2에서 작성한 함수에서 새로운 인수를 생략 시 원소의 곱을 출력하도록
# default 설정을 적용하시오.

func <- function(x,n=3){
  a = length(x)
  b = 0
  for (i in x) {
    b <- b + i
  }
  c=1
  for (i in x){
    c <- c * i
  }
  d <- min(x)
  e <- max(x)
  f <- mean(x)
  g <- var(x)
  ls <- list("벡터의 길이"=a,"sum"=b,"product"=c,"min"=d,"max"=e,"mean"=f,"var"=g)
  return(ls[n])
}
x <- 1:10
func(x)
 
# 4.이차방정식의 해를 반환하는 함수를 생성하시오.
#   (a는0인경우는 일차방정식의 해,),(a,b,c의 값은 사용자가 입력),(실수해가 존재하지 않은 경우는 복소수의 해를 반환)
ans <- function(a,b,c){
  #answer = 0
  D <- b^2 - 4*a*c
  if(a == 0){
    answer <- c/(-b)
    return(answer)
  }else if(D > 0){
    answer1<-list((-b+sqrt(D))/(2*a),(-b-sqrt(D))/(2*a))
    return(answer1)
  }else if(D == 0){
    answer <- -b/(2*a)
    return(answer)
  }else{
    D <- D+0i
    answer1 <- (-b+sqrt(D))/(2*a)
    answer2 <- (-b-sqrt(D))/(2*a)
    return(list(answer1,answer2))
    
  }
}
ans(1,2,1)
ans(1,2,5)














