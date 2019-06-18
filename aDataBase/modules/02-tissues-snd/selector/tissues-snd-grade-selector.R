# Module UI function
tissuesSndGradeSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Grade",
                        choices = c("Null"  = "null", 
                                    "Value" = "val"),
                        inline = TRUE
                ),
                
                shinyjs::useShinyjs(),
                shiny::sliderInput(
                        inputId = ns("gradeval"),
                        label = NULL,
                        min = 0,
                        max = 10,
                        step = 1,
                        value = 5,
                        width = "50%"
                )
        )
}



# Module server function
tissuesSndGradeSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "null") {
                        shinyjs::disable("gradeval")
                }
                
                if (input$radio == "val") {
                        shinyjs::enable("gradeval")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$gradeval})))
}
