# We create separate modules for each editable table since it makes the code slightly readable and
# there are many specific stuff for each data table

# Module UI function
tissueEditableUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                div(
                        align = "center",
                        actionButton(ns("save"), "Save table", icon = icon("save"))
                ),
                br(),
                DT::dataTableOutput(outputId = ns("table"))
        )

}



# Module server function
tissueEditable <- function(input, output, session, dataFromDB, checkEditTable, modalUI) {
        proxy <- DT::dataTableProxy('table')
        
        # Store ids of updates rows
        updatedRows <- c()
        
        output$table <- renderDT(
                dtTable(dataFromDB = dataFromDB, editable = TRUE)
        )
        
        observeEvent(input$table_cell_edit, {
                print(updatedRows)
                info = input$table_cell_edit
                # str(info)
                i = info$row
                j = info$col + 1
                v = info$value
                
                checkResult <- checkEditTable(dataFromDB = dataFromDB, j = j, newValue = v)
                
                if (checkResult[[1]]) {
                        dataFromDB[i, j] <<- DT::coerceValue(v, dataFromDB[i, j])
                        replaceData(proxy, dataFromDB, resetPaging = FALSE, rownames = FALSE)
                        updatedRows <- c(updatedRows, dataFromDB[i, 1])
                        print(updatedRows)
                } else {
                        showModal(
                                modalDialog(
                                        div(
                                                tags$b(
                                                        paste(
                                                                "Error! Invalid input:",
                                                                checkResult[[2]]
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
