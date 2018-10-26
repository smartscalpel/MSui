# Module UI function
diagnosisSingleSelectorUI <- function(id, diagnosisDictionary) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId  = ns("radio"),
                        label    = "Select Diagnosis",
                        choices  = c("Null" = "null", 
                                     "List" = "list"),
                        inline   = TRUE,
                        selected = "null"
                ),
                
                shiny::selectInput(
                        inputId  = ns("diagnosislist"),
                        label    = NULL,
                        multiple = FALSE,
                        choices  = diagnosisDictionary,
                        selected = NULL,
                        width = "50%"
                )
        )
}



# Module server function
diagnosisSingleSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "list") {
                        shinyjs::enable("diagnosislist")
                }
                
                if (input$radio == "null") {
                        shinyjs::disable("diagnosislist")
                }
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$diagnosislist})))
}
