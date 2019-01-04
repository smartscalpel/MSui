# Module UI function
readOnlyUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                DT::dataTableOutput(outputId = ns("table"))
        )
}



# Module server function
readOnly <- function(input, output, session, dtTable, reactiveDataFromDB, hideColumns) {
        
        observeEvent(reactiveDataFromDB(), {
                dataFromDB <- reactiveDataFromDB()
                
                output$table <- DT::renderDataTable(
                        dtTable(
                                dataFromDB = dataFromDB,
                                editable = FALSE,
                                hideColumns = hideColumns,
                                height = "68vh"
                        )
                )
                
                observeEvent(input$table_cell_clicked, {
                        return(reactive({input$data_cell_clicked}))
                })
        })
}
