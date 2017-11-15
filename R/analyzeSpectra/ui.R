#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = 'Data analysis'),
  dashboardSidebar(width = 350,
                   sidebarMenu(
                    # menuItem("Load data",tabName = 'File'),
                     menuItem("TIC plot",tabName = 'TIC'),
                     menuItem("XIC plots",tabName = 'XIC'),
                     menuItem("Baseline",tabName = 'baseline'),
                     menuItem("SNR",tabName = 'snr'),
                     fileInput('inFile', 'Choose CDF File'),
                     menuItem('Selectors',
                     sliderInput("sID",'Scan',min=1,max=2000,value = 1),
                     checkboxInput("scale", label = "Scale spectra", value = TRUE),
                     checkboxInput("corBL", label = "Correct baseline", value = TRUE),
                     checkboxInput("norm", label = "Normalize spectra", value = TRUE)),
                     menuItem('Fragments',
                              textInput('fragName',label = 'Fragment name',value = ''),
                              textInput('patID',label = 'Patient ID',value = ''),
                              textInput('fragType',label = 'Fragment type',value = 'h'),
                              verbatimTextOutput("textFrag"),
                              actionButton('addFrag','Add fragment'),
                              textInput('outFile',label = 'File name',value = 'dataset'),
                              downloadButton('saveBtn','Save dataset')),
                     menuItem('Analysis',
                              menuSubItem("Corrplot",tabName = 'corplot')
                     )
                     )),
  dashboardBody(
    tabItems(
      # tabItem('File',
      #         fluidRow(column(width = 12,
      #                         fileInput('inFile', 'Choose CDF File'))),
      #         fluidRow(column(width = 12,
      #                         DT::dataTableOutput("featuresRev",width = '80%')))
      # ),
      tabItem('TIC',plotOutput("ticPlot", height = 800,dblclick = "tic_dblclick",
                               brush = brushOpts(id = "tic_brush",
                                                 resetOnNew = TRUE))),
      tabItem('XIC',plotOutput("xicPlot", height = 800,dblclick = "xic_dblclick",
                               brush = brushOpts(id = "xic_brush",
                                                 resetOnNew = TRUE))),
      tabItem("baseline",plotOutput("blPlot", height = 800)),
      tabItem("snr",plotOutput("snrPlot", height = 800)),
      tabItem("corplot",
              fluidRow(column(
                width = 12,
                tabPanel("Metadata", tableOutput("metadata"))
              )),
              fluidRow(column(
                width = 12,
                tabPanel("Black List", 
                         textInput('blackList',label = 'Black List',value = ''),
                         actionButton("update" ,"Update View", icon("refresh"),
                                      class = "btn btn-primary"))
              )),
              fluidRow(column(
                width = 12,
                class = "well",plotOutput("corrPlot", height = 800))
              ))
    )
  ),
  title = "Dashboard example"
)
