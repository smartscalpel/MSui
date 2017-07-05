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
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Select Data to load"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput('inFile', 'Choose "interim.Rdat" File')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      DT::dataTableOutput("features",width = '80%')
    )
  )
))
