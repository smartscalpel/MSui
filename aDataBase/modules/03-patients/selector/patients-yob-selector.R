# Module UI function
patientsYobSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Year of birth",
                        choices = c("All"   = "all", 
                                    "Range" = "range",
                                    "-1"    = "-1"),
                        inline = TRUE
                ),
                
                shinyjs::useShinyjs(),
                shiny::sliderInput(
                        inputId = ns("yobrange"),
                        label = NULL,
                        min = 1900,
                        max = 2030,
                        step = 1,
                        value = c(1970, 2000),
                        sep = ''
                )
        )
}



# Module server function
patientsYobSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "all" | input$radio == "-1") {
                        shinyjs::disable("yobrange")
                }
                
                if (input$radio == "range") {
                        shinyjs::enable("yobrange")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$yobrange})))
}
