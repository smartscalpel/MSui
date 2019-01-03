source("./server/01-tissues-srv/tissuesCheckInput.R",     local = TRUE)
source("./server/01-tissues-srv/tissuesSaveUpdated.R",    local = TRUE)
source("./server/01-tissues-srv/tissuesLoadDataFromDB.R", local = TRUE)
source("./server/01-tissues-srv/tissuesCheckEditTable.R", local = TRUE)



tissuesFridgeSelector    <- shiny::callModule(tissuesFridgeSelector,    "tissuesFridgeSelector")
tissuesSexSelector       <- shiny::callModule(tissuesSexSelector,       "tissuesSexSelector")
tissuesAgeSelector       <- shiny::callModule(tissuesAgeSelector,       "tissuesAgeSelector")
tissuesDiagnosisSelector <- shiny::callModule(tissuesDiagnosisSelector, "tissuesDiagnosisSelector")
tissuesTimeSelector      <- shiny::callModule(tissuesTimeSelector,      "tissuesTimeSelector")


tissueValues <- reactiveValues()
tissueValues$tissuesError         <- TRUE
tissueValues$tissuesEditableTable <- FALSE

output$tissuesScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")

shiny::observeEvent(input$tissuesSelect, {
        
        tissuesCheckOutput <- tissuesCheckInput(
                diagnosisSelector = tissuesDiagnosisSelector,
                timeSelector = tissuesTimeSelector
        )
        
        if (tissuesCheckOutput[[1]]) {
                tissueValues$tissuesError <- FALSE
                
                # Load data from database
                tissuesDataFromDB <- tissuesLoadDataFromDB(
                        pool,
                        fridgeSelector = tissuesFridgeSelector,
                        sexSelector = tissuesSexSelector,
                        ageSelector = tissuesAgeSelector,
                        diagnosisSelector = tissuesDiagnosisSelector,
                        timeSelector = tissuesTimeSelector
                )

                if (input$tissuesEditableSelector) {
                        tissueValues$tissuesEditableTable <- TRUE
                        # return editable table
                        shiny::callModule(
                                editable,
                                id = "tissuesEditable",
                                dtTable = dtTable,
                                dataFromDB = tissuesDataFromDB,
                                hideColumns = c(0, 1),
                                checkEditTable = tissuesCheckEditTable,
                                saveUpdated = tissuesSaveUpdated(pool = pool),
                                dataModal = dataModal
                        )
                }
                if (! input$tissuesEditableSelector) {
                        tissueValues$tissuesEditableTable <- FALSE
                        # return noneditable table
                        shiny::callModule(
                                readOnly,
                                dtTable = dtTable,
                                id = "tissuesReadOnly",
                                dataFromDB = tissuesDataFromDB,
                                hideColumns = c(0, 1)
                        )
                }
        } else {
                tissueValues$tissuesError <- TRUE

                output$tissuesScreensaver  <- generateHtmlScreenSaver(inputText = "Oops, something went wrong!")
                output$tissuesErrorMessage <- generateErrorMessage(errorText = tissuesCheckOutput[[2]])
        }
})

output$tissuesError <- reactive({
        return(tissueValues$tissuesError)
})
output$tissuesEditableTable <- reactive({
        return(tissueValues$tissuesEditableTable)
})
outputOptions(output, "tissuesError",         suspendWhenHidden = FALSE)
outputOptions(output, "tissuesEditableTable", suspendWhenHidden = FALSE)
