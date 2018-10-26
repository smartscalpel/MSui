# Module UI function
fridgeSelectorUI <- function(id) {
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

fridgeSelector <- function(input, output, session) {
        
        return(list(reactive({input$radio})))
}
