
# Reference web page
#https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/
  
#install.packages("rvest")
library(rvest)
#selectorgadget 크롬에 추가하기

# read_html (web page url)
# html_nodes(web_page, "css selector location") 불러온 웹페이지를 집어넣고  css
# html_text ( html to text) 불러온 html을 text로 변환하는거


# gsub

# selectorGadget chrome

#install.packages("rvest")
#library(rvest)

# IMDB Example
#Specifying the url for desired website to be scrapped
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

#Reading the HTML code from the website
webpage <- read_html(url)
webpage

#Using CSS selectors to scrap the rankings section
rank_data_html <- html_nodes(webpage,'.text-primary')

#Converting the ranking data to text
rank_data <- html_text(rank_data_html)

#Let's have a look at the rankings
head(rank_data)

rank = gsub("[.]","",rank_data)
rank
as.numeric(rank_data)

#Using CSS selectors to scrap the title section 크롬에 selector이용해서 가지고 오고 싶은거 가져오기.
title_data_html <- html_nodes(webpage,'.lister-item-header a')
title_data_html
title_data_html2 <- html_nodes(webpage,'.ratings-imdb-rating strong') #별점 가져오기.
title_data_html2

#Converting the title data to text  가져온거 text로 바꾸는거.
title_data <- html_text(title_data_html)
title_data
title_data2 <- html_text(title_data_html2)
title_data2

data.frame(title_data,title_data2) #영화제목과 별점 묶은 데이터프레임.
#Let's have a look at the title
head(title_data)

data.frame(rank=as.numeric(rank_data),title=title_data)

# https://movie.naver.com/movie/bi/mi/basic.nhn?code=72363
url = "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=72363&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page" #page에 번호만 바꾸면 페이지 바꾸면서 별점 가져올 수 있어서

url_trim = substr(url,1,nchar(url)-4)
url_trim
page_indx = 1:1765

rating = numeric()
u_name = character()
for(i in 1:10)
{
  w_temp = read_html(paste0(url_trim,page_indx[i]))
  r_temp = html_nodes(w_temp, ".score_result .star_score em")
  rating = c(rating, as.numeric(html_text(r_temp)))
  u_temp = html_nodes(w_temp,".score_reple span")
  u_txt = html_text(u_temp)
  u_txt = u_txt[u_txt!="BEST"]
  u_name = c(u_name,u_txt)
}

data.frame(rating,u_name)
#전처리 과정.
u_name
temp = gsub(")","",u_name)    
temp
temp_list = strsplit(temp,"[(]")
temp_list
res = sapply(temp_list,function(x) x[length(x)])
head(res)
