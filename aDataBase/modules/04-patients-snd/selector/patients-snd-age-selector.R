# Module UI function
patientsSndAgeSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Age",
                        choices = c("Null"  = "null", 
                                    "Value" = "value"),
                        inline = TRUE,
                        selected = "null"
                ),
                
                shinyjs::useShinyjs(),
                shiny::sliderInput(
                        inputId = ns("agevalue"),
                        label = NULL,
                        min = 0,
                        max = 100,
                        step = 1,
                        value = c(40),
                        width = "50%"
                )
        )
}



# Module server function
patientsSndAgeSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "null") {
                        shinyjs::disable("agevalue")
                }
                
                if (input$radio == "value") {
                        shinyjs::enable("agevalue")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$agevalue})))
}
