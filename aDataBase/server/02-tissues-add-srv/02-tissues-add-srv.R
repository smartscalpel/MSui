source("./server/02-tissues-add-srv/tissuesAddCheckEmsId.R",               local = TRUE)
source("./server/02-tissues-add-srv/tissuesAddCheckLabelUniqueness.R",     local = TRUE)
source("./server/02-tissues-add-srv/tissuesAddCreateNewPatient.R",         local = TRUE)
source("./server/02-tissues-add-srv/tissuesAddSaveTissue.R",               local = TRUE)
source("./server/02-tissues-add-srv/tissuesAddRecieveDataFromSelectors.R", local = TRUE)

output$tissuesAddMessgae <- shiny::renderText({
        HTML(
                paste(
                        '<span style="opacity: 0.4;">
                                <font color=\"gray\" face=\"Helvetica\" size=\"1\">',
                                        "Type something and press Search!",
                                '</font>'
                )
        )
})

tissuesAddValues <- reactiveValues()
tissuesAddValues$find <- FALSE
tissuesAddValues$add  <- FALSE

shiny::observeEvent(input$tissueAddSearch, {
        
        tissuesAddCheckEmsIdOutput <- tissuesAddCheckEmsId(pool, input$tissueAddEmsId)
        
        if (isTRUE(tissuesAddCheckEmsIdOutput[[1]])) {
                tissuesAddValues$find <- TRUE
                tissuesAddValues$add  <- FALSE
                
                shiny::callModule(
                        module = tissuesAddCreateTissue,
                        dataModal = dataModal,
                        id = "tissuesAddCreateTissue",
                        patient = tissuesAddCheckEmsIdOutput[[2]],
                        checkLabelUniqueness = tissuesAddCheckLabelUniqueness(pool = pool),
                        saveTissue = tissuesAddSaveTissue(pool = pool),
                        recieveDataFromSelectors = tissuesAddRecieveDataFromSelectors
                )
        }
        if (is.null(tissuesAddCheckEmsIdOutput[[1]])) {
                tissuesAddValues$find <- FALSE
                tissuesAddValues$add  <- FALSE
                
                output$tissuesAddMessgae <- generateErrorMessage(
                        "EmsId is empty. Just type something!"
                )
        }
        if (isFALSE(tissuesAddCheckEmsIdOutput[[1]])) {
                tissuesAddValues$find <- FALSE
                tissuesAddValues$add  <- TRUE
                
                output$tissuesAddMessgae <- generateErrorMessage(
                        "Unfortunately, we can't find a patient with given EmsId.
                        You can try to search again with different value or create a new patient.
                        If you want to do it, see information below."
                )
                shiny::callModule(
                        module = tissuesAddCreatePatient,
                        dataModal = dataModal,
                        id = "tissuesAddCreatePatient",
                        input$tissueAddEmsId,
                        tissuesAddCreateNewPatient(pool)
                )
        }      
})

output$tissuesAddFind <- reactive({
        return(tissuesAddValues$find)
})
output$tissuesAddAdd <- reactive({
        return(tissuesAddValues$add)
})
outputOptions(output, "tissuesAddFind", suspendWhenHidden = FALSE)
outputOptions(output, "tissuesAddAdd",  suspendWhenHidden = FALSE)
