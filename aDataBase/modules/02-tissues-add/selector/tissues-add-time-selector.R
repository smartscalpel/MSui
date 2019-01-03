# Module UI function
tissuesAddTimeSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Select Time",
                        choices = c("Null" = "null", 
                                    "Value"  = "val"),
                        inline = TRUE,
                        selected = "null"
                ),
                
                shinyjs::useShinyjs(),
                shiny::dateInput(
                        inputId = ns("date"),
                        label = NULL,
                        width = "50%"
                )
        )
}



# Module server function
tissuesAddTimeSelector <- function(input, output, session) {
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns
                
                if (input$radio == "null") {
                        shinyjs::disable("date")
                }
                
                if (input$radio == "val") {
                        shinyjs::enable("date")
                }
                
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$date})))
}
