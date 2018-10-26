shinydashboard::tabItem(
        tabName = "patients",
        shiny::fluidRow(
                shiny::column(
                        width = 9,
                        shiny::fluidRow(
                                box(
                                        width = 12,
                                        div(
                                                style = "text-align: center;",
                                                h2("ScalpelDB: Patients")
                                        )
                                )
                                
                                
                        )
                ),
                shiny::column(
                        width = 3,
                        box(
                                width = 12,
                                title = "Filters"
                        )
                )
        )
)
