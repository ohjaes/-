####################n = 300,   시그마는 1로 했다.#####################
#no drift 경우
a = vector()
at1 = vector()
at1[1] = rnorm(1,0,1)
a[1]=0
for (i in 2:300) {
  at1[i] <- rnorm(1,0,1)
  a[i] = a[i-1] + at1[i]
}
plot(a)

#drift = 0.3인 경우
a = vector()
at2 = vector()
at2[1] = rnorm(1,0,1)
a[1]=0
for (i in 2:300) {
  at2[i] <- rnorm(1,0,1)
  a[i] = a[i-1] + at2[i] + 0.3
}
plot(a)
