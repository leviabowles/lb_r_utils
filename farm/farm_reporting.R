library(RMySQL)
library(ggplot2)
library(gmailr)
library(reshape)
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


annual_financials = function(db_pw){
  con = dbConnect(RMySQL::MySQL(), host = "localhost",
                  user = "root", password = db_pw)
  
  nn = dbSendQuery(con, "select * from farm_db.yearly_agg_financials")
  nn = dbFetch(nn)
  #dbClearResult(nn)
  print(head(nn))
  nn$ebitda = nn$revenue-nn$costs
  nn$profit = nn$revenue-nn$costs-nn$interest_payment
  nn$cash_flow = nn$revenue - nn$costs -nn$interest_payment-nn$principal_payment
  
  
  nn = nn[,c("field_key", "year_key","costs","revenue","ebitda","profit","cash_flow")]
  print(nn)
  molten = reshape::melt(nn, id = c("field_key","year_key"))
  print(molten)
  print(ggplot(molten,aes(fill = variable,x = factor(year_key), y = value, label = value))+
          geom_bar(
            position="dodge", stat="identity")+
          facet_wrap(~field_key)+
          geom_text(size = 3, position = position_dodge(.9))+
          scale_y_continuous("Finance Metric")+
          scale_x_discrete("Crop Year"))}







