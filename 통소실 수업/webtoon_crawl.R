# 전체 웹툰 목록에서 웹툰별 btno들을 취합
# btno 마다 page=1(최신, 역순) 로 들어가서 bsno를 파악 
# 그 page의 bsno를 다 보면 page ++
# page가 다시 예전 bsno(최신)들을 보여주면 끝난 것

# install.packages('httr')
# install.packages("rvest")
library(httr)
library(rvest)

TOTAL_URL = 'http://comics.nate.com/webtoon/?category=2'
BTNO_SUB = '__BTNO__'
PAGE_SUB = '__PAGE__'
BSNO_SUB = '__BSNO__'
PAGE_URL = paste0('http://comics.nate.com/webtoon/list.php?btno=', BTNO_SUB, '&page=', PAGE_SUB,'&spage=1&category=2&order=cnt_view')
EPI_URL = paste0('http://comics.nate.com/webtoon/detail.php?btno=', BTNO_SUB, '&bsno=', BSNO_SUB,'&category=2')

TOON_SELECTOR = '.wtl_toon'
TITLE_SELECTOR = '.wtl_title'
AUTHOR_SELECTOR = '.wtl_author'
HREF = 'href'
EPI_LI_SELECTOR = 'ul.tel_list > li.first > a'
EPI_INFO_SELECTOR = '.tvi_infoBox'
EPI_NUM_SELECTOR = '.tvi_episodeNum'
EPI_TITLE_SELECTOR = '.tvi_episodeTitle'
EPI_RECOM_SELECTOR = '#topVoteNum'
EPI_REPLY_SELECTOR = '.tvi_replyNum'

get_webtoon_meta = function() {
  html = read_html(TOTAL_URL)
  nodes = html_nodes(html, TOON_SELECTOR)
  
  webtoon_title = c()
  webtoon_author = c()
  webtoon_btno = c()
  for (i in 1:length(nodes)) {
    title_node = html_nodes(nodes[i], TITLE_SELECTOR)
    webtoon_title[length(webtoon_title) + 1] = html_text(title_node)
    author_node = html_nodes(nodes[i], AUTHOR_SELECTOR)
    webtoon_author[length(webtoon_author) + 1] = html_text(author_node)
    webtoon_btno[length(webtoon_btno) + 1] = parse_url(html_attr(nodes[i], HREF))$query$btno
  }
  
  return(list(title=webtoon_title, author=webtoon_author, btno=webtoon_btno))
}

get_each_episode = function(btno, bsno) {
  eurl = gsub(BTNO_SUB, btno, EPI_URL)
  eurl = gsub(BSNO_SUB, bsno, eurl)
  epi_html = read_html(eurl)
  info_node = html_node(epi_html, EPI_INFO_SELECTOR)
  epi_num = html_text(html_node(info_node, EPI_NUM_SELECTOR))
  epi_num = as.numeric(gsub('([^0-9]*)', '', epi_num))
  epi_title = html_text(html_node(info_node, EPI_TITLE_SELECTOR))
  epi_recom = as.numeric(html_text(html_node(info_node, EPI_RECOM_SELECTOR)))
  epi_reply = as.numeric(html_text(html_node(info_node, EPI_REPLY_SELECTOR)))
  
  return(list(title=epi_title, recom=epi_recom, reply=epi_reply))
}

get_episodes = function(btno) {
  episodes = list()
  page_idx = 1
  
  while (TRUE) {
    cat('      page: ', page_idx, '\n')
    purl = gsub(BTNO_SUB, btno, PAGE_URL)
    purl = gsub(PAGE_SUB, as.numeric(page_idx), purl)
    page_html = read_html(purl)
    epi_nodes = html_nodes(page_html, EPI_LI_SELECTOR)
    
    checking_bsno = parse_url(html_attr(epi_nodes[1], HREF))$query$bsno
    if (length(episodes) > 0) {
      if (episodes[[1]]$bsno[1] == checking_bsno)
        break
    }
    
    for (i in 1:length(epi_nodes)) {
      each_bsno = parse_url(html_attr(epi_nodes[i], HREF))$query$bsno
      epi_data = get_each_episode(btno, each_bsno)
      episodes[[length(episodes) + 1]] = c(list(bsno=each_bsno), epi_data)
    }
    
    page_idx = page_idx + 1
  }
  
  return(episodes)
}

webtoons = get_webtoon_meta()
for (i in 1:length(webtoons$btno)) {
  cat('webtoon: ', i, '\n')
  webtoons$episodes[[i]] = get_episodes(webtoons$btno[i])
}

#작가별 추천수 총합 구하기
total_recom = list()

for (i in 1:length(webtoons$episodes)) {
  total=0
  for (j in 1:length(webtoons$episodes[[i]])) {
    total <- total + webtoons$episodes[[i]][[j]]$recom
  }
  total_recom[i] <- total 
}
total_recom <- unlist(total_recom) #작가별 추천수의 총 합
total_recom

#작가별 추천수 그래프
par(mfrow=c(1,1))
# hist(total_recom)
barplot(total_recom,names.arg = webtoons$author,ylim = c(0,20000),main = "작가별 추천수")  

#작가별 댓글수 총합 구하기
total_reply = list()
for (i in 1:length(webtoons$episodes)) {
  total = 0
  for (j in 1:length(webtoons$episodes[[i]])) {
    total <<- total + webtoons$episodes[[i]][[j]]$reply
  }
  total_reply[i] <- total
}
total_reply<- unlist(total_reply) #작가별 댓글의 총 합


#작가별 댓글수 그래프
# hist(total_reply)
barplot(total_reply,names.arg = webtoons$author,ylim = c(0,16000),main = "작가별 댓글수") 

#작가별 회차
page_length <- list()
for (i in 1:45) {
  page_length[i] <- length(webtoons$episodes[[i]])
}
page_length<-unlist(page_length)

###분석목적: 회차수가 가장 많은 작가의 추천수의 평균과 중간인 작가의 추천수 평균이 같은지를 검정하고싶다. 댓글수도 자료가 있지만 댓글은 좋은 글,나쁜 글을 구분하기 어려워서 추천수로 찾기로했다.
##           회차수가 다른 둘의 추천수 평균이 같다면 회차수가 많은 작가가 이야기를 더 재미있게 오래 이어간다고 할 수 있다.
##           독자들의 관심을 오랫동안 받아왔다는 방증이 된다고 할 수 있다. 일반적으로 후반부로 갈수록 추천수가 떨어진다는 가정을 한다.
#작가별 평균 추천수 = 추천수/회차총합  구해서 그래프 그리기.
mean_recom = list()

for (i in 1:length(webtoons$episodes)) {
  total=0
  for (j in 1:length(webtoons$episodes[[i]])) {
    total <- total + webtoons$episodes[[i]][[j]]$recom
  }
  mean_recom[i] <- total/length(webtoons$episodes[[i]]) 
}
mean_recom <- unlist(mean_recom) #작가별 평균추천수
mean_recom
#그래프
barplot(mean_recom,names.arg = webtoons$author,main = "작가별 평균추천수") 
plot(mean_recom,pch=16,main = "작가별 평균추천수")

ind3 <- which(page_length == max(page_length))
ind4 <- which(page_length == median(page_length))
ind4 <- ind4[1]
webtoons$author[ind3] #1등 
mean_recom[ind3]
webtoons$author[ind4] #중앙값
mean_recom[ind4]
plot(mean_recom,pch=16)
points(ind3,mean_recom[ind3], pch = 16,col="blue")
points(ind4,mean_recom[ind4], pch = 16,col="yellow")
legend(x=30,y=120,c(webtoons$author[ind3],webtoons$author[ind4]),col = c("red","yellow"),pch=c(16,16))


#두명의 추천수를 저장해놓고 그래프 그려본다.
first_length <- length(webtoons$episodes[[ind3]])  #회차수를 세려고
second_length <- length(webtoons$episodes[[ind4]])
x1<-list()
x2<-list()
for (i in 1:first_length) {
  x1[i]<- webtoons$episodes[[ind3]][[i]]$recom
}

for (i in 1:second_length) {
  x2[i] <- webtoons$episodes[[ind4]][[i]]$recom
}
x1<-unlist(x1)
x2<-unlist(x2)
x1
x2


shapiro.test(x1)
shapiro.test(x2) #x1과 x2가 정규분포를 따르는지 테스테해봤다. 두 테스트의 p-value값이 모두 0.05보다 작다. 따라서 유의수준 0.05에서 정규분포를 따른다고 할 수 없다.

#검정:  귀무가설: mux1=mux2  vs 대립가설: mux1 - mux2 <0


t1 <- t.test(x1, x2, var.equal = FALSE, conf.level = 0.95,alternative = "less") 
t1

#p-value가 0.05보다 작다. 따라서 유의수준 0.05에서 귀무가설을 기각한다. mux1과 mux2는 다르다
     # 따라서 x1의 작가가 회차가 많은 웹툰을 썻지만 평균추천수는 x2작가가 더 높다.
par(mfrow=c(1,1))
plot(x1[1:second_length],ylim = c(0,100),main = webtoons$author[ind3])
plot(x2,ylim = c(0,100),main = webtoons$author[ind4])
plot(x1,ylim = c(0,100),main = webtoons$author[ind3])
par(mfrow=c(1,1))
#첫번쨰와 두번쨰 그래프는 2번쨰 작가의 회차만큼만 데이터를 그렸다. 초반에는 20부작 정도까지는 추천수가 비슷하게 갔지만
#두번쨰 작가의 추천수는 20회 이후로 계속 증가추세다. 그러나 첫번쨰 작가는 40회까지 거의 변화가 없다.
#3번쨰 그래프는 첫번째 작가의 전체 추천수 그래프인데 경향을 보면 초반부에 추천수가 조금 높고 뒤로갈수록
#추천수가 밑에 분포한다. 따라서 회차가 길어서 그만큼 독자들의 관심도 하락하고 추천수도 짧은 웹툰보다 낮게 나온다고 볼 수 있다.





                                      

