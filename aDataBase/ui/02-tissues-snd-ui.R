shinydashboard::tabItem(
        tabName = "tissuesSnd",
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
                                        inputId = "tissueSndEmsId",
                                        label = "EmsId",
                                        width = "50%"
                                ),
                                
                                shiny::actionButton(
                                        inputId = "tissueSndSearch",
                                        label = "Serach",
                                        icon = icon("search")
                                ),
                                
                                shiny::conditionalPanel(
                                        "output.tissuesSndFind == false",
                                        br(),
                                        shiny::htmlOutput(outputId = "tissuesSndMessgae")
                                ),
                                shiny::conditionalPanel(
                                        "output.tissuesSndFind == true",
                                        tissuesSndCreateTissueUI(
                                                id = "tissuesSndCreateTissue",
                                                diagnosisDictionary = diagnosisDictionary
                                        )
                                )
                        )
                ),
                shiny::column(
                        width = 3
                )
        )
)
