readOnlyUI <- function(id,
                       width=800,height=600) {
  ns <- NS(id)
  cat('readOnlyUI',id,'\n')
  cat('readOnlyUI',class(ns("res")),'\n')
  tagList(
    # tableOutput(ns("res"))
    rHandsontableOutput(ns("res"),width = width,height=height)
    # rHandsontableOutput((rhandsontable(ns("res"), width = 600, height = 300,readOnly = TRUE) %>%
    #                        hot_cols(fixedColumnsLeft = 1) %>%
    #                        hot_rows(fixedRowsTop = 1)),width = 600)
  )
}

readOnly <- function(input, output, session, pool, tabName,
                     colWidths = c(50,150,300),width=800,height=600) {

  # observeEvent(tbls(), {
  #   updateSelectInput(session, "tableName", choices = tbls())
  # })
  #
  
  autoInvalidate <- reactiveTimer(20000)
  
  observe({
    req(tabName)
    req(tabName %in% db_list_tables(pool))
    # cols <- db_query_fields(pool, input$tableName)
    # updateCheckboxGroupInput(session, "select",
    #                          choices = cols, selected = cols, inline = TRUE)
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
    cat('output$res: tblExsists',tabName,(tabName %in% db_list_tables(pool)),'\n')
    autoInvalidate()
    # filterVar <- sym(input$filter)
    # vals <- input$vals

    res<-as_data_frame(pool %>% tbl(tabName))
    cat('output$res',dim(res),'\n')
    cat('output$res',class(res),'\n')
    rhRes<-rhandsontable(res, width = width, height = height,search=TRUE,readOnly = TRUE) %>%
      hot_cols(colWidths = colWidths) %>%
      hot_cols(fixedColumnsLeft = 1) %>%
      hot_rows(fixedRowsTop = 1)%>%
      hot_cols(columnSorting = TRUE)
    return(rhRes)

  })
}

