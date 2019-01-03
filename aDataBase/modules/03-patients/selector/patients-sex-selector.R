# Module UI function
patientsSexSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Sex",
                        choices = c(All   = "all", 
                                    Men   = "men",
                                    Women = "women"),
                        inline = TRUE
                )
        )
}

# Module server function
patientsSexSelector <- function(input, output, session) {
        
        return(list(reactive({input$radio})))
}
