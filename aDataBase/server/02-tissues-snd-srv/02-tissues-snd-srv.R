source("./server/02-tissues-snd-srv/tissuesSndCheckEmsId.R",               local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndCheckLabelUniqueness.R",     local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndCreateNewPatient.R",         local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndSaveTissue.R",               local = TRUE)
source("./server/02-tissues-snd-srv/tissuesSndRecieveDataFromSelectors.R", local = TRUE)



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



tissuesSndValues <- reactiveValues()
tissuesSndValues$find <- FALSE
tissuesSndValues$add  <- FALSE



shiny::observeEvent(input$tissueSndSearch, {
        
        tissuesSndCheckEmsIdOutput <- tissuesSndCheckEmsId(pool, input$tissueSndEmsId)
        
        if (isTRUE(tissuesSndCheckEmsIdOutput[[1]])) {
                tissuesSndValues$find <- TRUE
                tissuesSndValues$add  <- FALSE
                
                shiny::callModule(
                        module = tissuesSndCreateTissue,
                        dataModal = dataModal,
                        id = "tissuesSndCreateTissue",
                        patient = tissuesSndCheckEmsIdOutput[[2]],
                        checkLabelUniqueness = tissuesSndCheckLabelUniqueness(pool = pool),
                        saveTissue = tissuesSndSaveTissue(pool = pool),
                        recieveDataFromSelectors = tissuesSndRecieveDataFromSelectors
                )
        }
        if (is.null(tissuesSndCheckEmsIdOutput[[1]])) {
                tissuesSndValues$find <- FALSE
                tissuesSndValues$add  <- FALSE
                
                output$tissuesSndMessgae <- generateErrorMessage(
                        "EmsId is empty. Just type something!"
                )
        }
        if (isFALSE(tissuesSndCheckEmsIdOutput[[1]])) {
                tissuesSndValues$find <- FALSE
                tissuesSndValues$add  <- TRUE
                
                output$tissuesSndMessgae <- generateErrorMessage(
                        "Unfortunately, we can't find a patient with given EmsId.
                        You can try to search again with different value or create a new patient.
                        If you want to do it, see information below."
                )
                shiny::callModule(
                        module = tissuesSndCreatePatient,
                        dataModal = dataModal,
                        id = "tissuesSndCreatePatient",
                        input$tissueSndEmsId,
                        tissuesSndCreateNewPatient(pool)
                )
        }      
})



output$tissuesSndFind <- reactive({
        return(tissuesSndValues$find)
})
output$tissuesSndAdd <- reactive({
        return(tissuesSndValues$add)
})
outputOptions(output, "tissuesSndFind", suspendWhenHidden = FALSE)
outputOptions(output, "tissuesSndAdd",  suspendWhenHidden = FALSE)
