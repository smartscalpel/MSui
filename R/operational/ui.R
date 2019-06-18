#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

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
    tabPanel("Patients", DT::dataTableOutput("patient"), value = 1),
    tabPanel("Tissue", DT::dataTableOutput("tissue"), value = 1),
    tabPanel("Sample", DT::dataTableOutput("Sample"), value = 1),
    tabPanel("Features", value = 4,DT::dataTableOutput("features",width = '80%')
    )
  ))
)
)
)
