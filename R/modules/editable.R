editableUI <- function(id) {
  ns <- NS(id)
  cat('editableUI',id,'\n')
  cat('editableUI',class(ns("res")),'\n')
  tagList(
    actionButton(ns("create"), "Create entry", class = "pull-left btn-info"),
    actionButton(ns("save"), "Save table", class = "pull-right btn-info"),
    # tableOutput(ns("res"))
    rHandsontableOutput(ns("res"),width = 600)
    # rHandsontableOutput((rhandsontable(ns("res"), width = 600, height = 300,readOnly = TRUE) %>%
    #                        hot_cols(fixedColumnsLeft = 1) %>%
    #                        hot_rows(fixedRowsTop = 1)),width = 600)
  )
}

editable <- function(input, output, session, pool, tabName,makeEmptyRow,updateTable,colWidths = c(50,150,300)) {

  # observeEvent(tbls(), {
  #   updateSelectInput(session, "tableName", choices = tbls())
  # })
  #
  values <- reactiveValues()

  observe({
    req(tabName)
    req(tabName %in% db_list_tables(pool))
    # cols <- db_query_fields(pool, input$tableName)
    # updateCheckboxGroupInput(session, "select",
    #                          choices = cols, selected = cols, inline = TRUE)
  })

  observeEvent(input$create, {
    cat("observeEvent(input$create",dim(values$resDT),'\n')
    values$resDT<-rbind(makeEmptyRow(),values$resDT)
    cat("observeEvent(input$create",dim(values$resDT),'\n')
  })

  observeEvent(input$save, {
    #req(checkTable(values$resDF))
    con<-poolCheckout(pool)
    need(tryCatch(updateTable(con,tabName,values$resDT,values$newData)),"table update was unsuccessful")
    values$resDT<-as_data_frame(con %>% tbl(tabName))
    poolReturn(con)

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
    if(!is.null(input$res))
      values$newData <- hot_to_r(input$res)
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
    values$resDT<-as_data_frame(con %>% tbl(tabName))
    poolReturn(con)
    }
    cat('editable output$res',dim(values$resDT),'\n')
    cat('editable output$res',class(values$resDT),'\n')
    values$rhRes<-rhandsontable(values$resDT, width = 600, height = 300,readOnly = FALSE) %>%
      hot_cols(colWidths = colWidths) %>%
      hot_cols(fixedColumnsLeft = 1) %>%
      hot_rows(fixedRowsTop = 1)
    return(values$rhRes)

  })
}

