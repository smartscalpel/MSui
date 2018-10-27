# Module UI function
editableUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                div(
                        align = "center",
                        actionButton(
                                inputId = ns("save"),
                                label = "Save table",
                                icon = icon("save")
                        )
                ),
                br(),
                DT::dataTableOutput(outputId = ns("table"))
        )

}



# Module server function
editable <- function(input, output, session, dataFromDB, checkEditTable) {
        proxy <- DT::dataTableProxy('table')
        
        output$table <- renderDT(
                dtTable(dataFromDB = dataFromDB, editable = TRUE)
        )
        
        observeEvent(input$table_cell_edit, {
                info = input$table_cell_edit
                # str(info)
                i = info$row
                j = info$col + 1
                v = info$value
                
                checkEditTableResult <- checkEditTable(
                        dataFromDB = dataFromDB,
                        j = j,
                        newValue = v
                )
                
                if (checkEditTableResult[[1]]) {
                        dataFromDB[i, j] <<- DT::coerceValue(v, dataFromDB[i, j])
                        replaceData(proxy, dataFromDB, resetPaging = FALSE, rownames = FALSE)
                } else {
                        showModal(
                                modalDialog(
                                        div(
                                                tags$b(
                                                        paste(
                                                                "Error! Invalid input:",
                                                                checkEditTableResult[[2]]
                                                        ),
                                                        style = "color: red;"
                                                )
                                        ),
                                        
                                        footer = tagList(
                                                modalButton("Ok")
                                        )
                                )
                        )
                        DT::reloadData(proxy, dataFromDB, resetPaging = FALSE)
                }
        })
}
