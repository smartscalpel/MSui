editableUI <- function(id,
                       width=800,height=600) {
  ns <- NS(id)
  cat('editableUI',id,'\n')
  cat('editableUI',class(ns("res")),'\n')
  tagList(
    actionButton(ns("create"), "Create entry", class = "pull-left btn-info"),
    actionButton(ns("save"), "Save table", class = "pull-right btn-info"),
    # tableOutput(ns("res"))
    rHandsontableOutput(ns("res"),width = width, height = height)
    # rHandsontableOutput((rhandsontable(ns("res"), width = 600, height = 300,readOnly = TRUE) %>%
    #                        hot_cols(fixedColumnsLeft = 1) %>%
    #                        hot_rows(fixedRowsTop = 1)),width = 600)
  )
}

getTableDef<-function(con,tabName){
  as_data_frame(con %>% tbl(tabName))
}
editable <- function(input, output, session, pool, tabName,makeEmptyRow,
                     updateTable,getTable=getTableDef,
                     colWidths = c(50,150,300),
                     width=800,height=600) {
  
  # observeEvent(tbls(), {
  #   updateSelectInput(session, "tableName", choices = tbls())
  # })
  #
  values <- reactiveValues()
  
  observe({
    req(tabName)
    #    req(tabName %in% db_list_tables(pool))
    # cols <- db_query_fields(pool, input$tableName)
    # updateCheckboxGroupInput(session, "select",
    #                          choices = cols, selected = cols, inline = TRUE)
  })
  
  observeEvent(input$create, {
    cat("observeEvent(input$create",dim(values$resDT),'\n')
    if(is.null(values$saved)) values$saved=FALSE
    if(!values$saved){
      values$oldData<-values$resDT
    }
    values$resDT<-rbind(makeEmptyRow(),values$resDT)
    cat("observeEvent(input$create",dim(values$resDT),'\n')
    values$saved=FALSE
  })
  
  observeEvent(input$save, {
    #req(checkTable(values$resDF))
    con<-poolCheckout(pool)
    need(tryCatch(updateTable(con,tabName,values$oldData,values$newData)),"table update was unsuccessful")
    values$resDT<-getTable(con,tabName)
    values$oldData<-values$resDT
    poolReturn(con)
    values$saved=TRUE
  })
  
  dt<-reactive({
    values$resDT
  })
  # observe({
  #   reqTable(input$tableName)
  #   req(input$select)
  #   updateSelectInput(session, "filter", choices = input$select)
  # })
  observe({
    if(!is.null(input$res)){
      values$newData <- hot_to_r(input$res)
      values$saved=FALSE
    }
  })
  
  # observe({
  #   reqTable(input$tableName)
  #   req(input$select)
  #   updateSelectInput(session, "filter", choices = input$select)
  # })
  #
  # observe({
  #   reqColInTable(input$tableName, input$filter)
  #   df <- as_data_frame(pool %>% tbl(tabName))
  #   allUniqueVals <- unique(df[[input$filter]])
  #   updateCheckboxGroupInput(session, "vals",
  #                            choices = allUniqueVals, selected = allUniqueVals, inline = TRUE)
  # })
  
  output$res <- renderRHandsontable({
    #   reqColInTable(input$tableName, input$filter)
    if(is.null(values$resDT)){
      con<-poolCheckout(pool)
      cat('output$res: tblExsists',tabName,(tabName %in% db_list_tables(con)),'\n')
      
      # filterVar <- sym(input$filter)
      # vals <- input$vals
      values$resDT<-getTable(con,tabName)
      values$oldData<-values$resDT
      values$saved=TRUE
      poolReturn(con)
    }
    cat('editable output$res',dim(values$resDT),'\n')
    cat('editable output$res',class(values$resDT),'\n')
    values$rhRes<-rhandsontable(values$resDT, width = width, height = height,readOnly = FALSE) %>%
      hot_col("id", readOnly = TRUE)%>%
      hot_col(1:dim(values$resDT)[2], strict=FALSE,allowInvalid=TRUE) %>%
      hot_cols(colWidths = colWidths) %>%
      hot_cols(fixedColumnsLeft = 1) %>%
      hot_rows(fixedRowsTop = 1)%>%
      hot_cols(columnSorting = TRUE)
    return(values$rhRes)
    
  })
}

