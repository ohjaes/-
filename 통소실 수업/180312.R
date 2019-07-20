real <- 3.5; as.integer(real)
intg <- 3; is.integer(intg)  #false인 이유는 r에서는 우리가 3 입력해도 r에서는 실수로 처리해서
intg2 <- as.integer(3); is.integer(intg2)

#?as.integer

real <- 3
is.double(real)

ch <- c("red","blue","yellow")
ch[1]
ch[3]
ch2<-c("a",'b',"c")

test <-c(TRUE,FALSE,TRUE)
is.logical(test)
test2 <- c(T,F,T)
as.numeric(test2)
as.character(test)
as.character(test2)
as.logical(c(1,0,2,3))
as.logical(c("T","F"))
as.logical(c("a","b"))

x<-"char"
mode(x)

x<-5
is.character(x)
is.numeric(x)
is.double(x)

x<-"abc"
as.double(x)
x<-1
as.character(x)
as.character(123)

is.integer(3:5)  #정수형으로 시작하면 정수형으로 나옴
is.integer(3.1:5) # 정수형으로 시작안해서 false

vec <-c(1,3,4,2,5)
vec[1]
vec[3:5]
vec[7]
vec[10] = 5
vec

if <-c(1,2,3)

num<-c(1,2,3)
ch <-c("red","blue","yellow")
ch
lo <- c(T,F,F,T)
lo
num2<-c(1,2,"red","blue")
num2
lo2 <- c(T,F,1,3)
lo2
lo3 <-c(T,F,"abc")
lo3

assign("x",1:10)
x
name = paste0("x",1:5)
name
for(i in 1:5)
  assign(name[i],1:10)
ls()

x1 <- 1:10
x1
x2 = 5:1
x2
x3<<- 1:10
x3
x<- c(1,2,3)
y<-c(1,2,3,4)
v<-2*x + y + 1
v
z=c(4,5)
w=2*z + y  #반복 한거 모를수도 있어서 가독성 안좋음.
w
w=2*rep(z,2)+y  #가독성 위해 rep쓰면 2번 반복하는거 알수있다.
w
