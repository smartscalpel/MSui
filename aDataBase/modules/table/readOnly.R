# Module UI function
readOnlyUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                DT::dataTableOutput(outputId = ns("table"))
        )
}



# Module server function
readOnly <- function(input, output, session, dtTable, dataFromDB, hideColumns) {
        
        output$table <- DT::renderDataTable(
                dtTable(
                        dataFromDB = dataFromDB,
                        editable = FALSE,
                        hideColumns = hideColumns,
                        height = "68vh"
                )
        )
        
}
