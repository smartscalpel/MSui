#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = 'Data analysis'),
  dashboardSidebar(width = 350,
                   sidebarMenu(
                     menuItem("Load data",tabName = 'File'),
                     menuItem("Feature table",tabName = 'Features'),
                     menuItem("Peak table",tabName = 'Peaks'),
                     menuItem("Feature plots",tabName = 'qplots'),
                     menuItem("Feature asses",tabName = 'mqplots')
                   )),
  dashboardBody(
    tabItems(
      tabItem('File',
              fluidRow(column(width = 12,
                fileInput('inFile', 'Choose "interim.Rdat" File'))),
              fluidRow(column(width = 12,
                DT::dataTableOutput("featuresRev",width = '80%')))
      ),
      tabItem('Features',DT::dataTableOutput("features",width = '80%')),
      tabItem('Peaks',DT::dataTableOutput("peaks",width = '80%')),
      tabItem("qplots",shinyjs::useShinyjs(),
              fluidRow(column(width = 1,actionButton("prevQ", "Prev")),
                       column(width=10,textOutput("qText")),
                       column(width=1,actionButton("nextQ", "Next"))
              ),
              fluidRow(column(width = 12,
                              class = "well",
                              plotOutput("qPlot", height = 900)))),
    tabItem("mqplots",shinyjs::useShinyjs(),
            fluidRow(column(width = 1,actionButton("prevQm", "Prev")),
                     column(width = 1,actionButton("yesQm", "Good")),
                     column(width = 1,actionButton("noQm", "Bad")),
                     column(width=8,textOutput("mqText")),
                     column(width=1,actionButton("nextQm", "Next"))
            ),
            fluidRow(column(width = 12,
                            class = "well",
                            plotOutput("mqPlot", height = 400))))
  )
),
  title = "Dashboard example"
)
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("Select Data to load"),
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#       fileInput('inFile', 'Choose "interim.Rdat" File')
#       ,textInput("collection_txt",label="Foo")
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#       DT::dataTableOutput("features",width = '80%')
#     )
#   )
# ))
