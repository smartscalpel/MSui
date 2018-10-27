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



# These reactive values are needed to control ConditionalPanels in UI
tissuesAddValues <- reactiveValues()
tissuesAddValues$find <- FALSE
tissuesAddValues$add  <- FALSE

output$tissuesAddFind <- reactive({
        return(tissuesAddValues$find)
})
output$tissuesAddPatient <- reactive({
        return(tissuesAddValues$add)
})
outputOptions(output, "tissuesAddFind",    suspendWhenHidden = FALSE)
outputOptions(output, "tissuesAddPatient", suspendWhenHidden = FALSE)



# Serch EmsId...
shiny::observeEvent(input$tissuesAddSearch, {
        
        tissuesCheckEmsIdRes <- tissuesCheckEmsId(
                pool = pool,
                emsIdValue = input$tissuesAddEmsId
        )
        
        if (isTRUE(tissuesCheckEmsIdRes[[1]])) {
                tissuesAddValues$find <- TRUE
                tissuesAddValues$add  <- FALSE
                
                shiny::callModule(
                        module = tissuesAddEntry,
                        id = "tissuesAddEntry",
                        patient = tissuesCheckEmsIdRes[[2]],
                        checkLabelUniqueness = tissuesCheckLabelUniqueness(pool = pool),
                        saveEntry = tissuesSaveEntry(pool = pool)
                )
        }
        if (is.null(tissuesCheckEmsIdRes[[1]])) {
                tissuesAddValues$find <- FALSE
                tissuesAddValues$add  <- FALSE
                
                output$tissuesAddMessgae <- generateErrorMessage(
                        "EmsId is empty. Just type something!"
                )
        }
        if (isFALSE(tissuesCheckEmsIdRes[[1]])) {
                tissuesAddValues$find <- FALSE
                tissuesAddValues$add  <- TRUE
                
                output$tissuesAddMessgae <- generateErrorMessage(
                        "Unfortunately, we can't find a patient with given EmsId.
                        You can try to search again with different value or create a new patient.
                        If you want to do it, just press the button below."
                )
        }      
})



tmpPatientTable <- function (emsid) {
        df <- base::data.frame(NA, emsid, -1, NA, NA)
        x <- c("id", "emsid", "yob", "sex", "age")
        base::colnames(df) <- x
        
        return(df)
}

output$tissuesAddTmpPatientTable <- DT::renderDataTable(
        DT::datatable(
                data = tmpPatientTable(emsid = input$tissuesAddEmsId),
                rownames = FALSE,
                
                extensions = list(
                        'Scroller' = NULL
                ),
                
                options = list(
                        scrollX = TRUE,
                        paging = FALSE,
                        dom = 'tip'
                ),
                
                selection = "none",
                editable = FALSE
        )
)



# Usefull modal
tissueAddModal <- function(failed, msg) {
        modalDialog(
                
                if (failed)
                        div(tags$b(msg, style = "color: red;")),
                
                if (! failed)
                        div(tags$b(msg, style = "color: green;")),
                
                footer = tagList(
                        actionButton("tissueAddOk", "Ok")
                )
        )
}



# Save Patient
shiny::observeEvent(input$tissuesAddPatientModalSave, {

        shinyBS::toggleModal(
                session = session,
                modalId = "tissuesAddPatientModal",
                toggle = "toggle"
        )
        
        # Save data to the database
        # TODO: make a transaction and wait until it will be finished
        tissuesAddNewPatient(
                pool = pool,
                emsid = input$tissuesAddEmsId
        )
        
        showModal(tissueAddModal(FALSE, "The data was sucesfully stored in the database"))
})



# Update data
shiny::observeEvent(input$tissueAddOk, {
        shinyjs::click(id = "tissuesAddSearch")
        removeModal()
})
