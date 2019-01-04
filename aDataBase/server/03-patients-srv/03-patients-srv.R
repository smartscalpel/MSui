source("./server/03-patients-srv/patientsSaveModifiedTable.R",     local = TRUE)
source("./server/03-patients-srv/patientsLoadDataFromDB.R",        local = TRUE)
source("./server/03-patients-srv/patientsCheckSelectorValues.R",   local = TRUE)
source("./server/03-patients-srv/patientsCheckTableModification.R", local = TRUE)



patientsReactiveValues <- reactiveValues()
patientsReactiveValues$error         <- TRUE
patientsReactiveValues$editableTable <- FALSE

patientsReactiveDataFromDB <- reactiveVal()
patientsReactiveDataFromDB(NULL)

output$patientsScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")



patientsSexSelector <- shiny::callModule(patientsSexSelector, "patientsSexSelector")
patientsAgeSelector <- shiny::callModule(patientsAgeSelector, "patientsAgeSelector")
patientsYobSelector <- shiny::callModule(patientsYobSelector, "patientsYobSelector")

shiny::callModule(
        editable,
        id = "patientsEditable",
        dtTable = dtTable,
        reactiveDataFromDB = patientsReactiveDataFromDB,
        hideColumns = c(0),
        checkModification = tissuesCheckTableModification,
        saveUpdated = patientsSaveModifiedTable(pool),
        dataModal = dataModal
)

shiny::callModule(
        readOnly,
        dtTable = dtTable,
        id = "patientsReadOnly",
        reactiveDataFromDB = patientsReactiveDataFromDB,
        hideColumns = c(0)
)


shiny::observeEvent(input$patientsSelect, {
        
        patientsCheckInputRes <- patientsCheckSelectorValues()
        
        if (patientsCheckInputRes[[1]]) {
                patientsReactiveValues$error <- FALSE
                
                # Load data from database
                patientsReactiveDataFromDB(
                        patientsDataFromDB <- patientsLoadDataFromDB(
                                pool = pool,
                                sexSelector = patientsSexSelector,
                                ageSelector = patientsAgeSelector,
                                yobSelector = patientsYobSelector
                        )
                )
                
                if (input$patientsEditableSelector) {
                        patientsReactiveValues$editableTable <- TRUE
                }
                if (! input$patientsEditableSelector) {
                        patientsReactiveValues$editableTable <- FALSE
                }
        } else {
                patientsReactiveValues$error <- TRUE
                
                output$patientsScreensaver  <- generateHtmlScreenSaver(inputText = "Oops, something went wrong!")
                output$patientsErrorMessage <- generateErrorMessage(errorText = patientsCheckInputRes[[2]])
        }
})

output$patientsError <- reactive({
        return(patientsReactiveValues$error)
})
output$patientsEditableTable <- reactive({
        return(patientsReactiveValues$editableTable)
})
outputOptions(output, "patientsError",         suspendWhenHidden = FALSE)
outputOptions(output, "patientsEditableTable", suspendWhenHidden = FALSE)
