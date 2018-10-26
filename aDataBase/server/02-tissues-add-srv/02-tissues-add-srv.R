source("./server/02-tissues-add-srv/tissuesAddDB.R",             local = TRUE)
source("./server/02-tissues-add-srv/recieveDataFromSelectors.R", local = TRUE)

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
        
        tissuesCheckEmsIdOutput <- tissuesCheckEmsId(pool, input$tissueAddEmsId)
        
        if (isTRUE(tissuesCheckEmsIdOutput[[1]])) {
                tissuesAddValues$find <- TRUE
                tissuesAddValues$add  <- FALSE
                
                shiny::callModule(
                        module = tissuesAddEntry,
                        id = "tissuesAddEntry",
                        patient = tissuesCheckEmsIdOutput[[2]],
                        checkLabelUniqueness = tissuesCheckLabelUniqueness(pool = pool),
                        saveEntry = tissuesSaveEntry(pool = pool)
                )
        }
        if (is.null(tissuesCheckEmsIdOutput[[1]])) {
                tissuesAddValues$find <- FALSE
                tissuesAddValues$add  <- FALSE
                
                output$tissuesAddMessgae <- generateErrorMessage(
                        "EmsId is empty. Just type something!"
                )
        }
        if (isFALSE(tissuesCheckEmsIdOutput[[1]])) {
                tissuesAddValues$find <- FALSE
                tissuesAddValues$add  <- TRUE
                
                output$tissuesAddMessgae <- generateErrorMessage(
                        "Unfortunately, we can't find a patient with given EmsId.
                        You can try to search again with different value or create a new patient.
                        If you want to do it, see information below."
                )
                shiny::callModule(
                        module = tissuesAddPatient,
                        id = "tissuesAddPatient",
                        input$tissueAddEmsId,
                        tissuesAddNewPatient(pool),
                        session2 = session
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
