source("./server/03-patients-srv/patientsSaveUpdated.R",    local = TRUE)
source("./server/03-patients-srv/patientsLoadDataFromDB.R", local = TRUE)
source("./server/03-patients-srv/patientsCheckInput.R",     local = TRUE)
source("./server/03-patients-srv/patientsCheckEditTable.R", local = TRUE)



patientsSexSelector <- shiny::callModule(patientsSexSelector, "patientsSexSelector")
patientsAgeSelector <- shiny::callModule(patientsAgeSelector, "patientsAgeSelector")
patientsYobSelector <- shiny::callModule(patientsYobSelector, "patientsYobSelector")


patientsValues <- reactiveValues()
patientsValues$patientsError         <- TRUE
patientsValues$patientsEditableTable <- FALSE

output$patientsScreensaver <- generateHtmlScreenSaver(inputText = "Set up Filters and press Select!")

shiny::observeEvent(input$patientsSelect, {
        
        patientsCheckInputRes <- patientsCheckInput()
        
        if (patientsCheckInputRes[[1]]) {
                patientsValues$patientsError <- FALSE
                
                # Load data from database
                patientsDataFromDB <- patientsLoadDataFromDB(
                        pool,
                        sexSelector = patientsSexSelector,
                        ageSelector = patientsAgeSelector,
                        yobSelector = patientsYobSelector
                )
                
                if (input$patientsEditableSelector) {
                        patientsValues$patientsEditableTable <- TRUE
                        # return editable table
                        shiny::callModule(
                                editable,
                                id = "patientsEditable",
                                dtTable = dtTable,
                                dataFromDB = patientsDataFromDB,
                                hideColumns = c(0),
                                checkEditTable = patientsCheckEditTable,
                                saveUpdated = patientsSaveUpdated,
                                dataModal = dataModal
                        )
                }
                if (! input$patientsEditableSelector) {
                        patientsValues$editableTable <- FALSE
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
                patientsValues$patientsError <- TRUE
                
                output$patientsScreensaver  <- generateHtmlScreenSaver(inputText = "Oops, something went wrong!")
                output$patientsErrorMessage <- generateErrorMessage(errorText = patientsCheckInputRes[[2]])
        }
})

output$patientsError <- reactive({
        return(patientsValues$patientsError)
})
output$patientsEditableTable <- reactive({
        return(patientsValues$patientsEditableTable)
})
outputOptions(output, "patientsError",         suspendWhenHidden = FALSE)
outputOptions(output, "patientsEditableTable", suspendWhenHidden = FALSE)
