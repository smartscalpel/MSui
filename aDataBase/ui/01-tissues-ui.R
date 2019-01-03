shinydashboard::tabItem(
        tabName = "tissues",
        shiny::fluidRow(
                shiny::column(
                        width = 9,
                        shiny::fluidRow(
                                box(
                                        width = 12,
                                        div(
                                                style = "text-align: center;",
                                                h2("ScalpelDB: Tissues"),
                                                br()
                                        ),
                                        
                                        # Show Screensaver, editable on readonly table depending on
                                        # tissuesError and tissuesEditableTable reactive values
                                        shiny::conditionalPanel(
                                                "output.tissuesError == true",
                                                shiny::uiOutput("tissuesScreensaver")
                                        ),

                                        shiny::conditionalPanel(
                                                "output.tissuesError == false && output.tissuesEditableTable == false",
                                                readOnlyUI(id = "tissuesReadOnly")
                                        ),

                                        shiny::conditionalPanel(
                                                "output.tissuesError == false && output.tissuesEditableTable == true",
                                                editableUI(id = "tissuesEditable")
                                        )
                                )
                        )
                ),
                shiny::column(
                        width = 3,
                        box(
                                width = 12,
                                title = "Filters",
                                
                                shiny::checkboxInput(inputId = "tissuesEditableSelector", "Editable table"),
                                
                                # Avaliability in fridge
                                tissuesFridgeSelectorUI(id = "tissuesFridgeSelector"),
                                
                                # Select Sex
                                tissuesSexSelectorUI(id = "tissuesSexSelector"),
                                
                                # Select Age
                                tissuesAgeSelectorUI(id = "tissuesAgeSelector"),
                                
                                # Select Diagnosis
                                tissuesDiagnosisSelectorUI(
                                        id = "tissuesDiagnosisSelector",
                                        diagnosisDictionary$name
                                ),
                                
                                # Select Time
                                tissuesTimeSelectorUI(id  = "tissuesTimeSelector"),
                                
                                shiny::actionButton(inputId = "tissuesSelect", label = "Select"),
                                
                                shiny::conditionalPanel(
                                        "output.tissuesError == true",
                                        shiny::htmlOutput(outputId = "tissuesErrorMessage")
                                )
                        )
                )
        )
)
