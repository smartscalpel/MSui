# Module UI function
tissuesAddPatientUI <- function(id) {
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
tissuesAddPatient <- function(input, output, session, emsid, addPatient, session2) {
        
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
                        shiny::showModal(dataModal(FALSE, "Data was successfully added!"))
                }

        })
        
        dataModal <- function(failed, msg) {
                modalDialog(

                        if (failed)
                                div(tags$b(msg, style = "color: red;")),

                        if (! failed)
                                div(tags$b(msg, style = "color: green;")),

                        footer = tagList(
                                actionButton(session$ns("ok"), "OK")
                        )
                )
        }

        observeEvent(input$ok, {
                removeModal()
                
                print(session2$ns("tissueAddSearch"))
                
                click(id = "tissueAddSearch")
        })
}
