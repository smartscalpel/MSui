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
shinyUI(shinyUI(navbarPage("My Application",
        tabPanel("Table", DT::dataTableOutput("table")),
        tabPanel(title="TIC", 
                 wellPanel(
                   fluidRow(
                     column(width=6,
                            h4("Select range ")),
                     column(width=2,
                            numericInput(
                              "beg", "First",
                              value = 1,
                              min = 1, max = 100, step = 1)
                     ),
                     column(width=2,
                            numericInput(
                              "fin", "Last",
                              value = 1,
                              min = 1, max = 100, step = 1)
                     )
                   ),
                   fluidRow(
                     column(width=12,
                   plotlyOutput("ticPlot")
                   ))
                   
                 )
                 ),
        tabPanel(title = "Spectr",
                 fluidRow(column(
                   4,
                   "Select spectr",
                   fluidRow(column(
                     width = 12,
                     fluidRow(column(
                       width = 12,
                       numericInput(
                         "spectr",
                         "ID",
                         value = 1,
                         min = 1,
                         max = 100,
                         step = 1
                       )
                     )),
                     fluidRow(column(width = 12,
                                     DT::dataTableOutput("metaS")))
                   ))),
                   column(
                     8,
                     "main",
                     
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
                   )
                   #                 )
                 )),
                 tabPanel("Features", tableOutput("features"))
)
    )
  )

