# Module UI function
patientsSexSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Sex",
                        choices = c("All" = "all", 
                                    "M"   = "men",
                                    "W"   = "women",
                                    "Null" = "null"),
                        inline = TRUE
                )
        )
}

# Module server function
patientsSexSelector <- function(input, output, session) {
        
        return(list(reactive({input$radio})))
}
