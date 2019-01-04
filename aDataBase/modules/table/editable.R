# We create separate modules for each editable table since it makes the code slightly readable and
# there are many specific stuff for each data table

# Module UI function
editableUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                div(
                        align = "center",
                        actionButton(ns('save'), "Save table", icon = icon("save"))
                ),
                br(),
                DT::dataTableOutput(outputId = ns('table'))
        )

}



# Module server function
editable <- function(input, output, session,
                     dtTable,
                     reactiveDataFromDB,
                     hideColumns,
                     checkEditTable,
                     saveUpdated,
                     dataModal) {
        
        proxy <- DT::dataTableProxy('table')
        
        # Store ids of updates rows
        updated <- reactiveValues()
        updated$id <- c()
        
        observeEvent(reactiveDataFromDB(), {
                dataFromDB <- reactiveDataFromDB()
                
                output$table <- renderDT(
                        dtTable(
                                dataFromDB = dataFromDB,
                                editable = TRUE,
                                hideColumns = hideColumns,
                                height = "63vh"
                        )
                )
                
                observeEvent(input$table_cell_edit, {
                        info = input$table_cell_edit
                        str(info)
                        i = info$row
                        j = info$col + 1
                        v = info$value
                        
                        checkResult <- checkEditTable(dataFromDB = dataFromDB, j = j, newValue = v)
                        
                        if (checkResult[[1]]) {
                                dataFromDB[i, j] <<- DT::coerceValue(v, dataFromDB[i, j])
                                # dataFromDB[i, j] <- DT::coerceValue(v, dataFromDB[i, j])
                                replaceData(proxy, dataFromDB, resetPaging = FALSE, rownames = FALSE)
                                updated$id <- c(updated$id, dataFromDB[i, 1])
                        } else {
                                DT::reloadData(proxy, dataFromDB, resetPaging = FALSE)
                                showModal(
                                        dataModal(
                                                modalID = session$ns("ok"),
                                                failed = TRUE,
                                                msg = paste(
                                                        "Error! Invalid input:",
                                                        checkResult[[2]]
                                                )
                                        )
                                )
                        }
                })
                
                observeEvent(input$save, {
                        if (is.null(updated$id)) {
                                showModal(
                                        dataModal(
                                                modalID = session$ns("ok"),
                                                failed = FALSE,
                                                msg = "Nothing to save!"
                                        )
                                )
                        } else {
                                updatedPart <- dataFromDB[dataFromDB$id %in% updated$id, ]
                                if (! saveUpdated(updatedPart = updatedPart)){
                                        showModal(
                                                dataModal(
                                                        modalID = session$ns("ok"),
                                                        failed = FALSE,
                                                        msg = "Something went wrong!"
                                                )
                                        )
                                } else {
                                        showModal(
                                                dataModal(
                                                        modalID = session$ns("ok"),
                                                        failed = FALSE,
                                                        msg = "Success!"
                                                )
                                        )
                                }
                        }
                })
                
                observeEvent(input$ok, {
                        removeModal()
                })
                
        })
        
        return(reactive(input$table_cell_clicked))
}
