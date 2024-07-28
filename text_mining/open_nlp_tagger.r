library(NLP)
library(openNLP)
## Some text.
## FUNCTION TO RETURN A POS TABLE
pos_table = function(x){
  s = as.String(x)
  #create annotators
  sent_token_annotator = Maxent_Sent_Token_Annotator()
  word_token_annotator = Maxent_Word_Token_Annotator()
  
  #first level annottation
  a2 = annotate(s, list(sent_token_annotator, word_token_annotator))
  
  #POS ANNOTATION
  pos_tag_annotator = Maxent_POS_Tag_Annotator()
  a3 =annotate(s, pos_tag_annotator, a2)
  
  ##we just want words
  a3w = subset(a3, type == "word")
  #and the tags, in a vector
  tags = sapply(a3w$features, `[[`, "POS")
  #put it in a data frame
  return(data.frame(word = s[a3w],features =  tags))
}
