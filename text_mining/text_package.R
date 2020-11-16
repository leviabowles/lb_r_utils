library(httr)
library(tm)
library(RTextTools)
library(topicmodels)
library(wordcloud)
library(ggplot2)



text_to_clean_corp = function(x){
  #create corpus
  corp  = Corpus(VectorSource(x))
  
  
  #clean corpus
  corp =  tm_map(corp, content_transformer(tolower))
  corp = tm_map(corp, removeNumbers)
  corp = tm_map(corp, removePunctuation)
  corp = tm_map(corp, removeWords, stopwords("english"))
  corp = tm_map(corp, removeWords, c("amp","love","will", "just","day","one","get"))
  corp = tm_map(corp, removeWords, "http\\w+")
  #get rid of common "me" words (facepalm)
  #stem words into roots
  corp = tm_map(corp, stemDocument, "english")
  corp = tm_map(corp, removeWords, c("amp","love","will", "just","day","one","get"))
  corp = tm_map(corp, stripWhitespace)
  return(corp)}

corp_to_densify_matx = function(x){
  matx = DocumentTermMatrix(corp)
  matx = removeSparseTerms(matx,.9995)
  rowTotals = apply(matx , 1, sum)
  matx.new  = matx[rowTotals> 3, ]
  return(matx.new)
}


ctm_to_original = function(orig_df, build_matx, ctm){
  print(terms(ctm,20))
  topics = data.frame(posterior(ctm)$topics)
  row.names(topics) = build_matx$dimnames$Docs

  
  print(summary(topics))
  topics$topic = apply(topics,1,which.max)
  print(ggplot(topics,aes(x=topic))+
    geom_histogram())
  
  print(summary(topics$topic))
  nn = merge(orig_df,topics,by="row.names")
  print(ncol(nn))
  print(ncol(orig_df))
  return(nn)}


per_topic_word_cloud = function(merged_df,ctm){
  par(bg="black")
  for(j in c(1:ctm@k)){
    dd = subset(merged_df,topic ==j)
    dd = text_to_clean_corp(dd$text)
    print(wordcloud(dd, scale=c(5,0.5), max.words=100, random.order=FALSE, 
                    rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2")))
    
    
  }

}




