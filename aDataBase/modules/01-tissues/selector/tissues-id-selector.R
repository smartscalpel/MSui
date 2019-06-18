# Module UI function
tissuesIdSelectorUI <- function(id) {
        ns <- NS(id)
        
        tagList(
                shiny::radioButtons(
                        inputId = ns("radio"),
                        label = "Select Id",
                        choices = c("All"   = "all", 
                                    "Range" = "range"),
                        inline = TRUE
                ),
                
                shiny::textInput(
                        inputId = ns("idrange"),
                        label = NULL,
                        value = NULL,
                        placeholder = "523, 544, 546 - 578"
                )
        )
}



# Module server function
tissuesIdSelector <- function(input, output, session) {
        
        # observeEvent(input$idrange, {
        #         ns <- session$ns
        #         
        #         if (input$idrange == "") {
        #                 updateRadioButtons(
        #                         session  = session,
        #                         inputId  = "radio",
        #                         label    = "Select Id",
        #                         choices  = c("All"   = "all", 
        #                                     "Range" = "range"),
        #                         inline   = TRUE,
        #                         selected = "all"
        #                 )
        #         } else {
        #                 updateRadioButtons(
        #                         session  = session,
        #                         inputId  = "radio",
        #                         label    = "Select Id",
        #                         choices  = c("All"   = "all", 
        #                                     "Range" = "range"),
        #                         inline   = TRUE,
        #                         selected = "range"
        #                 )
        #         }
        # })
        # 
        # observeEvent(input$radio, {
        #         ns <- session$ns
        #         
        #         if (input$radio == "range" & input$idrange == "") {
        #                 updateRadioButtons(
        #                         session  = session,
        #                         inputId  = "radio",
        #                         label    = "Select Id",
        #                         choices  = c("All"   = "all",
        #                                      "Range" = "range"),
        #                         inline   = TRUE,
        #                         selected = "all"
        #                 )
        #         }
        # })
        
        shiny::observeEvent(input$radio, {
                ns <- session$ns

                if (input$radio == "range") {
                        shinyjs::enable("idrange")
                }
                
                if (input$radio == "all") {
                        shinyjs::disable("idrange")
                }
        })
        
        return(list(reactive({input$radio}), 
                    reactive({input$idrange})))
}
