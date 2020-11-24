library(rhandsontable)
library(shiny)
source("farm_reporting.R")
editTable = function(db_pw, outdir=getwd(), outfilename="table"){
  
  
  
  grab_data = function(db_pw){
    con = dbConnect(RMySQL::MySQL(), host = "localhost",
                    user = "root", password = db_pw)
    
    DFX = dbGetQuery(con, "select * from farm_db.field_year_transaction")
    DFX$invoice_date = as.Date(DFX$invoice_date)
    DFX$paid_date = as.Date(DFX$paid_date)
    dbDisconnect(con)
    return(DFX)}
  
  grab_lookups = function(db_pw){
    con = dbConnect(RMySQL::MySQL(), host = "localhost",
                    user = "root", password = db_pw)
    
    fk = dbGetQuery(con, "SELECT field_key FROM farm_db.field;")
    yk = dbGetQuery(con, "SELECT year_key FROM farm_db.farm_year;")
    otk = dbGetQuery(con, "SELECT object_type FROM farm_db.staging_legit_transaction_objects;")
    li = list()
    print(fk)
    print(yk)
    print(otk)
    li[["fk"]] = fk$field_key
    li[["yk"]] = yk$year_keuy
    li[["otk"]] = otk$object_type
    
    print(li[["fk"]])
    print(li[['yk']])
    print(li[["otk"]])
    dbDisconnect(con)
    return(li)}

  
  insert_data = function(xx,db_pw){
    xx[is.na(xx)] = 0
    xx = xx[,c("field_key","year_key" ,"trans_type" ,"object_type","invoice_date","paid_date","vendor","expense_category","paid_amount","received_amount")]
    send_q = paste0("insert into farm_db.field_year_transaction (field_key ,
        year_key ,
        trans_type ,
        object_type,
        invoice_date,
        paid_date,
        vendor,
        expense_category,
        paid_amount,
        received_amount ) values ", paste0(apply(xx, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", "))
  print(send_q)
  con = dbConnect(RMySQL::MySQL(), host = "localhost",
                  user = "root", password = db_pw)
  
  nn = dbSendQuery(con, send_q)
  dbDisconnect(con)}
  
  
  delete_data = function(ids,db_pw){
    send_q = paste0("delete from farm_db.field_year_transaction where id = ", ids)
    print(send_q)
    con = dbConnect(RMySQL::MySQL(), host = "localhost",
                    user = "root", password = db_pw)
    
    nn = dbSendQuery(con, send_q)
    dbDisconnect(con)}
  
  
  
  ui = shinyUI(fluidPage(
    theme = shinytheme("slate"),
    
    titlePanel("Farm-DB Transaction Detail"),
    tabsetPanel(
      tabPanel("Transaction Entry", fluid = TRUE,
          sidebarLayout(
            sidebarPanel(
              helpText("This is our initial data entry form for Farm-DB.", 
                       "Right-click on the table to delete/insert rows.", 
                       "Double-click on a cell to edit."),
              
              br(), 
              
              wellPanel(
                h3("Save Changes"), 
                div(class='row', 
                    div(class="col-sm-6", 
                        actionButton("save", "Save"))
                )
              )
              
            , width = 2),
            
            mainPanel(
              wellPanel(
                uiOutput("message", inline=TRUE)
              ),
              
              br(), br(), 
              
              rHandsontableOutput("hot"),
              br()
            )
          )
        
      ),
      tabPanel("Annual Cost Breakdown", fluid = TRUE,
               mainPanel(plotOutput(outputId = "annual_plot", height = "600px"))
               )
      
      ,
      tabPanel("Yearly Financials By Field", fluid = TRUE,
               mainPanel(plotOutput(outputId = "yearly_finance_field", height = "600px"))
      ),
               
      tabPanel("Cumulative Cash Flow By Field", fluid = TRUE,
                mainPanel(plotOutput(outputId = "yearly_cashflow_field", height = "600px"))
               
      ),
               
     tabPanel("Yearly Financials in Total", fluid = TRUE,
              mainPanel(plotOutput(outputId = "yearly_finance", height = "600px"))
              
     ),
     
     tabPanel("Cumulative Cash Flow in Total", fluid = TRUE,
              mainPanel(plotOutput(outputId = "yearly_cashflow", height = "600px"))
               
      )
    )
  )
)
  
  server <- shinyServer(function(input, output) {
    
    values <- reactiveValues()
    DFX = grab_data(db_pw)
    DF = data.frame(DFX)
    li = grab_lookups(db_pw)
    ## Handsontable
    observe({
      if (!is.null(input$hot)) {
        values[["previous"]] <- isolate(values[["DF"]])
        DF = hot_to_r(input$hot)
      } else {
        if (is.null(values[["DF"]]))
          DF = DF
        else
          DF = values[["DF"]]
      }
      values[["DF"]] = DF
    })
    
    output$hot <- renderRHandsontable({
      DFX = grab_data(db_pw)
      DF = data.frame(DFX)
      DF = values[["DF"]]
      if (!is.null(DF))
        rhandsontable(DF, useTypes = TRUE, stretchH = "all")%>%
          hot_col(col = "field_key", type = "dropdown", source = li[['fk']]) %>%
          hot_col(col = "trans_type", type = "dropdown", source = c("credit","debit"))%>%
          hot_col(col = "year_key", type = "dropdown", source = li[["yk"]]) %>%
          hot_col(col = "object_type", type = "dropdown", source = li[['otk']])%>%
          hot_col("id", readOnly = TRUE) 
    })
    
    

    observeEvent(input$save, {
      fileType = isolate(input$fileType)
      finalDF = isolate(values[["DF"]])
      new_values = setdiff(finalDF$id,DFX$id)
      values_to_delete = setdiff(DFX$id, finalDF$id)
      print(new_values)
      print(values_to_delete)
      
      if(length(new_values)>0){for(i in new_values){
        xx = finalDF[finalDF$id ==i,]
        insert_data(xx,db_pw)} 
        DFX = grab_data(db_pw)
        DF = data.frame(DFX)
        values[["DF"]] = DF
        print(values[["DF"]])

      }
      
      if(length(values_to_delete)>0){for(i in values_to_delete){
        delete_data(i,db_pw)} 
        DFX = grab_data(db_pw)
        DF = data.frame(DFX)
        values[["DF"]] = DF
        

      }
      
      
    }
    )
    
    
    ## Message
    output$message <- renderUI({
      if(input$save==0){
        helpText(sprintf("Please use dropdown menus to add records.  
                         If an item needs to be added to the tables please consult management.", outdir))
      }else{
        outfile <- ifelse(isolate(input$fileType)=="ASCII", "table.txt", "table.rds")
        fun <- ifelse(isolate(input$fileType)=="ASCII", "dget", "readRDS")
        list(helpText(sprintf("File saved: \"%s\".", file.path(outdir, outfile))),
             helpText(sprintf("Type %s(\"%s\") to get it.", fun, outfile)))
      }
    })
    
    output$annual_plot = renderPlot({
      report_cost(db_pw)})
    
    output$yearly_finance_field = renderPlot({
      annual_financials(db_pw,1)})
    
    output$yearly_cashflow_field = renderPlot({
      annual_financials(db_pw,2)})
    
    output$yearly_finance = renderPlot({
      annual_financials_agg(db_pw,1)})
    
    output$yearly_cashflow = renderPlot({
      annual_financials_agg(db_pw,2)})
    
  })
  
  ## run app 
  runApp(list(ui=ui, server=server))
  return(invisible())
}
