# Module UI function
patientsAddSexSelectorUI <- function(id) {
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
patientsAddSexSelector <- function(input, output, session) {
        
        return(list(reactive({input$radio})))
}
