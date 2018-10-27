source("./server/01-tissues-srv/tissuesCheckSelectorInput.R", local = TRUE)
source("./server/01-tissues-srv/tissuesDB.R",                 local = TRUE)
source("./server/01-tissues-srv/tissuesCheckEditTable.R",     local = TRUE)



# processing UI
tissuesFridgeSelector            <- shiny::callModule(fridgeSelector,            "tissuesFridgeSelector")
tissuesSexSelector               <- shiny::callModule(sexSelector,               "tissuesSexSelector")
tissuesAgeRangeSelector          <- shiny::callModule(ageRangeSelector,          "tissuesAgeRangeSelector")
tissuesDiagnosisMultipleSelector <- shiny::callModule(diagnosisMultipleSelector, "tissuesDiagnosisMultipleSelector")
tissuesTimeSelector              <- shiny::callModule(timeSelector,              "tissuesTimeSelector")



# These reactive values are needed to control ConditionalPanels in UI
tissuesValues <- reactiveValues()
tissuesValues$tissuesError  <- TRUE
tissuesValues$editableTable <- FALSE

output$tissuesError <- reactive({
        return(tissuesValues$tissuesError)
})
output$editableTable <- reactive({
        return(tissuesValues$editableTable)
})
outputOptions(output, "tissuesError",  suspendWhenHidden = FALSE)
outputOptions(output, "editableTable", suspendWhenHidden = FALSE)



# Screensaver, that is shown at the very beginning
output$tissuesScreensaver <- generateHtmlScreensaver(inputText = "Set up Filters and press Select!")



# Trying to Select table...
shiny::observeEvent(input$tissuesSelect, {
        
        tissuesCheckSelectorInputRes <- tissuesCheckSelectorInput(
                diagnosisMultipleSelector = tissuesDiagnosisMultipleSelector,
                timeSelector = tissuesTimeSelector
        )
        
        if (tissuesCheckSelectorInputRes[[1]]) {
                tissuesValues$tissuesError <- FALSE
                
                # Load data from database
                tissuesDataFromDB <- tissuesLoadDataFromDB(
                        pool = pool,
                        fridgeSelector = tissuesFridgeSelector,
                        sexSelector = tissuesSexSelector,
                        ageRangeSelector = tissuesAgeRangeSelector,
                        diagnosisMultipleSelector = tissuesDiagnosisMultipleSelector,
                        timeSelector = tissuesTimeSelector
                )

                if (input$tissuesEditableTableSelector) {
                        tissuesValues$editableTable <- TRUE
                        
                        # return editable table
                        shiny::callModule(
                                editable,
                                id = "tissuesEditable",
                                dataFromDB = tissuesDataFromDB,
                                checkEditTable = tissuesCheckEditTable(diagnosisDictionary = diagnosisDictionary)
                        )
                }
                if (! input$tissuesEditableTableSelector) {
                        tissuesValues$editableTable <- FALSE
                        
                        # return noneditable table
                        shiny::callModule(
                                readOnly,
                                id = "tissuesReadOnly",
                                dataFromDB = tissuesDataFromDB
                        )
                }
        } else {
                tissuesValues$tissuesError <- TRUE

                output$tissuesScreensaver  <- generateHtmlScreensaver(inputText = "Oops, something went wrong!")
                output$tissuesErrorMessage <- generateErrorMessage(errorText = tissuesCheckSelectorInputRes[[2]])
        }
})
