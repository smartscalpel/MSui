# Module UI function
readOnlyUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                DT::dataTableOutput(outputId = ns("table"))
        )
}



# Module server function
readOnly <- function(input, output, session, dataFromDB) {
        
        output$table <- DT::renderDataTable(
                dtTable(dataFromDB = dataFromDB, editable = FALSE)
        )
        
}
