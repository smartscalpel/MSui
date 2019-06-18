# Module UI function
tissuesSndDiagnosisSelectorUI <- function(id, diagnosisDictionary) {
        ns <- NS(id)
        
        tagList(
                shiny::selectInput(
                        inputId  = ns("diagnosislist"),
                        label    = "Select Diagnosis",
                        multiple = FALSE,
                        choices  = diagnosisDictionary,
                        selected = "unspecified",
                        width = "50%"
                )
        )
}



# Module server function
tissuesSndDiagnosisSelector <- function(input, output, session) {
        
        return(reactive({input$diagnosislist}))
}
