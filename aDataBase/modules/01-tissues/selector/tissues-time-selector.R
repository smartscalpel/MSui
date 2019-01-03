# Module UI function
tissuesTimeSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Select Time",
                        choices = c("All"  = "all", 
                                    "Range" = "range"),
                        inline = TRUE
                ),
                
                shinyjs::useShinyjs(),
                shiny::dateRangeInput(
                        inputId = ns("daterange"),
                        label = NULL,
                        start = Sys.Date() - 2,
                        end = Sys.Date() + 2
                )
        )
}



# Module server function
tissuesTimeSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "all") {
                        shinyjs::disable("daterange")
                }
                
                if (input$radio == "range") {
                        shinyjs::enable("daterange")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$daterange})))
}
