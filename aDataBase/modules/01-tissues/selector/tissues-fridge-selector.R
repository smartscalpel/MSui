# Module UI function
tissuesFridgeSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Avaliability in Fridge",
                        choices = c(All = "all", 
                                    Yes = "yes",
                                    No  = "no"),
                        inline = TRUE
                )
        )
}

tissuesFridgeSelector <- function(input, output, session) {
        
        return(list(reactive({input$radio})))
}
