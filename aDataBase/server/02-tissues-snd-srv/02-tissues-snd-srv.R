source("./server/02-tissues-snd-srv/tissuesSndCheckEmsId.R",            local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndCheckLabelUniqueness.R",  local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndCreateNewPatient.R",      local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndSaveTissue.R",            local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndRecieveSelectorValues.R", local = TRUE)



output$tissuesSndMessgae <- shiny::renderText({
        HTML(
                paste(
                        '<span style="opacity: 0.4;">
                        <font color=\"gray\" face=\"Helvetica\" size=\"1\">',
                        "Type something and press Search!",
                        '</font>'
                )
        )
})



tissuesSndValues <- shiny::reactiveValues()
tissuesSndValues$find <- FALSE

tissuesSndReactivePatientData <- reactiveVal()
tissuesSndReactivePatientData(NULL)


shiny::callModule(
        module = tissuesSndCreateTissue,
        id = "tissuesSndCreateTissue",
        dataModal = dataModal,
        reactivePatientData = tissuesSndReactivePatientData,
        checkLabelUniqueness = tissuesSndCheckLabelUniqueness(pool = pool),
        saveTissue = tissuesSndSaveTissue(pool = pool),
        recieveSelectorValues = tissuesSndRecieveSelectorValues
)



observeEvent(tissuesClickedEmsId(), {
        updateTextInput(session = session, inputId = "tissueSndEmsId", value = tissuesClickedEmsId())
})



shiny::observeEvent(input$tissueSndSearch, {
        
        tissuesSndCheckEmsIdOutput <- tissuesSndCheckEmsId(pool, input$tissueSndEmsId)
        
        if (isTRUE(tissuesSndCheckEmsIdOutput[[1]])) {
                tissuesSndValues$find <- TRUE
                
                tissuesSndReactivePatientData(
                        tissuesSndCheckEmsIdOutput[[2]]
                )
        }
        if (is.null(tissuesSndCheckEmsIdOutput[[1]])) {
                tissuesSndValues$find <- FALSE
                
                output$tissuesSndMessgae <- generateErrorMessage(
                        "EmsId is empty. Just type something!"
                )
        }
        if (isFALSE(tissuesSndCheckEmsIdOutput[[1]])) {
                tissuesSndValues$find <- FALSE
                
                patientsSndEmptyEmsIdFromTissue(
                        input$tissueSndEmsId
                )
                
                output$tissuesSndMessgae <- generateErrorMessage(
                        "Unfortunately, we can't find a patient with given EmsId.
                        You can try to search again with different value or create a new patient.
                        If you want to do it, see information below."
                )
        }      
})



output$tissuesSndFind <- shiny::reactive({
        return(tissuesSndValues$find)
})
shiny::outputOptions(output, "tissuesSndFind", suspendWhenHidden = FALSE)
