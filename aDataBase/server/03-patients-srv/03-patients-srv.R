source("./server/03-patients-srv/patientsSaveUpdated.R",    local = TRUE)
source("./server/03-patients-srv/patientsLoadDataFromDB.R", local = TRUE)
source("./server/03-patients-srv/patientsCheckInput.R",     local = TRUE)
source("./server/03-patients-srv/patientsCheckEditTable.R", local = TRUE)



patientsSexSelector <- shiny::callModule(patientsSexSelector, "patientsSexSelector")
patientsAgeSelector <- shiny::callModule(patientsAgeSelector, "patientsAgeSelector")
patientsYobSelector <- shiny::callModule(patientsYobSelector, "patientsYobSelector")


patientsReactiveValues <- reactiveValues()
patientsReactiveValues$error         <- TRUE
patientsReactiveValues$editableTable <- FALSE

output$patientsScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")

shiny::observeEvent(input$patientsSelect, {
        
        patientsCheckInputRes <- patientsCheckInput()
        
        if (patientsCheckInputRes[[1]]) {
                patientsReactiveValues$error <- FALSE
                
                # Load data from database
                patientsDataFromDB <- patientsLoadDataFromDB(
                        pool,
                        sexSelector = patientsSexSelector,
                        ageSelector = patientsAgeSelector,
                        yobSelector = patientsYobSelector
                )
                
                if (input$patientsEditableSelector) {
                        patientsReactiveValues$editableTable <- TRUE
                        # return editable table
                        shiny::callModule(
                                editable,
                                id = "patientsEditable",
                                dtTable = dtTable,
                                dataFromDB = patientsDataFromDB,
                                hideColumns = c(0),
                                checkEditTable = patientsCheckEditTable,
                                saveUpdated = patientsSaveUpdated(pool),
                                dataModal = dataModal
                        )
                }
                if (! input$patientsEditableSelector) {
                        patientsReactiveValues$editableTable <- FALSE
                        # return noneditable table
                        shiny::callModule(
                                readOnly,
                                dtTable = dtTable,
                                id = "patientsReadOnly",
                                dataFromDB = patientsDataFromDB,
                                hideColumns = c(0)
                        )
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
