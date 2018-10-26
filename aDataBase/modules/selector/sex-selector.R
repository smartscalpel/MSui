# Module UI function
sexSelectorUI <- function(id) {
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
sexSelector <- function(input, output, session) {
        
        return(list(reactive({input$radio})))
}
