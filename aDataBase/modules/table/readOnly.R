# Module UI function
readOnlyUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                DT::dataTableOutput(outputId = ns("table"))
        )
}



# Module server function
readOnly <- function(input, output, session, dtTable, reactiveDataFromDB, hideColumns, trigger) {
        
        dataFromDB <- NULL
        
        observeEvent(trigger(), {
                dataFromDB <<- shiny::isolate(reactiveDataFromDB())
                
                output$table <- DT::renderDataTable(
                        dtTable(
                                dataFromDB = dataFromDB,
                                editable = FALSE,
                                hideColumns = hideColumns,
                                height = "68vh"
                        )
                )
        })
        
        return(reactive(input$table_cell_clicked))
}
