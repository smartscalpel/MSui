shinydashboard::tabItem(
        tabName = "patientsSnd",
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
                                        h2("ScalpelDB: Add Patient")
                                ),
                                
                                br(),
                                
                                div(
                                        "Let's create a new patient for you. Just fill the gaps below and press Enter."
                                ),
                                
                                br(),
                                
                                # EmsId
                                shiny::textInput(
                                        inputId = "patientsSndEmsId",
                                        label = "EmsId (required)",
                                        width = "50%"
                                ),
                                
                                # Select Sex
                                patientsSndSexSelectorUI(id = "patientsSndSexSelector"),
                                
                                # Select Year of Birth
                                patientsSndYobSelectorUI(id = "patientsSndYobSelector"),
                                
                                # Select Age
                                patientsSndAgeSelectorUI(id = "patientsSndAgeSelector"),
                                
                                div(
                                        align = "right",
                                        actionButton(
                                                inputId = "patientsSndSave",
                                                label = "Save",
                                                icon = icon("save")
                                        )
                                )
                        )
                ),
                shiny::column(
                        width = 3
                )
        )
)
