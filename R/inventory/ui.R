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
      fluidRow(
      column(width=12,
             textOutput("rangesText"))
      ),
      fluidRow(column(width = 12,
                      DT::dataTableOutput("metaS",width = '80%')))
    ))
),
mainPanel(tabsetPanel(
#  tabPanel("Table", DT::dataTableOutput("table"), value = 1),
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
    title = "XIC",
    value = 2,
    wellPanel(fluidRow(column(
      width = 12,
      plotlyOutput("ticPlot",height = 300)
    )),
    fluidRow(column(
      width = 12,
      plotOutput("ecdfPlot",
                 height = 300,
                 dblclick = "ecdf_dblclick",
                 brush = brushOpts(id = "ecdf_brush",
                                   resetOnNew = TRUE))
    )))
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
    title = "PCA/NMDS",
    value = 6,
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "pcaScreePlot",
        height = 200)
      )
    ),
    fluidRow(column(
      width = 12,
      class = "well",
      plotlyOutput(
        "pcaIndPlot",
        height = 400)
    )
    ),
    fluidRow(column(
      width = 12,
      class = "well",
      plotlyOutput(
        "pcaVarPlot",
        height = 400
      )
    ))
  ),
  tabPanel(
    title = "Clustering",
    value = 8,
    fluidRow(column(
      width = 12,
      class = "well",
      plotOutput(
        "clusterPlot",
        height = 600)))
  ),
  tabPanel(
    title = "Classification",
    value = 9#,
  ),
  tabPanel("Features", value = 4,DT::dataTableOutput("features",width = '80%')
  )
))
)
)
)

