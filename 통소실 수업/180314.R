A <- T
B<-F
C<-c(T,T)
D<-c(F,T)
A & B
A&&B
C&D
C&&D
A|D
C||D

a<-c(1,2)
b<-c(2,2)
d<-c(3,4)
a<b
a<=b
a>d
a>=d
a==b
a!=b

A <- c(T,T)
B<-c(F,T)
C <- c(T,T)
D<-c(T,F)
A==B
C==D
all(A==B)
all(A==C)
any(A==B)
any(B==D)

C>D
A>B
T>"cs"  #원래 연산은 타입이 다른애들끼리 안되서 타입을 맞춰줘야된다. 논리랑 숫자랑 붙으면 숫자가 이김
        # "TRUE" > "cs"는 문자끼리 비교할때 앞에서 부터라서 t와c비교 따라서 TRUE

3^2%%4
3*2%%4
a=1
a=a+2
a

x<-c(-5,10,2,5,8,9)
var(x)
mean(x)
sum((x-mean(x))^2)/(length(x)-1)

x<-c(1,5,3,2,4)
sort(x)
order(x)
y<-c("0","F","G","B","A")
y[order(x)]

complex(real=-17,imaginary = 0)
complex(3,1)
complex(3,10,-2)

sqrt(-17)
sqrt(-17+0i)
z<-0+1i
Re(z)   #실수부분 나타내는 함수
Im(z)   #허수부분 나타내는 함ㅅ
Mod(z)
Conj(z)
z*Conj(z)
Arg(z)
pi/2
as.complex(paste0(3,"+",2,"i"))수

rep(c(1,2),times=3)
rep(c(1,2),each=3)

seq(from=1,to=10)
seq(length=10,from = 5,by=3)
seq(length=6,to=10,by=2)

letters  #영어 알파벳 소문자들을 정의해놓은 벡터
LETTERS  #영어 알파벳 대문자들을 정의해놓은 벡ㅌ

length = 1
length
rm(length)  #변수 지우는 함수rm()
length

vec <- vector()
vec
vec2 = numeric()
vec2
vec2[1:3] = c(T,T,F)  #타입이 더 쎈 녀석으로 자동으로 바껴서 들어간ㄷ
vec2 = 다numeric()
vec2
vec2[1:3] = letters[1:3]
vec2
vec3 = logical()
vec3
vec4 = character()
vec4[1] = 1
vec4
