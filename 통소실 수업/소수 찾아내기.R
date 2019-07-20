##3번 1에서 50까지 소수 어떤거 있는지 알아내기
asd = list()
n = 1
for (i in 2:50) {
  count = 0
  if(i == 2){
    asd[n] = i
    n = n + 1
  }
  else if(i == 3){
    asd[n] = i
    n = n+1
  }
  else{
    for (j in 2:i-1) {
      if(i%%j !=0){
        count = count + 1
      }
      else{
        next
      }
      
    }
    if(count+2 == i){
      asd[n] = i
      n = n+1
    }
  }
  
}
asd

##4. 3번의 코드를 활용하여 30에서 50사이의 소수의 합을 계산하시오.
asd = list()
n = 1
for (i in 30:50) {
  count = 0
  if(i == 2){
    asd[n] = i
    n = n + 1
  }
  else if(i == 3){
    asd[n] = i
    n = n+1
  }
  else{
    for (j in 2:i-1) {
      if(i%%j !=0){
        count = count + 1
      }
      else{
        next
      }
      
    }
    if(count+2 == i){
      asd[n] = i
      n = n+1
    }
  }
  
}
asd
sum = 0
for (i in 1:length(asd)) {
  sum = sum + as.numeric(asd[i])
}
sum