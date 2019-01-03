source("./server/04-patients-add-srv/patientsAddCheckEmsIdUniqueness.R",     local = TRUE)
source("./server/04-patients-add-srv/patientsAddRecieveDataFromSelectors.R", local = TRUE)
source("./server/04-patients-add-srv/patientsAddSavePatient.R",              local = TRUE)



patientsAddSexSelector <- shiny::callModule(patientsAddSexSelector, "patientsAddSexSelector")
patientsAddYobSelector <- shiny::callModule(patientsAddYobSelector, "patientsAddYobSelector")
patientsAddAgeSelector <- shiny::callModule(patientsAddAgeSelector, "patientsAddAgeSelector")



shiny::observeEvent(input$patientsAddSave, {
        
        if (patientsAddCheckEmsIdUniqueness(pool = pool, emsIdValue = input$patientsAddEmsId)) {
                
                patientsAddData <- patientsAddRecieveDataFromSelectors(
                        emsId = input$patientsAddEmsId,
                        yob   = patientsAddYobSelector,
                        sex   = patientsAddSexSelector,
                        age   = patientsAddAgeSelector
                )
                
                patientsAddSavePatient(pool = pool, patientsAddData = patientsAddData)
                showModal(
                        dataModal(
                                modalID = "patientsAddModal",
                                failed = FALSE,
                                msg = "Data was successfully stored in database!"
                        )
                )
        } else {
                showModal(
                        dataModal(
                                modalID = "patientsAddModal",
                                failed = TRUE,
                                msg = "Given label already exists in database. Please, try anouther one"
                        )
                )
        }
        
})



observeEvent(input$patientsAddModal, {
        removeModal()
})
