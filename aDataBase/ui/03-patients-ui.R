shinydashboard::tabItem(
        tabName = "patients",
        shiny::fluidRow(
                shiny::column(
                        width = 7,
                        shiny::fluidRow(
                                box(
                                        width = 12,
                                        div(
                                                style = "text-align: center;",
                                                h2("ScalpelDB: Patients"),
                                                br()
                                        ),
                                        
                                        # Show Screensaver, editable on readonly table depending on
                                        # patientsError and patientsEditableTable reactive values
                                        shiny::conditionalPanel(
                                                "output.patientsError == true",
                                                shiny::uiOutput("patientsScreensaver")
                                        ),
                                        
                                        shiny::conditionalPanel(
                                                "output.patientsError == false && output.patientsEditableTable == false",
                                                readOnlyUI(id = "patientsReadOnly")
                                        ),
                                        
                                        shiny::conditionalPanel(
                                                "output.patientsError == false && output.patientsEditableTable == true",
                                                editableUI(id = "patientsEditable")
                                        )
                                )
                        )
                ),
                shiny::column(
                        width = 5,
                        box(
                                width = 12,
                                title = "Filters",
                                
                                shiny::checkboxInput(inputId = "patientsEditableSelector", "Editable table"),
                                
                                # Select Sex
                                patientsSexSelectorUI(id = "patientsSexSelector"),
                                
                                # Select Age
                                patientsAgeSelectorUI(id = "patientsAgeSelector"),
                                
                                # Select Year of birth
                                patientsYobSelectorUI(id = "patientsYobSelector"),
                                
                                shiny::actionButton(inputId = "patientsSelect", label = "Select"),
                                
                                shiny::conditionalPanel(
                                        "output.patientsError == true",
                                        shiny::htmlOutput(outputId = "patientsErrorMessage")
                                )
                        )
                )
        )
)
