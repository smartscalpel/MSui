# Module UI function
tissuesSndCreateTissueUI <- function(id, diagnosisDictionary) {
        ns <- NS(id)
        
        tagList(
                hr(),
                
                h4("Create a new tissue"),
                
                br(),
                
                div("We have found patient for you! Here it is:"),
                DT::dataTableOutput(outputId = ns("table")),
                br(),
                div(
                        "Now just fill the gaps below and press the Save Table button to store data in database.
                        Note, some of gpas are optional."
                ),
                br(),
                textInput(
                        inputId = ns("label"),
                        label = "Label (required)",
                        width = "50%"
                ),
                textInput(
                        inputId = ns("location"),
                        label = "Location",
                        width = "50%"
                ),
                tissuesSndDiagnosisSelectorUI(
                        ns("diagnosis"),
                        diagnosisDictionary = diagnosisDictionary$name
                ),
                tissuesSndGradeSelectorUI(ns("grade")),
                textInput(
                        inputId = ns("coords"),
                        label = "Coords",
                        width = "50%"
                ),
                tissuesSndTimeSelectorUI(ns("time")),
                br(),
                div(
                        align = "right",
                        actionButton(
                                inputId = ns("save"),
                                label = "Save",
                                icon = icon("save")
                )
                ),
                shiny::conditionalPanel(
                        "output.exists == false",
                        div("123")
                )
        )
}



# Module server function
tissuesSndCreateTissue <- function(input, output, session, dataModal, patient, checkLabelUniqueness, saveTissue, recieveDataFromSelectors) {
        
        diagnosisSelector <- shiny::callModule(
                module = tissuesSndDiagnosisSelector,
                id = "diagnosis"
        )
        
        gradeSelector <- shiny::callModule(
                module = tissuesSndGradeSelector,
                id = "grade"
        )
        
        timeSelector <- shiny::callModule(
                module = tissuesSndTimeSelector,
                id = "time"
        )
        
        output$table <- DT::renderDataTable(
                DT::datatable(
                        data = patient,
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
        
        
        
        
        shiny::observeEvent(input$save, {
                
                if (checkLabelUniqueness(labelValue = input$label)) {
                        
                        tissueData <- recieveDataFromSelectors(
                                input$label,
                                patient$id,
                                input$location,
                                diagnosisSelector,
                                gradeSelector,
                                input$coords,
                                timeSelector
                        )
                        
                        saveTissue(tissueData = tissueData)
                        showModal(
                                dataModal(
                                        modalID = session$ns("ok"),
                                        failed = FALSE,
                                        msg = "Data was successfully stored in database!"
                                )
                        )
                } else {
                        showModal(
                                dataModal(
                                        modalID = session$ns("ok"),
                                        failed = TRUE,
                                        msg = "Given label already exists in database. Please, try anouther one"
                                )
                        )
                }
                
        })
        
        observeEvent(input$ok, {
                removeModal()
        })
}
