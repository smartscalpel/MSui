source("./server/03-patients-srv/patientsSaveModifiedTable.R",     local = TRUE)
source("./server/03-patients-srv/patientsLoadDataFromDB.R",        local = TRUE)
source("./server/03-patients-srv/patientsCheckSelectorValues.R",   local = TRUE)
source("./server/03-patients-srv/patientsCheckTableModification.R", local = TRUE)



# Variables for conditionalPanel. Display editable/readOnly table or error message
patientsReactiveValues <- shiny::reactiveValues()
patientsReactiveValues$error         <- TRUE
patientsReactiveValues$editableTable <- FALSE

# Data from data base is reactive
patientsReactiveDataFromDB <- shiny::reactiveVal()
patientsReactiveDataFromDB(NULL)

# Special trigger for updating table inside editable and readOnly modules
patientsTriggerUpdateTableEditable <- shiny::reactiveVal()
patientsTriggerUpdateTableEditable(0)
patientsTriggerUpdateTableReadOnly <- shiny::reactiveVal()
patientsTriggerUpdateTableReadOnly(0)



# Initial Screen
output$patientsScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")



# Call modules
patientsSexSelector <- shiny::callModule(patientsSexSelector, "patientsSexSelector")
patientsAgeSelector <- shiny::callModule(patientsAgeSelector, "patientsAgeSelector")
patientsYobSelector <- shiny::callModule(patientsYobSelector, "patientsYobSelector")

patientsTableEditableClickedData <- shiny::callModule(
        editable,
        id = "patientsEditable",
        dtTable = patientsDtTable,
        reactiveDataFromDB = patientsReactiveDataFromDB,
        hideColumns = c(0),
        checkModification = patientsCheckTableModification,
        saveUpdated = patientsSaveModifiedTable(pool),
        dataModal = dataModal,
        trigger = patientsTriggerUpdateTableEditable
)

patientsTableReadOnlyClickedData <- shiny::callModule(
        readOnly,
        dtTable = patientsDtTable,
        id = "patientsReadOnly",
        reactiveDataFromDB = patientsReactiveDataFromDB,
        hideColumns = c(0),
        trigger = patientsTriggerUpdateTableReadOnly
)

patientClickedEmsId <- reactive({
        if (patientsReactiveValues$editableTable) {
                patientsReactiveDataFromDB()[patientsTableEditableClickedData()$row, ]$emsid
        } else {
                patientsReactiveDataFromDB()[patientsTableReadOnlyClickedData()$row, ]$emsid
        }
})

# Load data from DB
shiny::observeEvent(input$patientsSelect, {
        
        patientsCheckInputRes <- patientsCheckSelectorValues()
        patientsFromDB <- patientsLoadDataFromDB(
                pool = pool,
                sexSelector = patientsSexSelector,
                ageSelector = patientsAgeSelector,
                yobSelector = patientsYobSelector
        )
        if (patientsCheckInputRes[[1]]) {
                patientsReactiveValues$error <- FALSE
                
                # Load data from database
                if (patientsFromDB[[1]]){
                        patientsReactiveDataFromDB(
                                patientsDataFromDB <- patientsFromDB[[2]]
                        )
                        
                        if (input$patientsEditableSelector) {
                                patientsReactiveValues$editableTable <- TRUE
                                
                                patientsTriggerUpdateTableEditable(
                                        patientsTriggerUpdateTableEditable() + 1
                                )
                        }
                        if (! input$patientsEditableSelector) {
                                patientsReactiveValues$editableTable <- FALSE
                                
                                patientsTriggerUpdateTableReadOnly(
                                        patientsTriggerUpdateTableReadOnly() + 1
                                )
                        }
                } else {
                        patientsReactiveValues$error <- TRUE
                        
                        output$patientsScreensaver  <- generateHtmlScreenSaver(inputText = patientsFromDB[[2]])
                        output$patientsErrorMessage <- generateErrorMessage(errorText = patientsFromDB[[3]])
                }
                
        } else {
                patientsReactiveValues$error <- TRUE
                
                output$patientsScreensaver  <- generateHtmlScreenSaver(inputText = "Oops, something went wrong!")
                output$patientsErrorMessage <- generateErrorMessage(errorText = patientsCheckInputRes[[2]])
        }
})



# Variables for conditionalPanel. Display editable/readOnly table or error message
output$patientsError <- reactive({
        return(patientsReactiveValues$error)
})
output$patientsEditableTable <- reactive({
        return(patientsReactiveValues$editableTable)
})
outputOptions(output, "patientsError",         suspendWhenHidden = FALSE)
outputOptions(output, "patientsEditableTable", suspendWhenHidden = FALSE)
