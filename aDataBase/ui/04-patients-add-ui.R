shinydashboard::tabItem(
        tabName = "patientsadd",
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
                                        inputId = "patientsAddEmsId",
                                        label = "EmsId (required)",
                                        width = "50%"
                                ),
                                
                                # Select Sex
                                patientsAddSexSelectorUI(id = "patientsAddSexSelector"),
                                
                                # Select Year of Birth
                                patientsAddYobSelectorUI(id = "patientsAddYobSelector"),
                                
                                # Select Age
                                patientsAddAgeSelectorUI(id = "patientsAddAgeSelector"),
                                
                                div(
                                        align = "right",
                                        actionButton(
                                                inputId = "patientsAddSave",
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
