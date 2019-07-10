source("./server/01-tissues-srv/tissuesCheckSelectorValues.R",    local = TRUE)
source("./server/01-tissues-srv/tissuesSaveModifiedTable.R",      local = TRUE)
source("./server/01-tissues-srv/tissuesLoadDataFromDB.R",         local = TRUE)
source("./server/01-tissues-srv/tissuesCheckTableModification.R", local = TRUE)



# Variables for conditionalPanel. Display editable/readOnly table or error message
tissueReactiveValues <- shiny::reactiveValues()
tissueReactiveValues$error         <- TRUE
tissueReactiveValues$editableTable <- FALSE

# Data from data base is reactive
tissuesReactiveDataFromDB <- shiny::reactiveVal()
tissuesReactiveDataFromDB(NULL)

# Special trigger for updating table inside editable and readOnly modules
tissuesTriggerUpdateTableEditable <- shiny::reactiveVal()
tissuesTriggerUpdateTableEditable(0)
tissuesTriggerUpdateTableReadOnly <- shiny::reactiveVal()
tissuesTriggerUpdateTableReadOnly(0)



# Initial Screen
output$tissuesScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")



# Call modules
tissuesFridgeSelector    <- shiny::callModule(tissuesFridgeSelector,    "tissuesFridgeSelector")
tissuesSexSelector       <- shiny::callModule(tissuesSexSelector,       "tissuesSexSelector")
tissuesAgeSelector       <- shiny::callModule(tissuesAgeSelector,       "tissuesAgeSelector")
tissuesDiagnosisSelector <- shiny::callModule(tissuesDiagnosisSelector, "tissuesDiagnosisSelector")
tissuesTimeSelector      <- shiny::callModule(tissuesTimeSelector,      "tissuesTimeSelector")

tissuesTableEditableClickedData <- shiny::callModule(
        editable,
        id = "tissuesEditable",
        dtTable = dtTable,
        reactiveDataFromDB = tissuesReactiveDataFromDB,
        hideColumns = c(0, 1),
        checkModification = tissuesCheckTableModification,
        saveUpdated = tissuesSaveModifiedTable(pool = pool),
        dataModal = dataModal,
        trigger = tissuesTriggerUpdateTableEditable
)

tissuesTableReadOnlyClickedData <- shiny::callModule(
        readOnly,
        dtTable = dtTable,
        id = "tissuesReadOnly",
        reactiveDataFromDB = tissuesReactiveDataFromDB,
        hideColumns = c(0, 1),
        trigger = tissuesTriggerUpdateTableReadOnly
)



# Auto filling emsId in tissue-snd tab
tissuesClickedEmsId <- reactive({
        if (tissueReactiveValues$editableTable) {
                tissuesReactiveDataFromDB()[tissuesTableEditableClickedData()$row, ]$emsid
        } else {
                tissuesReactiveDataFromDB()[tissuesTableReadOnlyClickedData()$row, ]$emsid
        }
})



# Load data from DB
shiny::observeEvent(input$tissuesSelect, {
        
        tissuesCheckOutput <- tissuesCheckSelectorValues(
                diagnosisSelector = tissuesDiagnosisSelector,
                timeSelector = tissuesTimeSelector
        )
        loadedDataFromDb <- tissuesLoadDataFromDB(
                pool = pool,
                fridgeSelector = tissuesFridgeSelector,
                sexSelector = tissuesSexSelector,
                ageSelector = tissuesAgeSelector,
                diagnosisSelector = tissuesDiagnosisSelector,
                timeSelector = tissuesTimeSelector
        )
        
        if (tissuesCheckOutput[[1]]) {
                tissueReactiveValues$error <- FALSE
                # Load data from database
                if (loadedDataFromDb[[1]]) {
                        tissuesReactiveDataFromDB(loadedDataFromDb[[2]])
                        
                        if (input$tissuesEditableSelector) {
                                tissueReactiveValues$editableTable <- TRUE
                                
                                tissuesTriggerUpdateTableEditable(
                                        tissuesTriggerUpdateTableEditable() + 1
                                )
                        }
                        if (! input$tissuesEditableSelector) {
                                tissueReactiveValues$editableTable <- FALSE
                                
                                tissuesTriggerUpdateTableReadOnly(
                                        tissuesTriggerUpdateTableReadOnly() + 1
                                )
                        }
                } else {
                        tissueReactiveValues$error <- TRUE
                        
                        output$tissuesScreensaver  <- generateHtmlScreenSaver(inputText = loadedDataFromDb[[2]])
                        output$tissuesErrorMessage <- generateErrorMessage(errorText = loadedDataFromDb[[3]])
                }
                
        } else {
                tissueReactiveValues$error <- TRUE

                output$tissuesScreensaver  <- generateHtmlScreenSaver(inputText = "Oops, something went wrong!")
                output$tissuesErrorMessage <- generateErrorMessage(errorText = tissuesCheckOutput[[2]])
        }
})



# Variables for conditionalPanel. Display editable/readOnly table or error message
output$tissuesError <- reactive({
        return(tissueReactiveValues$error)
})
output$tissuesEditableTable <- reactive({
        return(tissueReactiveValues$editableTable)
})
outputOptions(output, "tissuesError",         suspendWhenHidden = FALSE)
outputOptions(output, "tissuesEditableTable", suspendWhenHidden = FALSE)
