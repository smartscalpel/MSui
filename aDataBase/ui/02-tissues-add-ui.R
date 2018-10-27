shinydashboard::tabItem(
        tabName = "tissuesadd",
        shinyBS::bsModal(
                id = "tissuesAddPatientModal",
                title = h4("Create a new patient"),
                trigger = "tissuesAddPatientModalCreate",
                div(
                        "The following patient will be added in table. If you want
                        to specify special information about patient, you should
                        add it via anouther tab."
                ),
                br(),
                DT::dataTableOutput(outputId = "tissuesAddTmpPatientTable"),
                br(),
                div(
                        "If you want to save table, just press Save. Otherwwise,
                        press Close."
                ),
                div(
                        align = "right",
                        actionButton(
                                inputId = "tissuesAddPatientModalSave",
                                label = "Save",
                                icon = icon("save")
                        )
                )
        ),
        
        
        
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
                                        inputId = "tissuesAddEmsId",
                                        label = "EmsId",
                                        width = "50%"
                                ),
                                
                                shiny::actionButton(
                                        inputId = "tissuesAddSearch",
                                        label = "Serach",
                                        icon = icon("search")
                                ),
                                
                                shiny::conditionalPanel(
                                        "output.tissuesAddFind == false",
                                        br(),
                                        shiny::htmlOutput(outputId = "tissuesAddMessgae")
                                ),
                                shiny::conditionalPanel(
                                        "output.tissuesAddPatient == true",
                                        br(),
                                        shiny::actionButton(
                                                inputId = "tissuesAddPatientModalCreate",
                                                label = "Create"
                                        )
                                ),
                                shiny::conditionalPanel(
                                        "output.tissuesAddFind == true",
                                        tissuesAddEntryUI(
                                                id = "tissuesAddEntry",
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
