# Module UI function
patientsSndYobSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Year of birth",
                        choices = c("-1"   = "-1", 
                                    "Value" = "value"),
                        inline = TRUE
                ),
                
                shiny::sliderInput(
                        inputId = ns("yobvalue"),
                        label = NULL,
                        min = 1900,
                        max = 2000,
                        step = 1,
                        value = c(1900),
                        width = "50%"
                )
        )
}



# Module server function
patientsSndYobSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "-1") {
                        shinyjs::disable("yobvalue")
                }
                
                if (input$radio == "value") {
                        shinyjs::enable("yobvalue")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$yobvalue})))
}
