source("./server/04-patients-snd-srv/patientsSndCheckEmsIdUniqueness.R",  local = TRUE)
source("./server/04-patients-snd-srv/patientsSndRecieveSelectorValues.R", local = TRUE)
source("./server/04-patients-snd-srv/patientsSndSavePatient.R",           local = TRUE)



patientsSndEmptyEmsIdFromTissue <- reactiveVal()
patientsSndEmptyEmsIdFromTissue(NULL)



patientsSndSexSelector <- shiny::callModule(patientsSndSexSelector, "patientsSndSexSelector")
patientsSndYobSelector <- shiny::callModule(patientsSndYobSelector, "patientsSndYobSelector")
patientsSndAgeSelector <- shiny::callModule(patientsSndAgeSelector, "patientsSndAgeSelector")



observeEvent(patientsSndEmptyEmsIdFromTissue(), {
        updateTextInput(session = session, inputId = "patientsSndEmsId", value = patientsSndEmptyEmsIdFromTissue())
})

shiny::observeEvent(input$patientsSndSave, {
        
        if (patientsSndCheckEmsIdUniqueness(pool = pool, emsIdValue = input$patientsSndEmsId)) {
                
                patientsSndData <- patientsSndRecieveSelectorValues(
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
