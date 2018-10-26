shinydashboard::tabItem(
        tabName = "tissuesadd",
        shiny::fluidRow(
                shiny::column(
                        width = 4
                ),
                shiny::column(
                        width = 5,
                        
                        box(
                                width = 12,
                                
                                div(
                                        align = "center",
                                        h2("ScalpelDB: Add Tissue")
                                ),
                                
                                br(),
                                
                                h4("Check EmsId"),
                                
                                br(),
                                
                                div(
                                        "Let's create a new tissues entry for you. Firstly, you need to choose emsid.
                                        If a patient with given emsid exists, you need just fill the gaps below.
                                        Otherwise, we will ofer to create a new patient."
                                ),
                                
                                br(),
                                
                                shiny::textInput(
                                        inputId = "tissueAddEmsId",
                                        label = "EmsId",
                                        width = "50%"
                                ),
                                
                                shiny::actionButton(
                                        inputId = "tissueAddSearch",
                                        label = "Serach",
                                        icon = icon("search")
                                ),
                                
                                shiny::conditionalPanel(
                                        "output.tissuesAddFind == false",
                                        br(),
                                        shiny::htmlOutput(outputId = "tissuesAddMessgae")
                                ),
                                shiny::conditionalPanel(
                                        "output.tissuesAddFind == true",
                                        tissuesAddEntryUI(id = "tissuesAddEntry", diagnosisDictionary = diagnosisDictionary)
                                ),
                                shiny::conditionalPanel(
                                        "output.tissuesAddAdd == true",
                                        tissuesAddPatientUI(id = "tissuesAddPatient")
                                )
                        )
                ),
                shiny::column(
                        width = 3
                )
        )
)
