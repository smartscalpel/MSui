#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(shinyUI(pageWithSidebar(
  headerPanel("Brain tumor Mass spectra"),
  sidebarPanel(
    fluidRow(column(
      width = 12,
      fluidRow(column(
        width = 2,
        numericInput(
          "spectr",
          "ID",
          value = 1,
          min = 1,
          max = 100,
          step = 1
        )
      ),
      column(width=10,
             textOutput("rangesText"))
      ),
      fluidRow(column(width = 12,
                      DT::dataTableOutput("metaS",width = '80%')))
    ))
),
mainPanel(tabsetPanel(
#  tabPanel("Table", DT::dataTableOutput("table"), value = 1),
  tabPanel(
    title = "XIC",
    value = 2,
    wellPanel(fluidRow(
      column(
        width = 2,
        numericInput(
          "beg",
          "First",
          value = 1,
          min = 1,
          max = 100,
          step = 1
        )
      ),
      column(
        width = 2,
        numericInput(
          "fin",
          "Last",
          value = 2,
          min = 1,
          max = 100,
          step = 1
        )
      )
    ),
    fluidRow(column(
      width = 12,
      plotlyOutput("ticPlot",height = 300)
    )))
    # ,
    # fluidRow(column(
    #   width = 12,
    #   plotlyOutput("pcaPlot",height = 300)
    # )))
  ),
  tabPanel(
    title = "Spectr",
    value = 3,
    #                wellPanel(
    fluidRow(column(
      width = 12,
      tabPanel("Metadata", tableOutput("metadata"))
    )),
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "xicPlot",
        height = 300,
        dblclick = "xic_dblclick",
        brush = brushOpts(id = "xic_brush",
                          resetOnNew = TRUE)
      )
    )),
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "mzPlot",
        height = 300,
        dblclick = "mz_dblclick",
        brush = brushOpts(id = "mz_brush",
                          resetOnNew = TRUE)
      )
    ))
    
    #                 )
  ),
  tabPanel(
    title = "Time slices",
    value = 5,
    #                wellPanel(
    fluidRow(column(
      width = 10,
      tabPanel("MetadataTS", tableOutput("metadataTS"))
    ),
    column(width = 2, textOutput("spansText"))),
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "tsxicPlot",
        height = 100,
        dblclick = "tsxic_dblclick",
        brush = brushOpts(id = "tsxic_brush",
                          resetOnNew = TRUE)
      )
    )),
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput("tsPlot", height = 600)
    ))
  ),
  tabPanel(
    title = "PCA",
    value = 6,
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "pcaScreePlot",
        height = 100)
      )
    ),
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "pcaIndPlot",
        height = 300)
    )
    ),
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "pcaVarPlot",
        height = 300
      )
    ))
  ),
  tabPanel("Features", tableOutput("features"), value = 4)
))
)
)
)

