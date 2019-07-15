xx = dir()
unlist(strsplit(xx, '[.]'))

derp = NULL
for(i in xx){
  der = read.csv(i,encoding = "UTF-8")
  derp = rbind(der,derp)
  
}
jj = derp[derp$status == 'blocked',]
nrow(jj)
jj = subset(jj , !(jj$user_id %in% unlist(strsplit(xx, '[.]'))))
nrow(jj)
as.character(unique(jj$user_id))




library(wordcloud)
library(syuzhet)
syuzhet::getnrcsentiment()

par(bg = "black")

library(tm)
jj$description = as.character(jj$description)
jj$description = tolower(jj$description)
jj$description = gsub("[^[:alnum:] ]", "", jj$description)

#into corpus tranform 

corp = Corpus(tm::VectorSource(jj$description))

#mappings
corp = tm_map(corp, content_transformer(tolower))
corp = tm_map(corp, removeNumbers)
corp = tm_map(corp, removePunctuation)
corp = tm_map(corp, removeWords, stopwords("english"))
corp = tm_map(corp, removeWords, c())



#stem words into roots
corp <- tm_map(corp, stemDocument, "english")
corp <- tm_map(corp, removeWords, c("data"))
corp <- tm_map(corp, stripWhitespace)
par(bg = "black")
wordcloud(corp,scale=c(5,0.5), max.words=400, ,min.freq=1,random.order=FALSE, 
          rot.per=0.35, colors=brewer.pal(8, "Dark2"))

library(syuzhet)
syuzhet::get_nrc_sentiment(as.character(jj$description))
