library(googlesheets4)
library(RMySQL)

etl_farm_transactions = function(spread_name,db_pw){
    xx = read_sheet(spread_name, sheet = "transactions")
    xx = data.frame(xx)
    xx[is.na(xx)] = 0
    send_q = paste0("insert into farm_db.staging_field_year_transaction (field_key ,
        year_key ,
        trans_type ,
        object_type,
        invoice_date,
        paid_date,
        vendor,
        expense_category,
        paid_amount,
        received_amount ) values ", paste0(apply(xx, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", "))
    
    con = dbConnect(RMySQL::MySQL(), host = "localhost",
                     user = "root", password = db_pw)
    
    dbSendQuery(con, send_q)
    
    
    xx = read_sheet(spread_name, sheet = "crop_mapping")
    xx = data.frame(xx)
    xx[is.na(xx)] = 0
    send_q = paste0("insert into farm_db.staging_field_year_crop (field_key ,
        year_key ,
        crop_key) values ", paste0(apply(xx, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", "))
    

    dbSendQuery(con, send_q)}


