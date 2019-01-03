# Module UI function
tissuesSndCreatePatientUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                hr(),
                h4("Create a new patient"),
                
                br(),
                
                div(
                        "If you don't have any information about patient,
                        we are going to add the following patient to a database:"
                ),
                
                br(),
                
                DT::dataTableOutput(outputId = ns("table")),
                
                br(),
                
                div(
                        align = "right",
                        actionButton(
                                inputId = ns("create"),
                                label = "Create",
                                icon = icon("save")
                        )
                )
        )
}



# Module server function
tissuesSndCreatePatient <- function(input, output, session, dataModal, emsid, addPatient) {
        
        df <- base::data.frame(NA, emsid, -1, NA, NA)
        x <- c("id", "emsid", "yob", "sex", "age")
        base::colnames(df) <- x

        output$table <- DT::renderDataTable(
                DT::datatable(
                        data = df,
                        rownames = FALSE,

                        extensions = list(
                                'Scroller' = NULL
                        ),

                        options = list(
                                scrollX = TRUE,
                                paging = FALSE,
                                dom = 'tip'
                        ),

                        selection = "none",
                        editable = FALSE
                )
        )

        
        
        shiny::observeEvent(input$create, {
                
                if (addPatient(emsid)) {
                        shiny::showModal(
                                dataModal(
                                        modalID = session$ns("ok"),
                                        failed = FALSE,
                                        msg = "Data was successfully added!"
                                )
                        )
                }

        })
        
        

        observeEvent(input$ok, {
                removeModal()
                
                click(id = "tissueSndSearch")
        })
}
