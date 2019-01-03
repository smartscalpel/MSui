# Module UI function
patientsAddYobSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::sliderInput(
                        inputId = ns("yobvalue"),
                        label = "Year of birth",
                        min = 1900,
                        max = 2000,
                        step = 1,
                        value = c(1900),
                        width = "50%"
                )
        )
}



# Module server function
patientsAddYobSelector <- function(input, output, session) {
        
        return(reactive({input$yobvalue}))
}
