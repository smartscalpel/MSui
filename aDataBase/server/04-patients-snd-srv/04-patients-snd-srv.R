source("./server/04-patients-snd-srv/patientsSndCheckEmsIdUniqueness.R",     local = TRUE)
source("./server/04-patients-snd-srv/patientsSndRecieveDataFromSelectors.R", local = TRUE)
source("./server/04-patients-snd-srv/patientsSndSavePatient.R",              local = TRUE)



patientsSndSexSelector <- shiny::callModule(patientsSndSexSelector, "patientsSndSexSelector")
patientsSndYobSelector <- shiny::callModule(patientsSndYobSelector, "patientsSndYobSelector")
patientsSndAgeSelector <- shiny::callModule(patientsSndAgeSelector, "patientsSndAgeSelector")



shiny::observeEvent(input$patientsSndSave, {
        
        if (patientsSndCheckEmsIdUniqueness(pool = pool, emsIdValue = input$patientsSndEmsId)) {
                
                patientsSndData <- patientsSndRecieveDataFromSelectors(
                        emsId = input$patientsSndEmsId,
                        yob   = patientsSndYobSelector,
                        sex   = patientsSndSexSelector,
                        age   = patientsSndAgeSelector
                )
                
                patientsSndSavePatient(pool = pool, patientData = patientsSndData)
                showModal(
                        dataModal(
                                modalID = "patientsSndModal",
                                failed = FALSE,
                                msg = "Data was successfully stored in database!"
                        )
                )
        } else {
                showModal(
                        dataModal(
                                modalID = "patientsSndModal",
                                failed = TRUE,
                                msg = "Given label already exists in database. Please, try anouther one"
                        )
                )
        }
        
})



observeEvent(input$patientsSndModal, {
        removeModal()
})
