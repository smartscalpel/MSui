# Module UI function
patientsAgeSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Age",
                        choices = c("All"   = "all", 
                                    "Range" = "range"),
                        inline = TRUE
                ),
                
                shinyjs::useShinyjs(),
                shiny::sliderInput(
                        inputId = ns("agerange"),
                        label = NULL,
                        min = 0,
                        max = 100,
                        step = 1,
                        value = c(30, 40)
                )
        )
}



# Module server function
patientsAgeSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "all") {
                        shinyjs::disable("agerange")
                }
                
                if (input$radio == "range") {
                        shinyjs::enable("agerange")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$agerange})))
}
