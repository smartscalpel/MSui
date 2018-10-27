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
                                        # tissuesError and editableTable reactive values
                                        
                                        shiny::conditionalPanel(
                                                "output.tissuesError == true",
                                                shiny::uiOutput("tissuesScreensaver")
                                        ),

                                        shiny::conditionalPanel(
                                                "output.tissuesError == false && output.editableTable == false",
                                                readOnlyUI(id = "tissuesReadOnly")
                                        ),

                                        shiny::conditionalPanel(
                                                "output.tissuesError == false && output.editableTable == true",
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
                                
                                shiny::checkboxInput(
                                        inputId = "tissuesEditableTableSelector",
                                        label = "Editable table"
                                ),
                                
                                # Avaliability in fridge
                                fridgeSelectorUI(id = "tissuesFridgeSelector"),
                                
                                # Select Sex
                                sexSelectorUI(id = "tissuesSexSelector"),
                                
                                # Select Age
                                ageRangeSelectorUI(id = "tissuesAgeRangeSelector"),
                                
                                # Select Diagnosis
                                diagnosisMultipleSelectorUI(
                                        id = "tissuesDiagnosisMultipleSelector",
                                        diagnosisDictionary$name
                                ),
                                
                                # Select Time
                                timeSelectorUI(id  = "tissuesTimeSelector"),
                                
                                shiny::actionButton(inputId = "tissuesSelect", label = "Select"),
                                
                                shiny::conditionalPanel(
                                        "output.tissuesError == true",
                                        shiny::htmlOutput(outputId = "tissuesErrorMessage")
                                )
                        )
                )
        )
)
