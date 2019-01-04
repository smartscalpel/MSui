source("./server/01-tissues-srv/tissuesCheckInput.R",     local = TRUE)
source("./server/01-tissues-srv/tissuesSaveUpdated.R",    local = TRUE)
source("./server/01-tissues-srv/tissuesLoadDataFromDB.R", local = TRUE)
source("./server/01-tissues-srv/tissuesCheckEditTable.R", local = TRUE)



tissueReactiveValues <- reactiveValues()
tissueReactiveValues$error         <- TRUE
tissueReactiveValues$editableTable <- FALSE

tissuesReactiveDataFromDB <- reactiveVal()
tissuesReactiveDataFromDB(NULL)

output$tissuesScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")



tissuesFridgeSelector    <- shiny::callModule(tissuesFridgeSelector,    "tissuesFridgeSelector")
tissuesSexSelector       <- shiny::callModule(tissuesSexSelector,       "tissuesSexSelector")
tissuesAgeSelector       <- shiny::callModule(tissuesAgeSelector,       "tissuesAgeSelector")
tissuesDiagnosisSelector <- shiny::callModule(tissuesDiagnosisSelector, "tissuesDiagnosisSelector")
tissuesTimeSelector      <- shiny::callModule(tissuesTimeSelector,      "tissuesTimeSelector")

shiny::callModule(
        editable,
        id = "tissuesEditable",
        dtTable = dtTable,
        reactiveDataFromDB = tissuesReactiveDataFromDB,
        hideColumns = c(0, 1),
        checkEditTable = tissuesCheckEditTable,
        saveUpdated = tissuesSaveUpdated(pool = pool),
        dataModal = dataModal
)

shiny::callModule(
        readOnly,
        dtTable = dtTable,
        id = "tissuesReadOnly",
        reactiveDataFromDB = tissuesReactiveDataFromDB,
        hideColumns = c(0, 1)
)





shiny::observeEvent(input$tissuesSelect, {
        
        tissuesCheckOutput <- tissuesCheckInput(
                diagnosisSelector = tissuesDiagnosisSelector,
                timeSelector = tissuesTimeSelector
        )
        
        if (tissuesCheckOutput[[1]]) {
                tissueReactiveValues$error <- FALSE
                
                # Load data from database
                tissuesReactiveDataFromDB(
                        tissuesLoadDataFromDB(
                                pool = pool,
                                fridgeSelector = tissuesFridgeSelector,
                                sexSelector = tissuesSexSelector,
                                ageSelector = tissuesAgeSelector,
                                diagnosisSelector = tissuesDiagnosisSelector,
                                timeSelector = tissuesTimeSelector
                        )
                )

                if (input$tissuesEditableSelector) {
                        tissueReactiveValues$editableTable <- TRUE
                }
                if (! input$tissuesEditableSelector) {
                        tissueReactiveValues$editableTable <- FALSE
                }
        } else {
                tissueReactiveValues$error <- TRUE

                output$tissuesScreensaver  <- generateHtmlScreenSaver(inputText = "Oops, something went wrong!")
                output$tissuesErrorMessage <- generateErrorMessage(errorText = tissuesCheckOutput[[2]])
        }
})



output$tissuesError <- reactive({
        return(tissueReactiveValues$error)
})
output$tissuesEditableTable <- reactive({
        return(tissueReactiveValues$editableTable)
})
outputOptions(output, "tissuesError",         suspendWhenHidden = FALSE)
outputOptions(output, "tissuesEditableTable", suspendWhenHidden = FALSE)
