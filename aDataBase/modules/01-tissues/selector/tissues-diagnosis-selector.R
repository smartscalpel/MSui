# Module UI function
tissuesDiagnosisSelectorUI <- function(id, diagnosisDictionary) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId  = ns("radio"),
                        label    = "Select Diagnosis",
                        choices  = c("All"  = "all", 
                                    "List" = "list"),
                        inline   = TRUE,
                        selected = "all"
                ),
                
                shiny::selectInput(
                        inputId  = ns("diagnosislist"),
                        label    = NULL,
                        multiple = TRUE,
                        choices  = diagnosisDictionary,
                        selected = NULL
                )
        )
}



# Module server function
tissuesDiagnosisSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "list") {
                        shinyjs::enable("diagnosislist")
                }
                
                if (input$radio == "all") {
                        shinyjs::disable("diagnosislist")
                }
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$diagnosislist})))
}
