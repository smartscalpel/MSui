source("./server/04-patients-snd-srv/patientsSndCheckEmsIdUniqueness.R",  local = TRUE)
source("./server/04-patients-snd-srv/patientsSndRecieveSelectorValues.R", local = TRUE)
source("./server/04-patients-snd-srv/patientsSndSavePatient.R",           local = TRUE)



# Auto filling emsId from tissue-snd tab, if search of patient is unsuccessful
patientsSndEmptyEmsIdFromTissue <- reactiveVal()
patientsSndEmptyEmsIdFromTissue(NULL)

observeEvent(patientsSndEmptyEmsIdFromTissue(), {
        updateTextInput(session = session, inputId = "patientsSndEmsId", value = patientsSndEmptyEmsIdFromTissue())
})



# Call modules
patientsSndSexSelector <- shiny::callModule(patientsSndSexSelector, "patientsSndSexSelector")
patientsSndYobSelector <- shiny::callModule(patientsSndYobSelector, "patientsSndYobSelector")
patientsSndAgeSelector <- shiny::callModule(patientsSndAgeSelector, "patientsSndAgeSelector")



# Save patient in database
shiny::observeEvent(input$patientsSndSave, {
        
        if (patientsSndCheckEmsIdUniqueness(pool = pool, emsIdValue = input$patientsSndEmsId)) {
                
                patientsSndData <- patientsSndRecieveSelectorValues(
                        emsId = input$patientsSndEmsId,
                        yob   = patientsSndYobSelector,
                        sex   = patientsSndSexSelector,
                        age   = patientsSndAgeSelector
                )
                
                if (patientsSndSavePatient(pool = pool, patientData = patientsSndData)) {
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
                                        msg = "Oops, something went wrong!"
                                )
                        )
                }
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
