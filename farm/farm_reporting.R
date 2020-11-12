library(RMySQL)
library(ggplot2)
library(gmailr)
report_cost = function(db_pw){
  con = dbConnect(RMySQL::MySQL(), host = "localhost",
                  user = "root", password = db_pw)
  
  nn = dbSendQuery(con, "select * from farm_db.yearly_financials")
  nn = dbFetch(nn)
  #dbClearResult(nn)
  
  
  
  print(ggplot(subset(nn,trans_type =='debit'),aes(fill = object_type,x = factor(year_key), y = paid_amount, label = paid_amount))+
    geom_bar(
      position="stack", stat="identity")+
    facet_wrap(~field_key)+
    geom_text(size = 3, position = position_stack(vjust = 0.5))+
    scale_y_continuous("Amount Paid")+
    scale_x_discrete("Crop Year"))}


