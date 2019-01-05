# Module UI function
patientsSndSexSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Select Sex",
                        choices = c(
                                "Null"  = "null",
                                "Men"   = "men",
                                "Women" = "women"
                        ),
                        inline = TRUE,
                        selected = "null"
                )
        )
}

# Module server function
patientsSndSexSelector <- function(input, output, session) {
        
        return(reactive({input$radio}))
}
