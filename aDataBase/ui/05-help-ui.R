shinydashboard::tabItem(
        tabName = "help",
        shiny::fluidRow(
                shiny::column(
                        width = 3
                ),
                shiny::column(
                        width = 6,
                        
                        box(
                                width = 12,
                                
                                div(
                                        align = "center",
                                        h2("ScalpelDB: Help")
                                ),
                                
                                br(),
                                
                                strong("Q: Question 1"),
                                p("A: Answer 1"),
                                
                                br(),
                                
                                strong("Q: Question 2"),
                                p("A: Answer 2")
                        )
                ),
                shiny::column(
                        width = 3
                )
        )
)
