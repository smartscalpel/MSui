source("./server/01-tissues-srv/tissuesCheckInput.R",     local = TRUE)
source("./server/01-tissues-srv/tissuesDB.R",             local = TRUE)
source("./server/01-tissues-srv/tissuesCheckEditTable.R", local = TRUE)



# processing UI
# tissuesIdSelector              <- shiny::callModule(idSelector,                "tissuesIdSelector")
tissuesFridgeSelector            <- shiny::callModule(fridgeSelector,            "tissuesFridgeSelector")
tissuesSexSelector               <- shiny::callModule(sexSelector,               "tissuesSexSelector")
tissuesAgeRangeSelector          <- shiny::callModule(ageRangeSelector,          "tissuesAgeRangeSelector")
tissuesDiagnosisMultipleSelector <- shiny::callModule(diagnosisMultipleSelector, "tissuesDiagnosisMultipleSelector")
tissuesTimeSelector              <- shiny::callModule(timeSelector,              "tissuesTimeSelector")


tissueValues <- reactiveValues()
tissueValues$tissuesError  <- TRUE
tissueValues$editableTable <- FALSE

output$tissuesScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")

shiny::observeEvent(input$tissuesSelect, {
        
        tissuesCheckOutput <- tissuesCheckInput(
                diagnosisMultipleSelector = tissuesDiagnosisMultipleSelector,
                timeSelector = tissuesTimeSelector
        )
        
        if (tissuesCheckOutput[[1]]) {
                tissueValues$tissuesError <- FALSE
                
                # Load data from database
                tissuesDataFromDB <- tissuesLoadDataFromDB(
                        pool,
                        fridgeSelector = tissuesFridgeSelector,
                        sexSelector = tissuesSexSelector,
                        ageRangeSelector = tissuesAgeRangeSelector,
                        diagnosisMultipleSelector = tissuesDiagnosisMultipleSelector,
                        timeSelector = tissuesTimeSelector
                )

                if (input$tissuesEditableSelector) {
                        tissueValues$editableTable <- TRUE
                        # return editable table
                        shiny::callModule(
                                tissueEditable,
                                id = "tissuesEditable",
                                dataFromDB = tissuesDataFromDB,
                                checkEditTable = tissuesCheckEditTable,
                                modalUI = tissuesAddEntryUI
                        )
                }
                if (! input$tissuesEditableSelector) {
                        tissueValues$editableTable <- FALSE
                        # return noneditable table
                        shiny::callModule(
                                readOnly,
                                id = "tissuesReadOnly",
                                dataFromDB = tissuesDataFromDB
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
output$editableTable <- reactive({
        return(tissueValues$editableTable)
})
outputOptions(output, "tissuesError",  suspendWhenHidden = FALSE)
outputOptions(output, "editableTable", suspendWhenHidden = FALSE)
