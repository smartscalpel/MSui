shinydashboard::tabItem(
        tabName = "tissuesadd",
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
                                        tissuesAddCreateTissueUI(id = "tissuesAddCreateTissue", diagnosisDictionary = diagnosisDictionary)
                                ),
                                shiny::conditionalPanel(
                                        "output.tissuesAddAdd == true",
                                        tissuesAddCreatePatientUI(id = "tissuesAddCreatePatient")
                                )
                        )
                ),
                shiny::column(
                        width = 3
                )
        )
)
